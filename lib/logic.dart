import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:uuid/uuid.dart';

typedef DownloadOperations(String id);

class Logic with ChangeNotifier {
  List<Map> buttons;
  int index;
  var posts = List<Post>();
  TapGestureRecognizer tapGestureRecognizer;
  ReceivePort _port = ReceivePort();
  num progress = 0;
  int postIndex;
  void showMore() {
    this.postIndex = index;
    posts[index].fullTitle = !posts[index].fullTitle;
    notifyListeners();
  }

  Logic(TickerProvider tickerProvider) {
    _bindBackgroundIsolate();
    tapGestureRecognizer = TapGestureRecognizer();
    tapGestureRecognizer.onTap = showMore;
    rewardedVideoAd = RewardedVideoAd.instance;

    FlutterDownloader.registerCallback(downloadCallback);
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
    ];
  }
  TextEditingController controller = TextEditingController();

  Future<void> pasteUrl() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) {
    } else {
      controller.text = data?.text;
    }
  }

  RewardedVideoAd rewardedVideoAd;
  Future<void> copy(String text) async {
    await rewardedVideoAd.load(
      adUnitId: RewardedVideoAd.testAdUnitId,
      targetingInfo: MobileAdTargetingInfo(),
    );
    rewardedVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print(event);
      if (event == RewardedVideoAdEvent.loaded) {
        rewardedVideoAd.show();
      } else if (event == RewardedVideoAdEvent.completed ||
          event == RewardedVideoAdEvent.rewarded) {
        Clipboard.setData(ClipboardData(text: text));
      }
    };
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
      var text = controller.text;
      var regex = RegExp(r"instagram\.com/\D+/[-a-zA-Z0-9()@:%_\+.~#?&=]*/?");
      var url = regex.stringMatch(text);
      posts.add(Post(infoStatus: InfoStatus.loading));
      notifyListeners();
      if (!url.endsWith('/')) {
        url += '/';
      }
      url += '?__a=1';
      print(url);
      this.index = posts.length - 1;
      posts[this.index] = (await getVideoInfo('https://' + url));
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

  void cancelDownload(String id) async {
    await FlutterDownloader.cancel(taskId: id);
  }

  String buttonText(int index) {
    var post = posts[index];
    var downloadStatus = post.downloadCallbackModel?.status;

    if (downloadStatus == DownloadTaskStatus.complete) {
      return 'اكتمل التحميل';
    } else if (downloadStatus == null) {
      if (post.downloadIsLocked) {
        return 'جاري التحميل';
      } else {
        return 'ابدأ التحميل';
      }
    } else if (downloadStatus == DownloadTaskStatus.canceled) {
      post.downloadIsLocked = false;
      return 'تم الغاء التحميل اعده مره اخري';
    } else if (downloadStatus == DownloadTaskStatus.failed ||
        downloadStatus == DownloadTaskStatus.undefined) {
      post.downloadIsLocked = false;

      return 'فشل التحميل اعده مره اخري';
    } else {
      return 'انتظر جاري التحميل';
    }
  }

  Future<void> startDownload(int index) async {
    posts[index].downloadIsLocked = true;
    notifyListeners();
    if (await DataConnectionChecker().hasConnection) {
      print('has connect');
      posts[index].taskId = await FlutterDownloader.enqueue(
        savedDir: Constants.path,
        fileName: '${Uuid().v1()}.mp4',
        url: posts[index].downloadUrl,
      );
    } else {
      print('no connection');
    }
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

  void retryDownload(String id) async {
    String newTaskId = await FlutterDownloader.retry(taskId: id);
  }

  Future<Post> getVideoInfo(String url) async {
    var response;
    if (await DataConnectionChecker().hasConnection) {
      try {
        response = await http.get(url);
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          Map<String, dynamic> root =
              responseBody['graphql']['shortcode_media'];
          if (root.containsKey('edge_sidecar_to_children')) {
            var node = root['edge_sidecar_to_children'][0]['node'];
            if (node['isVideo']) {}
          } else {}
          Map<String, dynamic> ownerRoot = root['owner'];
          var userName = ownerRoot['username'];
          var profilePic = ownerRoot['profile_pic_url'];
          var date = root['taken_at_timestamp'];
          var thumbnail = root['display_url'];
          var isVideo = root['is_video'];
          var title = root['edge_media_to_caption']['edges'][0]['node']['text'];
          var downloadUrl;
          if (isVideo) {
            downloadUrl = root['video_url'];
          } else {
            downloadUrl = thumbnail;
          }
          List<String> hashtags = [];

          RegExp exp = new RegExp(r"(#\w+)");
          var matches = exp.allMatches(title).toList();

          for (int i = 0; i < matches.length; i++) {
            hashtags.add(title.substring(matches[i].start, matches[i].end));
          }
          return Post(
              infoStatus: InfoStatus.success,
              title: title,
              timeStamp: date,
              downloadUrl: downloadUrl,
              hashtags: hashtags.join(' '),
              thumbnail: thumbnail,
              owner: Owner(profilePic: profilePic, userName: userName));
        } else {
          print('!!!');
          return Post(infoStatus: InfoStatus.notFound);
        }
      } on SocketException {
        print('socket ex');
        return Post(infoStatus: InfoStatus.connectionError);
      }
    } else {
      print('hello no network');
      return Post(infoStatus: InfoStatus.connectionError);
    }
  }

  Widget downloadControl(int i) {
    var post = posts[i];
    var status = post.downloadCallbackModel?.status ?? null;
    if (status == DownloadTaskStatus.complete) {
      return PopupMenuButton(
          color: Colors.black,
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (_) => [PopupMenuItem(child: Text('test'))]);
    } else {
      return SizedBox.shrink();
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send(DownloadCallbackModel(progress, status, id));
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
      DownloadCallbackModel downloadCallbackModel = data;
      print(downloadCallbackModel.status.toString() + 'status !!!');
      print(downloadCallbackModel.progress.toString() + 'hello');
      print(downloadCallbackModel.id.toString() + '!!!!');
      int index = posts.indexWhere((post) {
        if (post.taskId == downloadCallbackModel.id) {
          return true;
        } else {
          return false;
        }
      });
      posts[index].downloadCallbackModel = downloadCallbackModel;
      print(downloadCallbackModel.status);
      notifyListeners();
    });
  }
}

/*
  void pauseDownload(String id) async {
    await FlutterDownloader.pause(taskId: id);
  }

  void resumeDownload(String id) async {
    await FlutterDownloader.resume(taskId: id);
  }
    BannerAd myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    myBanner
      ..load()
      ..show();
          playPauseCont = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: tickerProvider);

    animationController = AnimationController(
        vsync: tickerProvider, duration: Duration(seconds: 2));

    animation = Tween<double>(begin: 0, end: 360 / 360).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
  var arabicCharachterRegex = RegExp(
      r"[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");

 */
