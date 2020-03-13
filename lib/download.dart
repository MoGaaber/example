import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'logic.dart';

class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var link1 = 'https://www.instagram.com/p/B9pQAz0lAOe/'; // video
    var link2 = 'https://www.instagram.com/p/B9jXRGshclD/'; // image
    var link3 = 'https://www.instagram.com/p/B9mMl4yBKfH/'; // video
    var link4 = 'https://www.instagram.com/p/B9UAiGOlbUp/'; // video
    var link5 = 'https://www.instagram.com/p/B9ovaM5geVf/'; //video
    var link6 = 'https://www.instagram.com/p/B4gNiEbDpxd/'; // photo
    var link7 = 'https://www.instagram.com/p/BVc1kGHBfCo/'; // photo
    var link8 = 'https://www.instagram.com/p/B9rAjkilMGF/'; // photo
    (Clipboard.getData(Clipboard.kTextPlain).then((x) {
      print(x.text);
    }));

    http.get(link8).then((response) {
      /*  var htmlDocument = parse(response.body);
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
*/
    });
    Logic logic = Provider.of(context, listen: false);
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 9,
                      child: Form(
                        child: TextFormField(
                          controller: logic.controller,
                          key: logic.key,
                          validator: (String text) {
                            if (!text.contains('instagram.com/p/')) {
                              return 'الرابط يجب ان يحتوي "instagram.com/p/" ';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.link,
                              ),
                              contentPadding: EdgeInsets.all(18),
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
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                ),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                              labelText: 'الصق الرابط هنا'),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          logic.clear();
                        },
                        child: Container(
                          child: Center(
                            child: Icon(Icons.clear),
                          ),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.black.withOpacity(0.2),
              ),
              Padding(padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Mohamed Gaber',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
                      builder: (BuildContext context) => IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30,
                          ),
                          onPressed: () {
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
                          }),
                    )
                  ],
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                    height: 200,
                    fit: BoxFit.cover,
                    width: 330,
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
