import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader_example/pages/download/download.dart';
import 'package:flutter_downloader_example/pages/history/history_logic.dart';
import 'package:flutter_downloader_example/pages/history/history_page.dart';
import 'package:flutter_downloader_example/pages/home/logic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  var pages = [DownloadPage(), HistoryPage()];

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    HistoryLogic historyLogic = Provider.of(context);

    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: FancyBottomNavigation(
                tabs: [
                  TabData(
                    title: '',
                    iconData: FontAwesomeIcons.download,
                  ),
                  TabData(title: '', iconData: FontAwesomeIcons.history)
                ],
                onTabChangedListener: (x) {
                  this.selectedIndex = x;
                  setState(() {});
                },
                circleColor: Colors.purple,
                activeIconColor: Colors.white,
                barBackgroundColor: Colors.white,
                inactiveIconColor: Colors.purple),
            body: Directionality(
              child: ScrollConfiguration(
                child: pages[selectedIndex],
                behavior: MyBehavior(),
              ),
              textDirection: TextDirection.rtl,
            )));
  }
}
