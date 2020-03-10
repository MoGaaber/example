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
import 'package:uuid/uuid.dart';
import 'dart:convert' show jsonDecode, utf8;

import 'constants.dart';

class Insta extends StatelessWidget with WidgetsBindingObserver {
  TargetPlatform platform;
  Insta(this.platform);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);

    return FutureBuilder<bool>(
        future: logic.checkPermission(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return !snapshot.data
                ? Center(
                    child: FlatButton(
                      child: Text('Check permission'),
                      onPressed: () {
                        logic.notifyListeners();
                      },
                    ),
                  )
                : SafeArea(
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
                                    await logic
                                        .getVideoDownloadLink(controller.text),
                                    Uuid().v4());
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
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
