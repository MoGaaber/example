import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'logic.dart';

class DownloadPage extends StatelessWidget {
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  String test = 'انا اسمى محمد gaber';

  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: true);
    print(logic.controller.text);
    List<int> hashtags = [1, 2, 3, 4];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size.fromHeight(250),
                child: DrawerHeader(
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    ],
                  )),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                onTap: () {
                  Share.share(
                      'شارك تطبيقانا مع اصدقائك لتعم الفائده  https://play.google.com/store/apps/details?id=com.HNY.qurancareem',
                      subject: 'Look what I made!');
                },
                leading: Icon(FontAwesomeIcons.share),
                title: Text(
                  'شارك التطبيق',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  LaunchReview.launch(androidAppId: "com.usatolebanese");
                },
                leading: Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 28,
                ),
                title: Text(
                  'اعطنا تقييم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                onTap: () async {
                  const url = 'https://t.me/joinchat/AAAAAFQB7H0Zwq7l4vI4Yg';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                leading: Icon(
                  FontAwesomeIcons.telegram,
                  color: Colors.orange,
                  size: 28,
                ),
                title: Text(
                  'تابعنا علي قناة التلجرام',
                  style: TextStyle(
                    fontSize: 20,
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
            padding: EdgeInsets.only(top: 30, bottom: 50),
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Form(
                        key: logic.key,
                        autovalidate: true,
                        child: Stack(
                          children: <Widget>[
                            TextFormField(
                              controller: logic.controller,
                              validator: (String text) {
                                if (text.isEmpty) {
                                  print('!');
                                  return null;
                                } else if (text.contains('instagram.com/p/')) {
                                  return null;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 20, bottom: 20, top: 20, right: 30),
                                  helperText: ' ',
                                  errorStyle:
                                      TextStyle(fontWeight: FontWeight.w700),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: Colors.red,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.link,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Colors.purple.withOpacity(0.5),
                                        width: 2),
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
                                        size: 15,
                                      ),
                                    ),
                                    width: 30,
                                    height: 30,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          for (int i = 0; i < 2; i++)
                            ButtonTheme(
                              minWidth: 140,
                              height: 50,
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  color: logic.buttons[i]['color'],
                                  onPressed: () {
                                    logic.buttons[i]['onPressed']();
                                  },
                                  child: Text(
                                    logic.buttons[i]['text'],
                                    style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  )),
                            ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.black.withOpacity(0.2),
              ),
              for (int i = 0; i < logic.posts.length; i++)
                logic.posts[i] == null
                    ? Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Shimmer.fromColors(
                                          enabled: false,
                                          baseColor: Colors.black,
                                          highlightColor: Colors.red,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            width: 60,
                                            height: 60,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Shimmer.fromColors(
                                              enabled: false,
                                              baseColor: Colors.red,
                                              highlightColor: Colors.purple,
                                              child: Container(
                                                height: 12,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                            Shimmer.fromColors(
                                              enabled: false,
                                              baseColor: Colors.red,
                                              highlightColor: Colors.purple,
                                              child: Container(
                                                height: 10,
                                                width: 120,
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
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    for (int i = 1; i < 5; i++)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 20.0 * i,
                                            left: 10),
                                        child: Shimmer.fromColors(
                                          enabled: false,
                                          baseColor: Colors.red,
                                          highlightColor: Colors.purple,
                                          child: Container(
                                            height: 4,
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Center(
                                  child: Shimmer.fromColors(
                                    enabled: false,
                                    baseColor: Colors.red,
                                    highlightColor: Colors.purple,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      height: 200,
                                      width: 330,
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
                    : Column(
                        children: <Widget>[
                          Card(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                      child: SizedBox(
                                    child: LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                      value: logic
                                                  .posts[i]
                                                  .downloadCallbackModel
                                                  ?.progress
                                                  ?.toDouble() ==
                                              null
                                          ? 0
                                          : logic.posts[i].downloadCallbackModel
                                                  .progress
                                                  .toDouble() /
                                              100,
                                      backgroundColor:
                                          Colors.purple.withOpacity(0.1),
                                    ),
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Image.network(
                                            logic.posts[i].owner.profilePic,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              logic.posts[i].owner.userName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5)),
                                            Text(
                                              logic.posts[i].date,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      logic.downloadControl(i)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
//                                    "I started using flutter markdown, however I'd like to justify the content, and I couldn't until nowried using a Center and Alignment but didn't work.            ",
                                    logic.posts[i].title,
                                    textAlign: TextAlign.center,
/*
                                    textDirection: logic.arabicCharachterRegex
                                            .hasMatch(logic.posts[i].title)
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
*/
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Center(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      placeholder: (context, text) {
                                        return SizedBox(
                                            height: 250,
                                            width: 330,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      },
                                      imageUrl: logic.posts[i].thumbnail,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      width: 330,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: ButtonTheme(
                                    height: 60,
                                    minWidth: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        FlatButton.icon(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            colorBrightness: Brightness.dark,
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                        FlatButton.icon(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            colorBrightness: Brightness.dark,
                                            color: Colors.purple,
                                            onPressed: () {
                                              logic.copy(logic.posts[i].title);
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.hashtag,
                                              color: Colors.amber,
                                            ),
                                            label: Text(
                                              'نسخ المحتوى',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
            ],
          ),
        ),
      )),
    );
  }

  Widget postWidget() {}
  /*
                  Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: CachedNetworkImage(
                                imageUrl: logic.posts[i].owner.profilePic,
                                height: 60,
                                placeholder: (context, text) {
                                  return SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                },
                                width: 60,
                                fit: BoxFit.cover,
                                errorWidget: (x, y, z) {
                                  return Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    size: 40,
                                    color: Colors.purple,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    logic.posts[i].owner.userName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    logic.posts[i].date,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Builder(
                                builder: (BuildContext context) => InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        logic.startDownload(
                                            logic.posts[i].downloadUrl);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons
                                              .solidArrowAltCircleDown,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                      ),
                                    ))
                          ],
                        ),
                      ),
                      Text(logic.posts[i].title),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            placeholder: (context, text) {
                              return SizedBox(
                                  height: 200,
                                  width: 330,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            },
                            imageUrl: logic.posts[i].thumbnail,
                            height: 200,
                            fit: BoxFit.cover,
                            width: 330,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: SizedBox(
                          width: (280),
                          child: LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            value: 0.1,
                            backgroundColor: Colors.purple.withOpacity(0.1),
                          ),
                        )),
                      ),
                      Divider()
                    ],
                  ),
                ),

   */

  var list = [1, 2];
}
/*
                         /*
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                                height: 60,
                                placeholder: (context, text) {
                                  return SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Center(child: Text('loading')));
                                },
                                width: 60,
                                fit: BoxFit.cover,
                                errorWidget: (x, y, z) {
                                  return Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    size: 40,
                                    color: Colors.purple,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    'Mohamed Gaber',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    '12/12/2015',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Builder(
                                builder: (BuildContext context) => InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons
                                              .solidArrowAltCircleDown,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                      ),
                                    ))
                          ],
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            placeholder: (context, text) {
                              return SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Center(child: Text('loading')));
                            },
                            imageUrl:
                                'https://images.pexels.com/photos/1252869/pexels-photo-1252869.jpeg?cs=srgb&dl=scenic-view-of-forest-during-night-time-1252869.jpg&fm=jpg',
                            height: 200,
                            fit: BoxFit.cover,
                            width: 330,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: SizedBox(
                          width: (280),
                          child: LinearProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.green),
                            value: 0.1,
                            backgroundColor: Colors.purple.withOpacity(0.1),
                          ),
                        )),
                      ),
                      Divider()
                    ],
                  ),
                ),
*/
   showBottomSheet(
                                context: context,
                                builder: (context) => Material(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          for (int i = 0; i < 4; i++)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    onTap: () {},
                                                    leading: Icon(
                                                        FontAwesomeIcons
                                                            .envelopeOpenText),
                                                    title: Text(
                                                      'نسخ العنوان',
                                                      style: GoogleFonts
                                                          .youTubeSans(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                    ),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ));
    var link1 = 'https://www.instagram.com/p/B9pQAz0lAOe/'; // video
    var link2 = 'https://www.instagram.com/p/B9jXRGshclD/'; // image
    var link3 = 'https://www.instagram.com/p/B9mMl4yBKfH/'; // video
    var link4 = 'https://www.instagram.com/p/B9UAiGOlbUp/'; // video
    var link5 = 'https://www.instagram.com/p/B9ovaM5geVf/'; //video
    var link6 = 'https://www.instagram.com/p/B4gNiEbDpxd/'; // photo
    var link7 = 'https://www.instagram.com/p/BVc1kGHBfCo/'; // photo
    var link8 = 'https://www.instagram.com/p/B9rAjkilMGF/'; // photo
/*
    http.get(link8).then((response) {
        var htmlDocument = parse(response.body);
      var htmlBody = htmlDocument.body;
// get title of video or image
      String title = htmlDocument
          .querySelector('meta[property="og:title"]')
          .attributes['content'];

      title = title.substring(title.indexOf(':') + 1, title.length);

// get date
      var date = jsonDecode(htmlDocument
          .querySelector('script[type="application/ld+json"]')
          .text)['uploadDate'];
//initialize
      var scriptElement =
          htmlBody.querySelector('script[type="text/javascript"]').text;

      var mappedScriptElement = jsonDecode(scriptElement.substring(
          scriptElement.indexOf('{'), scriptElement.length - 1));

      Map<String, dynamic> root = mappedScriptElement['entry_data']['PostPage']
          [0]['graphql']['shortcode_media'];

      var owner = root['owner'];

      // profile pic
      var profilePic = owner['profile_pic_url'];
// user Name
      var userName = owner['username'];
      // thumbnail
      var thumbnail = root['display_url'];

      // get hashtags and video
      var type = htmlDocument
          .querySelector('meta[property="og:type"]')
          .attributes['content'];

      var propertyHashtagName;

      var downloadLink;

      if (root.containsKey('video_url')) {
        downloadLink = root['video_url'];
      } else if (root.containsKey('edge_sidecar_to_children')) {
        downloadLink =
            root['edge_sidecar_to_children']['edges'][0]['node']['video_url'];
      } else {
        downloadLink = thumbnail;
      }

      if (type == 'video') {
        propertyHashtagName = 'video:tag';

*/ /*
*/ /*

      } else {
        propertyHashtagName = 'instapp:hashtags';
      }
      var hashtagList = htmlDocument
          .querySelectorAll('meta[property="$propertyHashtagName"]');

      var hashtags = '';
      for (var element in hashtagList) {
        hashtags += '#${element.attributes['content']} ';
      }*/
/*
print(type);
      print(hashtags);
      print(thumbnail);
      print(userName);
      print(profilePic);
      print(title);
      print(date);
    });
    */

 */
