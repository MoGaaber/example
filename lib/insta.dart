import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';

import 'constants.dart';

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
    Downloading('انا مش شايف قدامى');
    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () {},
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.purple,
            ),
          )
        ],
      ),
    );
  }
}
