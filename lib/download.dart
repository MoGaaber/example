import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:flutter_downloader_example/downloadd.dart';
import 'package:flutter_downloader_example/myButton.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:flutter_downloader_example/screen.dart';
import 'package:flutter_downloader_example/test.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'logic.dart';

class DownloadPage extends StatelessWidget {
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: false);
    var size = MediaQuery.of(context).size;
    logic.screen = Screen(size: size);
    var screen = logic.screen;
    var height = screen.height;
    var width = screen.width;
    var aspectRatio = screen.aspectRatio;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            child: Scaffold(
                key: logic.globalKey,
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
                            logic.showSnackBar(
                                context, 'هذا الرابط معطل الآن', false);
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
                body: FutureBuilder<bool>(
                  future: logic.permission,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data)
                        return Download();
                      else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Spacer(
                                flex: 2,
                              ),
                              Icon(
                                Icons.error,
                                color: Colors.orange,
                                size: 120,
                              ),
                              ButtonTheme(
                                minWidth: 200,
                                height: 60,
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    colorBrightness: Brightness.dark,
                                    color: Colors.purple,
                                    onPressed: () async {
                                      logic.notifyListeners();
                                    },
                                    child: Text('اعطاء الإذن')),
                              ),
                              Spacer(
                                flex: 4,
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ))));
  }
}
