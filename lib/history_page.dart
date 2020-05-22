import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader_example/history_logic.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'details_page.dart';

Uint8List test;

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    HistoryLogic historyLogic = Provider.of(context);
    (historyLogic
        .dbOperations(historyLogic.readElements, isVideo: true)
        .then((x) {
      print(x);
    }));
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
          body: TabBarView(
            children: <Widget>[HistoryBody(false), HistoryBody(true)],
          ),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
                    SliverAppBar(
                        backgroundColor: Colors.white,
                        centerTitle: true,
                        floating: true,
                        snap: true,
                        title: TabBar(
                          tabs: [
                            Tab(
                                icon: Icon(
                              Icons.directions_car,
                              color: Colors.purple,
                            )),
                            Tab(
                              icon: Icon(
                                Icons.directions_transit,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ))
                  ]),
    );
  }
}

class HistoryBody extends StatelessWidget {
  bool isVideo;
  HistoryBody(this.isVideo);
  @override
  Widget build(BuildContext context) {
    var provider = NetworkImage('');
    HistoryLogic historyLogic = Provider.of(context);
    historyLogic
        .dbOperations(historyLogic.readElements, isVideo: true)
        .then((x) {
      List<RecordSnapshot> list = x;

      print(list[0].key.toString() + '!!!!!!!!!');
    });

    return FutureProvider<Object>(
      create: (_) => historyLogic.dbOperations(
        historyLogic.readElements,
        isVideo: this.isVideo,
      ),
      child: Consumer<Object>(
        builder: (BuildContext context, Object value, Widget child) {
          if (value == null) {
            return Center(child: Text('hello'));
          } else {
            List<RecordSnapshot> list = value;

            if (list.isEmpty) {
              print('hello');
              return SizedBox.shrink();
            }
            var castList = List<History>();
            list.forEach((x) {
              var element = History().fromJson(x.value, x.key);
              castList.add(element);
            });

            print(castList[0].key.toString() + '!111');
            return value == null
                ? Container()
                : FutureProvider<List<Uint8List>>(
                    child: Consumer(
                      builder: (BuildContext context, List<Uint8List> value,
                              Widget child) =>
                          value == null
                              ? SizedBox.shrink()
                              : GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  itemCount: castList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          crossAxisCount: 3,
                                          childAspectRatio: 100 / 100),
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  Details(castList[index])));
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Image.memory(
                                        value[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                    create: (BuildContext context) => Future.wait([
                      for (int i = 0; i < castList.length; i++)
                        castList[i].bytesOfImage()
                    ]),
                  );
          }
        },
      ),
    );
  }
}
/*
*/
