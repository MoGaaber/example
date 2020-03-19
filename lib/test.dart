import 'package:flutter/material.dart';
import 'package:flutter_downloader_example/screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'logic.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: true);
    logic.screen = Screen(size: MediaQuery.of(context).size);
    var screen = logic.screen;
    var height = screen.height;
    var width = screen.width;
    var aspectRatio = screen.aspectRatio;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                            enabled: true,
                            baseColor: Color(0xffE9E9E9),
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              width: screen.convert(60, width),
                              height: screen.convert(60, height),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screen.convert(8, height),
                              left: screen.convert(8, width)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Shimmer.fromColors(
                                enabled: true,
                                baseColor: Color(0xffE9E9E9),
                                highlightColor: Colors.white,
                                child: Container(
                                  height: screen.convert(12, height),
                                  width: screen.convert(150, width),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: screen.convert(10, height))),
                              Shimmer.fromColors(
                                enabled: true,
                                baseColor: Color(0xffE9E9E9),
                                highlightColor: Colors.white,
                                child: Container(
                                  height: screen.convert(10, height),
                                  width: screen.convert(120, width),
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4, top: 10),
                          child: InkWell(
                            onTap: () {
                              logic.cancelableOperation.cancel().then((x) {
//                            logic.posts.removeAt(i);
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
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10)),
                        for (int i = 1; i < 5; i++)
                          Padding(
                            padding: EdgeInsets.only(
                                top: screen.convert(10, height),
                                bottom: screen.convert(5, height),
                                right: screen.convert(20.0, width) * i,
                                left: screen.convert(10, width)),
                            child: Shimmer.fromColors(
                              enabled: true,
                              baseColor: Color(0xffE9E9E9),
                              highlightColor: Colors.white,
                              child: Container(
                                height: screen.convert(4, height),
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: screen.convert(10, height))),
                    Center(
                      child: Shimmer.fromColors(
                        enabled: true,
                        baseColor: Colors.purple,
                        highlightColor: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: screen.convert(250, height),
                          width: screen.convert(330, width),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
