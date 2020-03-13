import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class DownloadPage extends StatelessWidget {
  List<Map> buttons = [
    {
      'text': 'لصق',
      'color': Colors.purple,
      'onPressed': () {
        print('!!');
      }
    },
    {'text': 'تأكيد', 'color': Colors.purple},
    {'text': 'إلغاء', 'color': Colors.purple}
  ];
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

*//*
*//*

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
                      Image.asset(
                        'assets/images/fff.png',
                        fit: BoxFit.contain,
                        width: 130,
                        color: Colors.orange,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Text(
                        'Car Note',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  )),
                  decoration: BoxDecoration(
                    color: Color(0xff250101),
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
                  'Share App',
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
                  'Rate Us',
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
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 30)),
              Center(
                child: SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.link,
                        ),
                        contentPadding: EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.purple,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w700),
                        labelText: 'الصق الرابط هنا'),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    for (int i = 0; i < 3; i++)
                      ButtonTheme(
                        minWidth: 100,
                        height: 40,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            color: buttons[i]['color'],
                            onPressed: () {},
                            child: Text(
                              buttons[i]['text'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
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
                      child: Image.network(
                        'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                        height: 80,
                        width: 80,
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
