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

  String title, hashtags, thumbnail;

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);

    return ListView(
      padding: EdgeInsets.only(bottom: 60),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/b/be/Lineage_OS_Logo.png',
          height: 100,
          width: 100,
          color: Colors.purple,
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 6,
                child: Stack(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          labelText: 'https://www.instagram.com/p/'),
                      controller: this.controller,
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              Row(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: 50,
                      height: 50,
                      child: IconButton(
                        onPressed: () async {
                          var data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          controller.text = data.text;

//                          var response = await http.get(controller.text);
//                          String name = parse(response.body)
//                              .querySelector('meta[property="og:title"]')
//                              .attributes['content'];
//                          title = name;
//                          logic.notifyListeners();
                        },
                        icon: Icon(
                          Icons.content_paste,
                          color: Colors.white,
                        ),
                        color: Colors.purple,
                      )),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: 50,
                      height: 50,
                      child: IconButton(
                        onPressed: () async {
                          controller.clear();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        color: Colors.purple,
                      )),
                ],
              )
            ],
          ),
        )),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        this.title == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Column(
                    children: <Widget>[
                   this.thumbnail ==null ? Container():   Image.network(
                        this.thumbnail,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        this.title,
                        style: TextStyle(fontSize: 20),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Builder(
                                  builder: (BuildContext context) => FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      color: Colors.purple,
                                      onPressed: () async {
                                        await Clipboard.setData(
                                            ClipboardData(text: this.title));

                                        this.title = '';
                                        logic.notifyListeners();
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'تم النسخ العنوان بنجاح',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.purple,
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      },
                                      child: Icon(
                                        Icons.text_fields,
                                        color: Colors.white,
                                      )),
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6)),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Builder(
                                  builder: (BuildContext context) => FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      color: Colors.purple,
                                      onPressed: () async {
                                        await Clipboard.setData(
                                            ClipboardData(text: this.hashtags));
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'تم النسخ الهاشتاجات بنجاح',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      },
                                      child: Text(
                                        '#',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      )),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 60,
              child: FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () async {
                  this.title = '';
                  logic.notifyListeners();
                  var info = await logic.getVideoInfo(controller.text);
                  print(info);
                  this.title = info['title'];
                  this.hashtags = info['hashtags'];
                  this.thumbnail = info['thumbnail'];
                  print(hashtags + '!!!!' + thumbnail);

                  logic.notifyListeners();
                },
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                label: Text(
                  'تحميل',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                color: Colors.purple,
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Center(
          child: SizedBox(
            width: 300,
            height: 60,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () async {
                this.title = '';
                logic.notifyListeners();
                var info = await logic.getVideoInfo(controller.text);
                this.title = info['name'];
                this.hashtags = info['hashtags'];
                this.thumbnail = info['thumbnail'];
                print(hashtags + '!!!!' + thumbnail);

                logic.startDownload(info['url'], Uuid().v1());

                logic.notifyListeners();
              },
              child: Text(
                'عرض',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              color: Colors.purple,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Center(
          child: SizedBox(
            width: 300,
            height: 60,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () async {
                this.title = null;

                logic.notifyListeners();
              },
              child: Text(
                'الغاء',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
