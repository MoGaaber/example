import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  List<Map> buttons = [
    {
      'text': 'لصق',
      'color': Colors.purple,
      'onPressed': () {
        print('!!');
      }
    },
    {'text': 'تأكيد', 'color': Colors.purple},
    {'text': 'إلغاء', 'color': Colors.purple}
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 30)),
              Center(
                child: SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.link,
                        ),
                        contentPadding: EdgeInsets.all(15),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.purple,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w700),
                        labelText: 'الصق الرابط هنا'),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    for (int i = 0; i < 3; i++)
                      ButtonTheme(
                        minWidth: 100,
                        height: 40,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            color: buttons[i]['color'],
                            onPressed: () {},
                            child: Text(
                              buttons[i]['text'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )),
                      ),
                  ],
                ),
              )),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.black.withOpacity(0.2),
              ),
              Padding(padding: EdgeInsets.only(left: 30, top: 20)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Image.network(
                        'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Mohamed Gaber',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Text(
                            '12/12/2015',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Builder(

                    builder: (BuildContext context) =>    IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        onPressed: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) => Material(
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    for (int i = 0; i < 4; i++)
                                      ListTile(
                                        title: Text(
                                          'نسخ العنوان',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                  ],
                                ),
                              ));
                        }),

                    )
                  ],
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    'https://d3j2s6hdd6a7rg.cloudfront.net/v2/uploads/media/default/0001/77/thumb_76748_default_news_size_5.jpeg',
                    height: 200,
                    fit: BoxFit.cover,
                    width: 330,
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
