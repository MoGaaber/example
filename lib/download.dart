import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:flutter_downloader_example/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'logic.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class DownloadPage extends StatelessWidget {
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  var x = 'https://www.instagram.com/p/B9zVp-spzWr/';

  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: true);
    var size = MediaQuery.of(context).size;
    Screen screen = Screen(size: size);
    var height = screen.height;
    var width = screen.width;
    var aspectRatio = screen.aspectRatio;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await FlutterDownloader.enqueue(
                      savedDir: Constants.path,
                      fileName: '${Uuid().v1()}.mp4',
                      url:
                          'https://scontent-hbe1-1.cdninstagram.com/v/t51.2885-15/e35/74395229_1112435768962251_2318090719322718848_n.jpg?_nc_ht=scontent-hbe1-1.cdninstagram.com&_nc_cat=103&_nc_ohc=nDdKzfmoawUAX8dcaeN&oh=d8d95461f60b802fbfdc314089ecfea8&oe=5E73AEFB',
                    );
                  },
                ),
                drawer: Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox.fromSize(
                        size: Size.fromHeight(screen.convert(250, height)),
                        child: DrawerHeader(
                          child: Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screen.convert(5, height))),
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
                              'شارك تطبيقانا مع اصدقائك لتعم الفائده  https://play.google.com/store/apps/details?id=com.HNY.qurancareem',
                              subject: 'Look what I made!');
                        },
                        leading: Icon(
                          FontAwesomeIcons.share,
                          color: Colors.orange,
                        ),
                        title: Text(
                          'شارك التطبيق',
                          style: TextStyle(
                            fontSize: screen.convert(20, aspectRatio),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        onTap: () {
                          LaunchReview.launch(
                              androidAppId: "com.usatolebanese");
                        },
                        leading: Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: screen.convert(28, aspectRatio),
                        ),
                        title: Text(
                          'اعطنا تقييم',
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
                            throw 'Could not launch $url';
                          }
                        },
                        leading: Icon(
                          FontAwesomeIcons.telegram,
                          color: Colors.orange,
                          size: screen.convert(28, aspectRatio),
                        ),
                        title: Text(
                          'تابعنا علي قناة التلجرام',
                          style: TextStyle(
                            fontSize: screen.convert(20, aspectRatio),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                body: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: ListView(
                      padding: EdgeInsets.only(
                          top: screen.convert(30, height),
                          bottom: screen.convert(50, height)),
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              right: screen.convert(10, width),
                              left: screen.convert(10, width),
                              bottom: screen.convert(10, height)),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Form(
                                  key: logic.key,
                                  child: Stack(
                                    children: <Widget>[
                                      TextFormField(
                                        controller: logic.controller,
                                        validator: (String text) {
                                          if (text.isEmpty) {
                                            return '';
                                          }
                                          var regex = RegExp(
                                              r"instagram\.com/\D+/\w+/?");
                                          if (regex
                                                  .allMatches(text)
                                                  .toList()
                                                  .length !=
                                              1) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
/*
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: screen.convert(
                                                        20, width),
                                                    vertical: screen.convert(
                                                        20, height)),
*/
                                            helperText: ' ',
                                            errorStyle: TextStyle(
                                                fontWeight: FontWeight.w700),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                width: screen.convert(3, width),
                                                color: Colors.red,
                                              ),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.link,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: BorderSide(
                                                width: screen.convert(2, width),
                                                color: Colors.purple,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.purple,
                                                  width:
                                                      screen.convert(2, width)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              borderSide: BorderSide(
                                                  color: Colors.purple
                                                      .withOpacity(0.5),
                                                  width:
                                                      screen.convert(2, width)),
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w700),
                                            labelText: 'الصق الرابط هنا'),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment(-0.95, -0.40),
                                          child: InkWell(
                                            onTap: () {
                                              print('!!');
                                              logic.clear();
                                            },
                                            child: Container(
                                              child: Center(
                                                child: Icon(
                                                  Icons.clear,
                                                  size: screen.convert(
                                                      15, aspectRatio),
                                                ),
                                              ),
                                              width: screen.convert(30, width),
                                              height: screen.convert(30, width),
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
                              Center(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screen.convert(10, width)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    for (int i = 0; i < 2; i++)
                                      ButtonTheme(
                                        minWidth: screen.convert(140, width),
                                        height: screen.convert(50, height),
                                        child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7))),
                                            color: logic.buttons[i]['color'],
                                            onPressed: () {
                                              logic.buttons[i]['onPressed']();
                                            },
                                            child: Text(
                                              logic.buttons[i]['text'],
                                              style: GoogleFonts.cairo(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: screen.convert(
                                                      20, aspectRatio)),
                                            )),
                                      ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        Divider(
                          indent: screen.convert(30, width),
                          endIndent: screen.convert(30, width),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        for (int i = 0; i < logic.posts.length; i++)
                          if (logic.posts[i].infoStatus == InfoStatus.loading)
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                screen.convert(10, width),
                                            vertical:
                                                screen.convert(20, height)),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Shimmer.fromColors(
                                                enabled: true,
                                                baseColor: Color(0xffE9E9E9),
                                                highlightColor: Colors.white,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                  width:
                                                      screen.convert(60, width),
                                                  height: screen.convert(
                                                      60, height),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top:
                                                      screen.convert(8, height),
                                                  left:
                                                      screen.convert(8, width)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Shimmer.fromColors(
                                                    enabled: true,
                                                    baseColor:
                                                        Color(0xffE9E9E9),
                                                    highlightColor:
                                                        Colors.white,
                                                    child: Container(
                                                      height: screen.convert(
                                                          12, height),
                                                      width: screen.convert(
                                                          150, width),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: screen.convert(
                                                              10, height))),
                                                  Shimmer.fromColors(
                                                    enabled: true,
                                                    baseColor:
                                                        Color(0xffE9E9E9),
                                                    highlightColor:
                                                        Colors.white,
                                                    child: Container(
                                                      height: screen.convert(
                                                          10, height),
                                                      width: screen.convert(
                                                          120, width),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(
                                              flex: 1,
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {})
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          for (int i = 1; i < 5; i++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top:
                                                      screen.convert(5, height),
                                                  bottom:
                                                      screen.convert(5, height),
                                                  right: screen.convert(
                                                          20.0, width) *
                                                      i,
                                                  left: screen.convert(
                                                      10, width)),
                                              child: Shimmer.fromColors(
                                                enabled: true,
                                                baseColor: Color(0xffE9E9E9),
                                                highlightColor: Colors.white,
                                                child: Container(
                                                  height:
                                                      screen.convert(4, height),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: screen.convert(10, height))),
                                      Center(
                                        child: Shimmer.fromColors(
                                          enabled: false,
                                          highlightColor: Colors.grey,
                                          baseColor: Color(0xffE9E9E9),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            height: screen.convert(200, height),
                                            width: screen.convert(330, width),
                                          ),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            )
                          else if (logic.posts[i].infoStatus ==
                              InfoStatus.success)
                            Column(
                              children: <Widget>[
                                Card(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                screen.convert(4, width)),
                                        child: Row(
                                          textDirection: TextDirection.ltr,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              placeholder: (context, text) {
                                                return SizedBox(
                                                    height: screen.convert(
                                                        60, height),
                                                    width: screen.convert(
                                                        60, width),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()));
                                              },
                                              width: screen.convert(60, width),
                                              height:
                                                  screen.convert(60, height),
                                              fit: BoxFit.cover,
                                              imageUrl: logic
                                                  .posts[i].owner.profilePic,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      screen.convert(6, width)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    logic.posts[i].owner
                                                        .userName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize:
                                                            screen.convert(20,
                                                                aspectRatio)),
                                                  ),
                                                  Text(
                                                    logic.posts[i].date
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 2),
                                                  child: InkWell(
                                                    onTap: () {
                                                      var post = logic.posts[i];
                                                      var status = post
                                                          .downloadCallbackModel
                                                          ?.status;
                                                      if (status ==
                                                          DownloadTaskStatus
                                                              .running) {
                                                        logic.cancelDownload(
                                                            post.taskId);
                                                      } else {
                                                        logic.posts.removeAt(i);
                                                        logic.notifyListeners();
                                                      }
                                                    },
                                                    child: SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Material(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors.red,
                                                        type:
                                                            MaterialType.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                logic.downloadControl(i),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              screen.convert(8, aspectRatio)),
                                          child: Text.rich(
                                            TextSpan(
                                              text: logic.posts[i].getTitle,
                                              style: TextStyle(
                                                  fontSize: screen.convert(
                                                      15, aspectRatio),
                                                  fontWeight: FontWeight.w700),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    recognizer: logic
                                                        .tapGestureRecognizer,
                                                    text:
                                                        logic.posts[i].fullTitle
                                                            ? 'عرض اقل'
                                                            : ' عرض المزيد',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          )

/*
                                        Text(
                                          logic.posts[i].firstPart,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screen.convert(
                                                  15, aspectRatio),
                                              fontWeight: FontWeight.w700),
                                        ),
*/
                                          ),
                                      Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            placeholder: (context, text) {
                                              return SizedBox(
                                                  height: screen.convert(
                                                      250, height),
                                                  width: screen.convert(
                                                      330, width),
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            },
                                            imageUrl: logic.posts[i].thumbnail,
                                            height: screen.convert(250, height),
                                            fit: BoxFit.cover,
                                            width: screen.convert(330, width),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                screen.convert(12, height)),
                                        child: Center(
                                            child: SizedBox(
                                          child: LinearProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.green),
                                            value: logic
                                                            .posts[i]
                                                            .downloadCallbackModel
                                                            ?.progress
                                                            ?.toDouble() ==
                                                        null ||
                                                    logic
                                                            .posts[i]
                                                            .downloadCallbackModel
                                                            .status ==
                                                        DownloadTaskStatus
                                                            .canceled
                                                ? 0
                                                : logic
                                                        .posts[i]
                                                        .downloadCallbackModel
                                                        .progress
                                                        .toDouble() /
                                                    100,
                                            backgroundColor:
                                                Colors.purple.withOpacity(0.1),
                                          ),
                                        )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                screen.convert(20, height)),
                                        child: ButtonTheme(
                                            minWidth: width,
                                            height: 60,
                                            child: FlatButton.icon(
                                                colorBrightness:
                                                    Brightness.dark,
                                                color: Colors.green,
                                                onPressed: logic.posts[i]
                                                        .downloadIsLocked
                                                    ? null
                                                    : () {
                                                        logic.startDownload(i);
                                                      },
                                                icon: Icon(
                                                    FontAwesomeIcons.download),
                                                label: Text(
                                                  logic.buttonText(i),
                                                  style: TextStyle(
                                                      fontSize: screen.convert(
                                                          16, aspectRatio),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ))),
                                      ),
                                      ButtonTheme(
                                        height: screen.convert(60, height),
                                        minWidth: screen.convert(150, width),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            FlatButton.icon(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                colorBrightness:
                                                    Brightness.dark,
                                                color: Colors.purple,
                                                onPressed: () {
                                                  logic.copy(
                                                      logic.posts[i].hashtags);
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.hashtag,
                                                  color: Colors.amber,
                                                ),
                                                label: Text(
                                                  'نسخ الهاشتاق',
                                                  style: TextStyle(
                                                      fontSize: screen.convert(
                                                          16, aspectRatio),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                            FlatButton.icon(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                colorBrightness:
                                                    Brightness.dark,
                                                color: Colors.purple,
                                                onPressed: () {
                                                  logic.copy(
                                                      logic.posts[i].title);
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.copy,
                                                  color: Colors.amber,
                                                ),
                                                label: Text(
                                                  'نسخ المحتوى',
                                                  style: TextStyle(
                                                      fontSize: screen.convert(
                                                          16, aspectRatio),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else if (logic.posts[i].infoStatus ==
                                  InfoStatus.notFound ||
                              logic.posts[i].infoStatus ==
                                  InfoStatus.connectionError)
                            SizedBox.shrink()
                          else
                            InkWell(
                              onTap: () {},
                              child: Container(
                                  height: 300,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Center(
                                      child: Material(
                                    type: MaterialType.circle,
                                    color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.replay,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                    ),
                                  ))),
                            ),
                      ],
                    )))));
  }
}
