import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:html/dom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

typedef DownloadOperations(String id);

class Logic with ChangeNotifier {
  ReceivePort _port = ReceivePort();

  Logic() {
    FlutterDownloader.initialize();
    _bindBackgroundIsolate();
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

  Future<String> startDownload(String url, String name) async {
    return await FlutterDownloader.enqueue(
      savedDir: Constants.path,
      fileName: '$name.mp4',
      url: url,
    );
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

  void retryDownload(String id) async {
    String newTaskId = await FlutterDownloader.retry(taskId: id);
  }

  Future<Map<String, String>> getVideoInfo(String originalUrl) async {
    var response = await http.get(originalUrl);
    var body = parse(response.body);
    var document = body.body;

    String title =
        body.querySelector('meta[property="og:title"]').attributes['content'];

    title = title.substring(title.indexOf(':') + 1, title.length);
    var hashtagList = body.querySelectorAll('meta[property="video:tag"]');
    String thumbnail =
        body.querySelector('meta[property="og:image"]').attributes['content'];

    var hashtags = '';
    for (var element in hashtagList) {
      hashtags += '#${element.attributes['content']} ';
    }

    var text = document.querySelector('script[type="text/javascript"]').text;
    text = (text.substring(text.indexOf('{'), text.length - 1));
    Map<String, dynamic> decoded = jsonDecode(text);
    Map<String, dynamic> root =
        decoded['entry_data']['PostPage'][0]['graphql']['shortcode_media'];

    if (root.containsKey('video_url')) {
      return {
        'url': root['video_url'],
        'name': title,
        'hashtags': hashtags,
        'title': title,
        'thumbnail': thumbnail
      };
    } else {
      return {
        'hashtags': hashtags,
        'url': root['edge_sidecar_to_children']['edges'][0]['node']
            ['video_url'],
        'title': title,
        'thumbnail': thumbnail
      };
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);

    print(status.toString() + '!!!!!!!!!!!!!');
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
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });
  }
}
