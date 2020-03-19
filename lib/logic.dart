import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:async/async.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/button_State.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:flutter_downloader_example/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef DownloadOperations(String id);

class Logic with ChangeNotifier {
  List<Map> buttons;
  int index;
  RegExp instagramUrlRegex;
  var posts = List<Post>();
  TapGestureRecognizer tapGestureRecognizer;
  ReceivePort _port = ReceivePort();
  num progress = 0;
  int postIndex;
  GlobalKey<ScaffoldState> globalKey = GlobalKey();
  Screen screen;
  void showMore(int index) {
    this.postIndex = index;
    posts[index].fullTitle = !posts[index].fullTitle;
    notifyListeners();
  }

  ProgressDialog progressDialog;

  Logic(TickerProvider tickerProvider, BuildContext context) {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    instagramUrlRegex =
        RegExp(r"instagram\.com/\D+/[-a-zA-Z0-9()@:%_\+.~#?&=]*/?");
    progressDialog = new ProgressDialog(
      context,
      showLogs: true,
      isDismissible: false,
      type: ProgressDialogType.Normal,
    );
    rewardedVideoAd = RewardedVideoAd.instance;
  }

  TextEditingController controller = TextEditingController();

  Future<void> pasteUrl(BuildContext context) async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data.text == null || data.text.isEmpty) {
      showSnackBar(context, 'لا يوجد اي نص فى الحافظة', false);
    } else {
      controller.text = data?.text;
      textFieldKey.currentState.validate();
    }
  }

  String textFieldValidator(BuildContext context, String text) {
    if (text.isEmpty) {
      showSnackBar(context, 'لم يتم ادخال الرابط', false);
      return '';
    }
    if (instagramUrlRegex.allMatches(text).toList().length != 1) {
      showSnackBar(context, 'الرابط المدخل غير صحيح', false);
      return '';
    } else {
      return null;
    }
  }

  RewardedVideoAd rewardedVideoAd;
  void showAd() async {
    rewardedVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        progressDialog.dismiss();
        rewardedVideoAd.show();
      }
    };

    await rewardedVideoAd.load(
      adUnitId: RewardedVideoAd.testAdUnitId,
      targetingInfo: MobileAdTargetingInfo(),
    );
  }

  bool isFirstTime = true;
  Future<void> testAd() async {
    if (isFirstTime) {
      await rewardedVideoAd.load(
          adUnitId: RewardedVideoAd.testAdUnitId,
          targetingInfo: MobileAdTargetingInfo());
    } else {
      await rewardedVideoAd.show();
    }
    rewardedVideoAd.listener = (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) async {
      print(event);
      if (event == RewardedVideoAdEvent.started) {
        await rewardedVideoAd.load(
            adUnitId: RewardedVideoAd.testAdUnitId,
            targetingInfo: MobileAdTargetingInfo());
      } else if (event == RewardedVideoAdEvent.loaded && isFirstTime) {
        isFirstTime = false;

        rewardedVideoAd.show();
      }
    };
  }

  bool dontShowAgain = false;
  int status = 0;
  Future<void> copy(BuildContext context, String text) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    rewardedVideoAd.listener = (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) async {
      if (event == RewardedVideoAdEvent.loaded) {
        await progressDialog.hide();
        rewardedVideoAd.show();
      } else if (event == RewardedVideoAdEvent.completed ||
          event == RewardedVideoAdEvent.rewarded) {
        await Clipboard.setData(ClipboardData(text: text));
        showSnackBar(context, 'تم النسخ بنجاح', true);
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        await rewardedVideoAd.load(
            adUnitId: RewardedVideoAd.testAdUnitId,
            targetingInfo: MobileAdTargetingInfo());
      }
    };
    if (sharedPref.getBool('dontShowAgain')) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                titleTextStyle: GoogleFonts.cairo(fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showSnackBar(context,
                            'يجب مشاهده الاعلان اولا كى تستطيع النسخ', false);
                      },
                      child: Text('لا أوافق')),
                  FlatButton(
                      onPressed: () async {
                        if (this.dontShowAgain) {
                          await progressDialog.show();
                          await sharedPref.setBool('dontShowAgain', true);
                          await rewardedVideoAd.load(
                              adUnitId: RewardedVideoAd.testAdUnitId,
                              targetingInfo: MobileAdTargetingInfo());
                        }
                      },
                      child: Text('نعم اوافق')),
                ],
                title: Center(
                    child: Text(
                  'إخطار',
                  style: TextStyle(color: Colors.black),
                )),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'هل توافق على مشاهده اعلان فى كل مره قبل عمليه النسخ ؟',
                      textDirection: TextDirection.rtl,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'لا أريد رؤيه هذا مجددا',
                          style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Checkbox(
                          value: this.dontShowAgain,
                          onChanged: (bool value) {
                            this.dontShowAgain = value;
                            notifyListeners();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ));
    } else {
      await progressDialog.show();
      await rewardedVideoAd.load(
          adUnitId: RewardedVideoAd.testAdUnitId,
          targetingInfo: MobileAdTargetingInfo());
    }
  }

  void showSnackBar(BuildContext context, String text, bool success) {
    globalKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

  var textFieldKey = GlobalKey<FormState>();
  CancelableOperation<Post> operation;

  Future<void> confirm(BuildContext context) async {
    var isValid = textFieldKey.currentState.validate();
    if (isValid) {
      var text = controller.text;
      var regex = RegExp(r"instagram\.com/\D+/[-a-zA-Z0-9()@:%_\+.~#?&=]*/?");
      var url = regex.stringMatch(text);
      if (!url.endsWith('/')) {
        url += '/';
      }
      posts.add(Post(infoStatus: InfoStatus.loading, url: url));
      int index = posts.length - 1;

      notifyListeners();

      posts[index] = await getVideoInfo(context, 'https://' + url);
      if (posts[index] == null) {
        posts.removeAt(index);
      }

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

  ButtonState buttonState(int index) {
    var post = posts[index];
    var downloadStatus = post.downloadCallbackModel?.status;
    if (downloadStatus == DownloadTaskStatus.complete) {
      return ButtonState('اكتمل التحميل افتح الآن', locked: false);
    } else if (downloadStatus == null) {
      if (post.downloadIsLocked) {
        return ButtonState('فى انتظار شبكه الانترنت');
      } else {
        return ButtonState('ابدأ التحميل', locked: false);
      }
    } else if (downloadStatus == DownloadTaskStatus.canceled) {
      return ButtonState('تم الغاء التحميل اعده مره اخري', locked: false);
    } else if (downloadStatus == DownloadTaskStatus.failed ||
        downloadStatus == DownloadTaskStatus.undefined) {
      return ButtonState('فشل التحميل اعده مره اخري', locked: false);
    } else {
      return ButtonState('انتظر جاري التحميل');
    }
  }

  Future<void> startDownload(BuildContext context, int index) async {
    await this.progressDialog.show();
    if (await DataConnectionChecker().hasConnection) {
      posts[index].downloadIsLocked = true;

      notifyListeners();

      posts[index].taskId = await FlutterDownloader.enqueue(
        savedDir: Constants.path,
        fileName: '${Uuid().v1()}',
        url: posts[index].downloadUrl,
      );
    } else {
      showSnackBar(context, 'يبدو ان هناك مشكله فى إتصالك بالإنترنت', false);
      this.progressDialog.dismiss();
    }
    progressDialog.dismiss();
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

  void retryDownload(String id) async {
    String newTaskId = await FlutterDownloader.retry(taskId: id);
  }

  CancelableOperation<List<http.Response>> cancelableOperation;

  Future<Post> getVideoInfo(BuildContext context, String url) async {
    cancelableOperation = CancelableOperation.fromFuture(
        Future.wait([http.get(url + '?__a=1'), http.get(url)]), onCancel: () {
      showSnackBar(context, 'تم ايقاف عرض المنشور بنجاح', true);
    });

    List<http.Response> responses;
    try {
      responses = await cancelableOperation.value;
    } on SocketException {
      showSnackBar(context, 'يبدو ان هناك مشكله فى إتصالك بالإنترنت', false);

      return Post(infoStatus: InfoStatus.connectionError, url: url);
    } catch (e) {
      print(e.toString());
      showSnackBar(context, 'يبدو ان هناك مشكله فى الرابط المدخل', false);

      return null;
    }
    var apiResponse = responses[0];
    var htmlResponse = responses[1];
    if (apiResponse.statusCode == 200 && htmlResponse.statusCode == 200) {
      try {
        var htmlDocument = parse(htmlResponse.body);
        var type = htmlDocument
            .querySelector('meta[property="og:type"]')
            .attributes['content'];
        String propertyHashtagName;
        if (type == 'video') {
          propertyHashtagName = 'video:tag';
        } else {
          propertyHashtagName = 'instapp:hashtags';
        }
        String hashtags = '';
        var hashtagList = htmlDocument
            .querySelectorAll('meta[property="$propertyHashtagName"]');
        if (hashtagList.isNotEmpty) {
          for (var hashtag in hashtagList) {
            hashtags += '#${hashtag.attributes['content']} ';
          }
        }
        Map<String, dynamic> responseBody = jsonDecode(apiResponse.body);
        Map<String, dynamic> root = responseBody['graphql']['shortcode_media'];
        Map<String, dynamic> ownerRoot = root['owner'];
        var userName = ownerRoot['username'];
        var profilePic = ownerRoot['profile_pic_url'];
        var date = root['taken_at_timestamp'];
        var thumbnail = root['display_url'];
        String downloadUrl;
        bool isVideo;
        if (root.containsKey('edge_sidecar_to_children')) {
          var node = root['edge_sidecar_to_children']['edges'][0]['node'];
          isVideo = node['is_video'];
          if (isVideo) {
            downloadUrl = node['video_url'];
          } else {
            downloadUrl = thumbnail;
          }
        } else {
          isVideo = root['is_video'];
          if (isVideo) {
            downloadUrl = root['video_url'];
          } else {
            downloadUrl = thumbnail;
          }
        }
        String title;
        List titleEdges = root['edge_media_to_caption']['edges'];
        if (titleEdges.isEmpty) {
          title = '';
        } else {
          title = titleEdges[0]['node']['text'];
        }
        return Post(
            infoStatus: InfoStatus.success,
            title: title,
            timeStamp: date,
            downloadUrl: downloadUrl,
            hashtags: hashtags,
            thumbnail: thumbnail,
            owner: Owner(profilePic: profilePic, userName: userName));
      } catch (e) {
        print(e.toString() + '!');

        showSnackBar(context, 'يبدو ان هناك مشكله فى الرابط المدخل', false);
      }
    } else {
      showSnackBar(context, 'يبدو ان هناك مشكله فى الرابط المدخل', false);

      print('!!!');

      return null;
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
      int index = posts.indexWhere((post) {
        if (post.taskId == downloadCallbackModel.id) {
          return true;
        } else {
          return false;
        }
      });
      posts[index].downloadCallbackModel = downloadCallbackModel;

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
