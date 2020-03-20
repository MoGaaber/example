import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

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
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum AdStatus { rewarded, unRewarded, loading, loaded }

class Logic with ChangeNotifier {
  RegExp instagramUrlRegex =
      RegExp(r"instagram\.com/\D+/[-a-zA-Z0-9()@:%_\+.~#?&=]*/?");
  Animation<Offset> errorTextFieldAnim;
  AnimationController errorTextFieldCont;
  bool permissionState = true;
  bool permissionIsCheckingNow = true;
  AdStatus adStatus = AdStatus.loading;
  var textFieldKey = GlobalKey<FormState>();
  CancelableOperation<List<http.Response>> cancelableOperation;
  var posts = List<Post>();
  ReceivePort _port = ReceivePort();
  int postIndex;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Screen screen;
  RewardedVideoAd rewardedVideoAd;
  Tween<Offset> tween = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0));
  ProgressDialog progressDialog;
  InterstitialAd interstitialAd;
  TextEditingController controller = TextEditingController();
  bool rewardedVideoIsLoaded = false;
  BuildContext context;
  Logic(TickerProvider tickerProvider, BuildContext context) {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    rewardedVideoAd = RewardedVideoAd.instance;

    initializeRewardAdListener();
    checkPermission().then((x) {
      permissionIsCheckingNow = false;
      permissionState = x;
      notifyListeners();
    });

    progressDialog = new ProgressDialog(
      context,
      showLogs: true,
      isDismissible: true,
      type: ProgressDialogType.Normal,
    );

    WidgetsBinding.instance.waitUntilFirstFrameRasterized.then((x) async {
      await this.progressDialog.show();
      loadRewardedVideoAd();
    });

    this.context = context;
    errorTextFieldCont = AnimationController(
        vsync: tickerProvider, duration: Duration(milliseconds: 200));
    errorTextFieldAnim = tween.animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: errorTextFieldCont));
  }
  Future<String> findLocalPath(BuildContext context) async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void showMore(int index) {
    this.postIndex = index;
    posts[index].fullTitle = !posts[index].fullTitle;
    notifyListeners();
  }

  Future<void> pasteUrl(BuildContext context) async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data == null) {
      tween.begin = Offset(-0.02, 0);
      tween.begin = Offset(0.02, 0);

      TickerFuture tickerFuture = errorTextFieldCont.repeat(
        reverse: true,
      );

      tickerFuture.timeout(Duration(milliseconds: 600), onTimeout: () async {
        errorTextFieldCont.animateBack(0.5);
      });
      showSnackBar(context, 'لا يوجد اي نص فى الحافظة', false);
    } else {
      if (data.text.isEmpty) {
        showSnackBar(context, 'لا يوجد اي نص فى الحافظة', false);
        tween.begin = Offset(-0.02, 0);
        tween.begin = Offset(0.02, 0);

        TickerFuture tickerFuture = errorTextFieldCont.repeat(
          reverse: true,
        );

        tickerFuture.timeout(Duration(milliseconds: 600), onTimeout: () async {
          errorTextFieldCont.animateBack(0.5);
        });
      } else {
        controller.text = data?.text;
        textFieldKey.currentState.validate();
      }
    }
  }

  void testtt() {
    ProgressDialog(context).show();
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

  Future<bool> loadRewardedVideoAd() async {
    return rewardedVideoAd.load(
        adUnitId: RewardedVideoAd.testAdUnitId,
        targetingInfo: MobileAdTargetingInfo());
  }

  String copiedText = '';
  bool dontShowAgainCheckBox = true;
  Future<void> copy(BuildContext context, String text) async {
    if (adStatus == AdStatus.loaded) {
      this.copiedText = text;
      await progressDialog.show();
      SharedPreferences sharedPref = await SharedPreferences.getInstance();
      if (sharedPref.getBool('dontShowAgain') == null) {
        await sharedPref.setBool('dontShowAgain', false);
      }

      if (sharedPref.getBool('dontShowAgain')) {
        await rewardedVideoAd.show();
      } else {
        progressDialog.dismiss();
        showWarningDialog(context, sharedPref);
      }
    } else {
      showSnackBar(context, 'انتظر قليلا جاري تهيئه الاعلان', false);
    }
  }

  int status = 0;

  // 1 == loaded
  bool adIsLoaded = false;
  void initializeRewardAdListener() {
    rewardedVideoAd.listener = (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) async {
      print(event);
      if (event == RewardedVideoAdEvent.failedToLoad ||
          event == RewardedVideoAdEvent.closed) {
        progressDialog.dismiss();
        if (adStatus == AdStatus.rewarded) {
          showSnackBar(context, 'تم النسخ بنجاح', true);
        } else {
          showSnackBar(
              context, 'للاسف يجب انهاء الاهلان اولا لكي تستطيع النسخ', false);
        }
        adStatus = AdStatus.loading;
        await loadRewardedVideoAd();
      } else if (event == RewardedVideoAdEvent.loaded) {
        adStatus = AdStatus.loaded;
      } else if (event == RewardedVideoAdEvent.rewarded ||
          event == RewardedVideoAdEvent.completed) {
        adStatus = AdStatus.rewarded;

        await Clipboard.setData(ClipboardData(text: this.copiedText));
      }
    };
  }

  void showWarningDialog(BuildContext context, SharedPreferences sharedPref) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  AlertDialog(
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
                        Navigator.pop(context);
                        await progressDialog.show();

                        if (this.dontShowAgainCheckBox) {
                          await sharedPref.setBool('dontShowAgain', true);
                        }
                        await rewardedVideoAd.load(
                            adUnitId: RewardedVideoAd.testAdUnitId,
                            targetingInfo: MobileAdTargetingInfo());
                        progressDialog.dismiss();
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
                          value: this.dontShowAgainCheckBox,
                          onChanged: (bool value) {
                            setState(() {
                              this.dontShowAgainCheckBox = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void showSnackBar(BuildContext context, String text, bool success) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

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
    posts[index].downloadIsLocked = true;
    notifyListeners();
    await this.progressDialog.show();

    if (await DataConnectionChecker().hasConnection) {
      progressDialog.dismiss();
      interstitialAd?.show();

      posts[index].taskId = await FlutterDownloader.enqueue(
        savedDir: Constants.path,
        fileName: '${Uuid().v1()}',
        url: posts[index].downloadUrl,
      );
    } else {
      this.progressDialog.dismiss();
      posts[index].downloadIsLocked = false;
      notifyListeners();

      showSnackBar(context, 'يبدو ان هناك مشكله فى إتصالك بالإنترنت', false);
    }
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened ||
            event == MobileAdEvent.failedToLoad) {
          interstitialAd?.dispose();
          interstitialAd = createInterstitialAd();
          interstitialAd.load();
        }
        print(event);
      },
    );
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

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
      print(e);

      showSnackBar(context, 'ليبدو ان هناك مشكله فى الرابط المدخل', false);

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

      return null;
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
