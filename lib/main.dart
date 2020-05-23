import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'constants.dart';
import 'pages/details/details_logic.dart';
import 'pages/history/history_logic.dart';
import 'pages/home/home_page.dart';
import 'pages/home/logic.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

String localPath;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await FirebaseAdMob.instance.initialize(appId: Constants.adAppId);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        builder: (BuildContext context, Widget widget) {
          print(MediaQuery.of(context).size);
          ScreenUtil.init(context, width: 360, height: 752);
          return SafeArea(
            child: widget,
          );
        },
        home: HomePage(),
        theme: ThemeData(
            fontFamily: GoogleFonts.cairo().fontFamily,
            accentColor: Colors.purple,
            scaffoldBackgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (_) => DetailsLogic(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Logic(this, ctx),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HistoryLogic(),
        )
      ],
    );
  }
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://scontent-mrs2-2.cdninstagram.com/v/t50.2886-16/93349604_101333954861474_4168463784279369228_n.mp4?_nc_ht=scontent-mrs2-2.cdninstagram.com&_nc_cat=102&_nc_ohc=QHu1_3drAZcAX8X5yiJ&oe=5E96E798&oh=d647449b996eb6e97f87ef38dae46940')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context);
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
