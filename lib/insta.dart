/*
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

 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String videoName;
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: <Widget>[
                    TextField(decoration: InputDecoration(hintText: 'https://www.instagram.com/'),
                      controller: this.controller,
                    )
                ],
                ),
              ),
              Spacer(),
              Flexible(
                  flex: 2,
                  child: SizedBox(
                      child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: () async {
                      var data = await Clipboard.getData(Clipboard.kTextPlain);
                      controller.text = data.text;
                      logic.notifyListeners();

                      var response = await http.get(controller.text);
                      String name = parse(response.body)
                          .querySelector('meta[property="og:title"]')
                          .attributes['content'];
                      videoName = name;
                      logic.notifyListeners();
                    },
                    child: Text(
                      'لصق',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.purple,
                  )))
            ],
          )),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          this.videoName == null
              ? Container()
              : Column(
                  children: <Widget>[
                    Text(this.videoName),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Builder(
                            builder: (BuildContext context) => FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                color: Colors.purple,
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: this.videoName));



                                  this.videoName = '';
                                  logic.notifyListeners();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      'تم النسخ بنجاح',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.purple,
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                },
                                child: Icon(
                                  Icons.content_copy,
                                  color: Colors.white,
                                )),
                          )),
                    )
                  ],
                ),
          Padding(padding: EdgeInsets.only(top: 50)),
          SizedBox(
            width: 300,
            height: 60,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () async {
                this.videoName = '';
                logic.notifyListeners();
                var info = await logic.getVideoInfo(controller.text);

                logic.startDownload(info['url'], Uuid().v1());

                this.videoName = info['name'];
                logic.notifyListeners();
              },
              child: Text(
                'تحميل',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}
