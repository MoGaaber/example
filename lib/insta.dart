import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'constants.dart';
import 'logic.dart';

class Insta extends StatelessWidget with WidgetsBindingObserver {
  TargetPlatform platform;
  Insta(this.platform);
  TextEditingController controller = TextEditingController();
  String localPath;
  init() async {
    final response = await http
        .get('https://www.facebook.com/mh5375894/videos/2203580109941049/');

    if (response.statusCode == 200)
      return response.body;
    else
      throw Exception('Failed');
  }

  void Downloading(
    String title,
  ) {
    String cutTitle = title;
    String characterFilter =
        "[^\\p{L}\\p{M}\\p{N}\\p{P}\\p{Z}\\p{Cf}\\p{Cs}\\s]";
    cutTitle = cutTitle.replaceAll(characterFilter, "");
    cutTitle = cutTitle.replaceAll("['+.^:,#\"]", "");
    //
    cutTitle = cutTitle
            .replaceFirst(" ", "-")
            .replaceFirst("!", "")
            .replaceFirst(":", "") +
        '.mp4';

    if (cutTitle.length > 100) cutTitle = cutTitle.substring(0, 100) + '.mp4';
    print(cutTitle);
  }

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);

    Downloading('انا مش شايف قدامى');
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("الرئيسية"),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
                child: Image.asset(
              "assets/img/a.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )),
            ListTile(
                leading: Icon(Icons.arrow_left),
                trailing: Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "قيم التطبيق",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  LaunchReview.launch(
                      androidAppId:
                          "https://play.google.com/store/apps/details?id=com.mshaalan.anees_almareed");
                }),
            ListTile(
                leading: Icon(Icons.arrow_left),
                trailing: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "مشاركة التطبيق",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  Share.share(
                      'شارك تطبيقانا مع اصدقائك لتعم الفائده  https://play.google.com/store/apps/details?id=com.HNY.qurancareem',
                      subject: 'Look what I made!');
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        http.get('https://www.instagram.com/p/B6_dwiPJBHK/').then((x) {
          String body = x.body;
          var document = parse(body);
          var yx = document
              .querySelector('meta[property="og:title"]')
              .attributes['content'];
          ;
          print(yx);
        });
      }),
      body: FutureBuilder<bool>(future: logic.checkPermission(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Permission not available'));
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(

                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Card(
                      child: TextField(
                      decoration: InputDecoration(
                          hintText: "الصق اللينك هنا..."),
                        controller: this.controller,
                    ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.link), onPressed: (){})
                ],
              ),

              Container(
                height: 150,
                width: double.infinity,
                child: Card(

                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),

              SizedBox(
                width: 300,
                height: 50,
                child: FlatButton(
                  onPressed: () async {
                    logic.startDownload(
                        await logic.getVideoDownloadLink(this.controller.text),
                        'hello');
                  },
                  child: Text(
                    'تحميل',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                ),
              )
            ],
          );
        }
        ;
      }),
    );
  } //
}
