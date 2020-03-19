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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'logic.dart';

class Loading extends StatelessWidget {
  int i;
  Loading(this.i);
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: false);
    var size = MediaQuery.of(context).size;
    logic.screen = Screen(size: size);
    var screen = logic.screen;
    var height = screen.height;
    var width = screen.width;
    var aspectRatio = screen.aspectRatio;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                  enabled: false,
                  baseColor: Color(0xffE9E9E9),
                  highlightColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: screen.convert(65, width),
                    height: screen.convert(65, height),
                  )),
              Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Shimmer.fromColors(
                      enabled: false,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: screen.convert(12, height),
                        width: screen.convert(150, width),
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: screen.convert(10, height))),
                    Shimmer.fromColors(
                      enabled: false,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: screen.convert(10, height),
                        width: screen.convert(120, width),
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  logic.cancelableOperation.cancel().then((x) {
                    logic.posts.removeAt(i);
                    logic.notifyListeners();
                  });
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Material(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    type: MaterialType.circle,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                for (int i = 1; i < 6; i++)
                  Padding(
                    padding: EdgeInsets.only(
                        top: screen.convert(5, height),
                        bottom: screen.convert(5, height),
                        right: screen.convert(5.0 * i, width),
                        left: screen.convert(10, width)),
                    child: Shimmer.fromColors(
                      enabled: false,
                      baseColor: Color(0xffE9E9E9),
                      highlightColor: Colors.white,
                      child: Container(
                        height: screen.convert(5, height),
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Shimmer.fromColors(
            enabled: false,
            baseColor: Color(0xffE9E9E9),
            highlightColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: screen.convert(400, height),
              width: screen.convert(330, width),
            ),
          ),
        ],
      ),
    );
  }
}
