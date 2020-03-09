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

import 'constants.dart';

class Insta extends StatelessWidget with WidgetsBindingObserver {
  TargetPlatform platform;
  Insta(this.platform);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    return Scaffold(
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
      ),
    );
  }//
}
