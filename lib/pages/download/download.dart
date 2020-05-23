import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/pages/home/loading.dart';
import 'package:flutter_downloader_example/pages/home/logic.dart';
import 'package:flutter_downloader_example/pages/photo_view/photo_view.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'myButton.dart';

/*
   floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: IconThemeData(size: 22.0),
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                tooltip: 'خصائص',
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                      child: Icon(Icons.arrow_upward),
                      backgroundColor: Colors.green,
                      onTap: () {
                        logic.scrollController.jumpTo(0.0);
                      }),
                  SpeedDialChild(
                    child: Icon(Icons.arrow_downward),
                    backgroundColor: Colors.red,
                    onTap: () {
                      logic.scrollController.jumpTo(
                          logic.scrollController.position.maxScrollExtent);
                    },
                  ),
                  /*SpeedDialChild(
                    child: Icon(Icons.delete_forever),
                    backgroundColor: Colors.red,
                    onTap: () {
                      FlutterDownloader.cancelAll();
                    },
                  ),*/
                ],
              ),
                            endDrawer: Drawer(
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: Size.fromHeight(screen.convert(250, height)),
                      child: DrawerHeader(
                        child: Center(
                            child: Column(
                          textDirection: TextDirection.rtl,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/logo.png',
                              height: screen.convert(80, height),
                              width: screen.convert(80, width),
                              fit: BoxFit.contain,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screen.convert(5, height))),
                            Text(
                              'Insta Down Pro',
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: screen.convert(30, aspectRatio),
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        )),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: screen.convert(10, width)),
                      onTap: () {
                        Share.share(
                            'شارك تطبيقانا مع اصدقائك لتعم الفائده  https://play.google.com/store/apps/details?id=com.instadown.pro',
                            subject: 'Look what I made!');
                      },
                      trailing: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.orange,
                        textDirection: TextDirection.rtl,
                      ),
                      title: Text(
                        'شارك التطبيق',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: screen.convert(20, aspectRatio),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        LaunchReview.launch(androidAppId: "com.instadown.pro");
                      },
                      trailing: Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: screen.convert(28, aspectRatio),
                      ),
                      title: Text(
                        'اعطنا تقييم',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: screen.convert(20, aspectRatio),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () async {
                        const url =
                            'https://t.me/joinchat/AAAAAFQB7H0Zwq7l4vI4Yg';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          logic.showSnackBar('هذا الرابط معطل الآن', false);
                        }
                      },
                      trailing: Icon(
                        FontAwesomeIcons.telegram,
                        color: Colors.orange,
                        size: screen.convert(28, aspectRatio),
                      ),
                      title: Text(
                        'تابعنا علي قناة التلجرام',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: screen.convert(20, aspectRatio),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

*/
class DownloadPage extends StatelessWidget {
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: false);
    var size = MediaQuery.of(context).size;

    return Consumer<Logic>(
      builder: (BuildContext context, Logic logic, Widget child) => SafeArea(
          child: Platform.isAndroid
              ? logic.permissionIsCheckingNow
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : logic.permissionState
                      ? DownloadBody()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Spacer(
                                flex: 2,
                              ),
                              Icon(
                                Icons.error,
                                color: Colors.orange,
                                size: 10.h,
                              ),
                              ButtonTheme(
                                minWidth: 200.w,
                                height: 60.h,
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    colorBrightness: Brightness.dark,
                                    color: Colors.purple,
                                    onPressed: () async {
                                      await logic.progressDialog.show();
                                      logic.permissionState =
                                          await logic.checkPermission();
//                                      logic.progressDialog.dismiss();

                                      logic.notifyListeners();
                                    },
                                    child: Text('اعطاء الإذن')),
                              ),
                              Spacer(
                                flex: 4,
                              ),
                            ],
                          ),
                        )
              : DownloadBody()),
    );
  }
}

class DownloadBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: true);
    var size = MediaQuery.of(context).size;

    return CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: logic.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            actions: <Widget>[SizedBox.shrink()],
            leading: IconButton(
                onPressed: () {
                  logic.scaffoldKey.currentState.openEndDrawer();
                },
                icon: Icon(Icons.menu)),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 310.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: 70.h),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: SlideTransition(
                        position: logic.errorTextFieldAnim,
                        child: Form(
                          key: logic.textFieldKey,
                          child: Stack(
                            children: <Widget>[
                              TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontWeight: FontWeight.w700),
                                controller: logic.controller,
                                validator: (text) =>
                                    logic.textFieldValidator(text),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.h,
                                      horizontal: 20.w,
                                    ),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: Colors.black.withOpacity(0.2)),
                                    helperText: '',
                                    hintText: 'instagram.com/dummy/dummy',
                                    errorStyle:
                                        TextStyle(fontWeight: FontWeight.w700),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.h)),
                                      borderSide: BorderSide(
                                        width: 1.w,
                                        color: Colors.red,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.link,
                                      color: Colors.purple,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.h)),
                                      borderSide: BorderSide(
                                        width: 1.8.w,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.h)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: 1.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.w)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: 1.w),
                                    ),
                                    labelStyle:
                                        GoogleFonts.cairo(color: Colors.green),
                                    labelText: 'الصق الرابط هنا'),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment(-0.92, -0.40),
                                  child: InkWell(
                                    onTap: () {
                                      print('!!');
                                      logic.clear();
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          size: 15.h,
                                        ),
                                      ),
                                      width: 25.w,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50.h),
                      child: ButtonTheme(
                        height: 60.h,
                        minWidth: 150.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MyButton('تأكيد', Colors.green, () {
                              logic.confirm(context);
                            }),
                            MyButton('لصق', Colors.purple, () {
                              logic.pasteUrl();
                            }),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 10.h,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, int i) {
              if (logic.posts[i].infoStatus == InfoStatus.loading)
                return Loading(i);
              else if (logic.posts[i].infoStatus == InfoStatus.success)
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 20.h, top: 10.h, right: 10.w, left: 10.w),
                      child: Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () async {
                                print('success');
                              },
                              child: Text('add')),
                          Row(
                            textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PhotoViewer(logic
                                                    .posts[i]
                                                    .history
                                                    .owner
                                                    .profilePicHd)));
                                  },
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      placeholder: (context, text) {
                                        return SizedBox(
                                            height: 65.h,
                                            width: 65.w,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      },
                                      width: 65.w,
                                      height: 65.h,
                                      fit: BoxFit.cover,
                                      imageUrl: logic
                                          .posts[i].history.owner.profilePic,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10.w)),
                              Expanded(
                                flex: 9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      logic.posts[i].history.owner.userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.sp),
                                    ),
                                    Text(
                                      logic.posts[i].history.date.toString(),
                                      style: GoogleFonts.cairo(fontSize: 12.sp),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    var post = logic.posts[i];
                                    var status =
                                        post.downloadCallbackModel?.status;
                                    if (status == DownloadTaskStatus.running ||
                                        logic.posts[i].downloadIsLocked) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (con) => AlertDialog(
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () async {
                                                      if (logic.posts[i]
                                                          .downloadIsLocked) {
                                                        logic.posts[i]
                                                                .isGoingToCancel =
                                                            true;
                                                      } else {
                                                        logic.cancelDownload(
                                                            logic.posts[i]
                                                                .taskId);
                                                      }
                                                      Navigator.pop(context);
                                                      logic.showSnackBar(
                                                          'تم ايقاف التنزيل',
                                                          false);
                                                    },
                                                    child: Text('نعم'),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('لا'),
                                                  )
                                                ],
                                                content: Text(
                                                    'هل تريد الغاء هذا التنزيل ؟'),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                              ));
                                    } else {
                                      logic.posts.removeAt(i);
                                      logic.notifyListeners();
                                    }
                                  },
                                  child: SizedBox(
                                    height: 30.h,
                                    width: 30.w,
                                    child: Material(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      color: Colors.red,
                                      type: MaterialType.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  '${logic.posts[i].getTitle}',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                logic.posts[i].history.title.length > 40
                                    ? InkWell(
                                        onTap: () {
                                          logic.showMore(i);
                                        },
                                        child: Text(
                                            logic.posts[i].fullTitle
                                                ? 'عرض اقل'
                                                : 'عرض المزيد',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  placeholder: (context, text) {
                                    return SizedBox(
                                        height: 400.h,
                                        width: 330.w,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  },
                                  imageUrl: logic.posts[i].history.thumbnail,
                                  height: 400.h,
                                  fit: BoxFit.cover,
                                  width: 330.w,
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                    alignment: Alignment(0.9, -0.9),
                                    child: Icon(logic.posts[i].history.isVideo
                                        ? FontAwesomeIcons.video
                                        : FontAwesomeIcons.image)),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 20.h)),
                          LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            value: logic.posts[i].downloadCallbackModel
                                            ?.progress ==
                                        null ||
                                    logic.posts[i].downloadCallbackModel
                                            .status ==
                                        DownloadTaskStatus.canceled
                                ? 0
                                : logic.posts[i].downloadCallbackModel.progress
                                        .toDouble() /
                                    100,
                            backgroundColor: Colors.purple.withOpacity(0.1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: ButtonTheme(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
//                                minWidth: width,
                                height: 70.h,
                                child: FlatButton.icon(
                                    colorBrightness: Brightness.dark,
                                    color: Colors.green,
                                    onPressed: logic
                                                .posts[i].downloadIsLocked ||
                                            logic.posts[i].downloadCallbackModel
                                                    ?.status ==
                                                DownloadTaskStatus.running ||
                                            logic.posts[i].downloadCallbackModel
                                                    ?.status ==
                                                DownloadTaskStatus.enqueued
                                        ? null
                                        : () {
                                            if (logic.posts[i].isGoingToCancel)
                                              logic.posts[i].isGoingToCancel =
                                                  false;
                                            if (logic.posts[i].buttonText ==
                                                'اكتمل التحميل افتح الآن') {
                                              logic.openDownload(
                                                  logic.posts[i].taskId);
                                            } else {
                                              logic.startDownload(context, i);
                                            }
                                          },
                                    icon: Icon(
                                      FontAwesomeIcons.download,
                                      size: 24.h,
                                    ),
                                    label: Text(
                                      logic.posts[i].downloadIsLocked
                                          ? 'جاري الاتصال بالانترنت'
                                          : logic.posts[i].buttonText,
                                      style: TextStyle(
                                          fontSize: 17.h,
                                          fontWeight: FontWeight.w700),
                                    ))),
                          ),
                          logic.posts[i].history.title.isEmpty &&
                                  logic.posts[i].history.hashtags.isEmpty
                              ? SizedBox.shrink()
                              : ButtonTheme(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  textTheme: ButtonTextTheme.primary,
                                  buttonColor: Colors.pink,
//                                  minWidth:
//                                      logic.posts[i].history.title.isEmpty ||
//                                              logic.posts[i].history.hashtags
//                                                  .isEmpty
//                                          ? width / 1.5
//                                          : screen.convert(150, width),
                                  height: 65.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        logic.posts[i].history.title.isEmpty ||
                                                logic.posts[i].history.hashtags
                                                    .isEmpty
                                            ? MainAxisAlignment.center
                                            : MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      logic.posts[i].history.hashtags.isEmpty
                                          ? SizedBox.shrink()
                                          : RaisedButton.icon(
                                              onPressed: logic.adStatus ==
                                                      AdStatus.loaded
                                                  ? () {
                                                      logic.copy(
                                                          context,
                                                          logic.posts[i].history
                                                              .hashtags);
                                                    }
                                                  : null,
                                              label: Text(
                                                logic.adStatus ==
                                                        AdStatus.loaded
                                                    ? 'نسخ الهاشتاق'
                                                    : 'جاري التجهيز',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              icon: Icon(
                                                Icons.ondemand_video,
                                                color: Colors.orange,
                                              ),
                                            ),
                                      logic.posts[i].history.title.isEmpty
                                          ? SizedBox.shrink()
                                          : RaisedButton.icon(
                                              icon: Icon(
                                                Icons.ondemand_video,
                                                color: Colors.orange,
                                              ),
                                              onPressed: logic.adStatus ==
                                                      AdStatus.loaded
                                                  ? () {
                                                      logic.copy(
                                                          context,
                                                          logic.posts[i].history
                                                              .title);
                                                    }
                                                  : null,
                                              label: Text(
                                                logic.adStatus ==
                                                        AdStatus.loaded
                                                    ? 'نسخ المحتوى'
                                                    : 'جاري التجهيز',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                    Divider()
                  ],
                );
              else if (logic.posts[i].infoStatus == null)
                return SizedBox.shrink();
              else
                return Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            height: 300.h,
                            color: Colors.grey.withOpacity(0.2),
                            child: Center(
                                child: Material(
                              type: MaterialType.circle,
                              color: Colors.green,
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                onTap: () async {
                                  var url = logic.posts[i].history.url;
                                  logic.posts[i] = Post(
                                    infoStatus: InfoStatus.loading,
                                  );
                                  logic.notifyListeners();

                                  logic.posts[i] =
                                      await logic.getVideoInfo(context, url);
                                  logic.notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Icon(
                                    Icons.replay,
                                    color: Colors.white,
                                    size: 70.h,
                                  ),
                                ),
                              ),
                            ))),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment(0.88, -0.85),
                            child: InkWell(
                              onTap: () {
                                print('!');
                                logic.posts.removeAt(i);
                                logic.notifyListeners();
                              },
                              child: SizedBox(
                                height: 30.h,
                                width: 30.w,
                                child: Material(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  color: Colors.red,
                                  type: MaterialType.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                );
            },
            childCount: logic.posts.length,
          )),
          SliverPadding(padding: EdgeInsets.only(bottom: 50.h))
        ]);
  }
}
