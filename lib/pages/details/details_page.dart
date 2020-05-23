import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader_example/pages/history/history_logic.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class Details extends StatefulWidget {
  History history;
  Details(this.history);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  VideoPlayerController controller;
  Animation<double> playAnim;
  AnimationController playCon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playCon =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    playAnim = Tween<double>(begin: 0, end: 1).animate(playCon);

    if (widget.history.isVideo) {
      controller = VideoPlayerController.network(
          'https://scontent-mrs2-2.cdninstagram.com/v/t50.2886-16/93349604_101333954861474_4168463784279369228_n.mp4?_nc_ht=scontent-mrs2-2.cdninstagram.com&_nc_cat=102&_nc_ohc=QHu1_3drAZcAX8X5yiJ&oe=5E96E798&oh=d647449b996eb6e97f87ef38dae46940')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
    controller.addListener(() async {
      var position = await controller.position;
      value = position?.inSeconds?.toDouble();
      if (controller.value.position == controller.value.duration) {
        await controller.seekTo(Duration(milliseconds: 0));
        controller.pause();
        await playCon.reverse();
      }
    });
  }

  double value = 0;
  bool showVideoOptions = true;
  @override
  Widget build(BuildContext context) {
    HistoryLogic historyLogic = Provider.of(context, listen: false);

    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: () {}),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                    child: widget.history.isVideo
                        ? controller.value.initialized
                            ? GestureDetector(
                                onTap: () {
                                  showVideoOptions = !showVideoOptions;
                                  setState(() {});
                                },
                                child: Stack(
                                  // fit: StackFit.expand,
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),
                                    ),
                                    showVideoOptions
                                        ? Positioned.fill(
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned.fill(
                                                    child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                )),
                                                Positioned.fill(
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        if (controller
                                                            .value.isPlaying) {
                                                          await playCon
                                                              .reverse();
                                                          await controller
                                                              .pause();
                                                        } else {
                                                          await playCon
                                                              .forward();

                                                          await controller
                                                              .play();
                                                        }
                                                        setState(() {});
                                                      },
                                                      child: AnimatedIcon(
                                                          icon: AnimatedIcons
                                                              .play_pause,
                                                          size: 80,
                                                          progress: playAnim),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : Container()
                        : Image.network(widget.history.thumbnail))
              ],
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                children: <Widget>[
                  // SizedBox.fromSize(
                  //   size: Size.fromHeight(100),
                  // ),
                  controller.value.duration == null
                      ? SizedBox.shrink()
                      : Slider(
                          activeColor: Colors.purple,
                          onChanged: (double value) {
                            controller.seekTo(Duration(seconds: value.toInt()));
                            setState(() {});
                          },
                          value: value,
                          min: 0,
                          max: controller.value.duration?.inSeconds?.toDouble(),
                        ),
                  ExpandablePanel(
                    expanded: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.history.title),
                        Align(
                          child: IconButton(
                            icon: Icon(
                              Icons.content_copy,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                          alignment: Alignment(0.9, 0),
                        )
                      ],
                    ),
                    header: Text(
                      'Text',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 0,
                    ),
                  ),
                  ExpandablePanel(
                    expanded: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.history.hashtags ?? ''),
                        Align(
                          child: IconButton(
                            icon: Icon(
                              Icons.content_copy,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                          alignment: Alignment(0.9, 0),
                        )
                      ],
                    ),
                    header: Text(
                      'Hashtags',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  FlatButton(
                    onPressed: () {},
                    child: Text('Open'),
                    color: Colors.purple,
                  )
                ],
              ),
            )));
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

/*
SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size?.width ?? 0,
                      height: controller.value.size?.height ?? 0,
                      child: VideoPlayer(controller),
                    ),
                  ),
                )
*/
