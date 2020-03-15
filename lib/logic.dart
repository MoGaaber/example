import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:uuid/uuid.dart';

typedef DownloadOperations(String id);

class Logic with ChangeNotifier {
  List<Map> buttons;
  var posts = List<Post>();
  ReceivePort _port = ReceivePort();
  num progress = 0;
  Animation<double> animation;
  AnimationController animationController;
  Logic(TickerProvider tickerProvider) {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    animationController = AnimationController(
        vsync: tickerProvider, duration: Duration(seconds: 2));

    animation = Tween<double>(begin: 0, end: 360 / 360).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    buttons = [
      {
        'text': 'تأكيد',
        'color': Colors.green,
        'onPressed': () {
          confirm();
        }
      },
      {
        'text': 'لصق',
        'color': Colors.purple,
        'onPressed': () {
          pasteUrl();
        }
      },
      {'text': 'إلغاء', 'color': Colors.purple, 'onPressed': () {}}
    ];
  }
  TextEditingController controller = TextEditingController();

  Future<void> pasteUrl() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    controller.text = data.text;
  }

  void showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
    ));
  }

  var key = GlobalKey<FormState>();

  Future<void> confirm() async {
    var isValid = key.currentState.validate();
    if (isValid) {
      posts.add(null);
      notifyListeners();
      posts[posts.length - 1] = (await getVideoInfo(controller.text));
      notifyListeners();
    }
  }

  void clear() {
    controller.clear();
  }

  void downloadOperations(String id, DownloadOperations downloadOperations) {
    downloadOperations(id);
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void pauseDownload(String id) async {
    await FlutterDownloader.pause(taskId: id);
  }

  void resumeDownload(String id) async {
    await FlutterDownloader.resume(taskId: id);
  }

  void cancelDownload(String id) async {
    await FlutterDownloader.cancel(taskId: id);
  }

  Future<String> startDownload(
    String url,
  ) async {
    return await FlutterDownloader.enqueue(
      savedDir: Constants.path,
      fileName: '${Uuid().v1()}.mp4',
      url: url,
    );
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

  void retryDownload(String id) async {
    String newTaskId = await FlutterDownloader.retry(taskId: id);
  }

  Future<Post> getVideoInfo(String originalUrl) async {
    var response = await http.get(originalUrl);
    
    var htmlDocument = parse(response.body);
    var htmlBody = htmlDocument.body;
    var scriptElement =
        htmlBody.querySelector('script[type="text/javascript"]').text;

    var mappedScriptElement = jsonDecode(scriptElement.substring(
        scriptElement.indexOf('{'), scriptElement.length - 1));

    Map<String, dynamic> scriptElementRoot = mappedScriptElement['entry_data']
        ['PostPage'][0]['graphql']['shortcode_media'];

// get title of video or image
    String title = htmlDocument
        .querySelector('meta[property="og:title"]')
        .attributes['content'];

    title = title.substring(title.indexOf(':') + 1, title.length);

    var date = jsonDecode(htmlDocument
        .querySelector('script[type="application/ld+json"]')
        .text)['uploadDate'];

    var owner = scriptElementRoot['owner'];

    var profilePic = owner['profile_pic_url'];
    var userName = owner['username'];
    var thumbnail = scriptElementRoot['display_url'];

    // get hashtags and video
    var type = htmlDocument
        .querySelector('meta[property="og:type"]')
        .attributes['content'];

    var propertyHashtagName;

    var downloadLink;

    if (scriptElementRoot.containsKey('video_url')) {
      downloadLink = scriptElementRoot['video_url'];
    } else if (scriptElementRoot.containsKey('edge_sidecar_to_children')) {
      downloadLink = scriptElementRoot['edge_sidecar_to_children']['edges'][0]
          ['node']['video_url'];
    } else {
      downloadLink = thumbnail;
    }

    if (type == 'video') {
      propertyHashtagName = 'video:tag';
    } else {
      propertyHashtagName = 'instapp:hashtags';
    }
    var hashtagList =
        htmlDocument.querySelectorAll('meta[property="$propertyHashtagName"]');

    var hashtags = '';
    for (var element in hashtagList) {
      hashtags += '#${element.attributes['content']} ';
    }

    return Post(
        title: title,
        date: date,
        downloadUrl: downloadLink,
        hashtags: hashtags,
        thumbnail: thumbnail,
        owner: Owner(profilePic: profilePic, userName: userName));
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
/*
      notifyListeners();
      int index = posts.indexWhere((post) {
        if (post.taskId == data['id']) {
          return true;
        } else {
          return false;
        }
      });
      posts[index].taskId = data['id'];
*/
    });
  }
}
