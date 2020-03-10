import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/logic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'dart:convert' show jsonDecode, utf8;

import 'constants.dart';

class Insta extends StatelessWidget with WidgetsBindingObserver {
  TargetPlatform platform;
  Insta(this.platform);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    String name =
        'اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله اكبرالله الله اك';
    http.get('https://www.instagram.com/p/B9hFD6ShE9y/').then((x) {
      String body = x.body;
      var document = parse(body);
      var yx = document
          .querySelector('meta[property="og:title"]')
          .attributes['content'];
      ;
      yx = yx.substring(yx.indexOf(':') + 3, yx.length - 1);
      yx = yx.substring(0, 133);
    });
    var test =
        'تعليق الدراسة وعزل مدن وإلغاء رحلات طيران.. إجراءات استثنائية في دول خليجية لتفادي انتشار كورونا (كوفيد-19) بعد تجاوز حالات الإصابة الـانتت';
    String testt = 'my name is moha';

    int length = 14;
    if (testt.length > length) {
      if (testt[length - 1] == null) {
        length = testt.length;
      }
      testt = testt.trim();

      print(testt[13]);
      if (testt[length + 1] != ' ') {
        testt = testt.substring(0, length);
        testt = testt.substring(0, testt.lastIndexOf(' '));
      } else {
        testt = testt.substring(0, length);
      }
    }
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Center(
                child: TextField(
              controller: this.controller,
            )),
            Padding(padding: EdgeInsets.only(top: 50)),
            SizedBox(
              width: 300,
              height: 50,
              child: FlatButton(
                onPressed: () async {
                  logic.startDownload(
                      await logic.getVideoDownloadLink(
                          'https://www.instagram.com/p/B9cGPcJl-Qp/?igshid=13aqfn2on5s57'),
                      'تعليق الدراسة وعزل مدن وإلغاء رحلات طيران.. إجراءات استثنائية في دول خليجية لتفادي انتشار كورونا (كوفيد-19) بعد تجاوز حالات الإصابة الـانتت');
                },
                child: Text(
                  'تحميل',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.purple,
              ),
            )
          ],
        ),
      ),
    );
  }
}
