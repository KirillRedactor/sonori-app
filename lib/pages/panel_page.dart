import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/music_player_class.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelPage extends StatefulWidget {
  final AnimationController ac;
  final PanelController panelController;

  const PanelPage({super.key, required this.ac, required this.panelController});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  List<MusicItem> queue = [];
  int currentIndex = 0;
  PageController controller = PageController();
  PageController secController = PageController();
  bool isPlaynig = false;
  LoopMode loopMode = LoopMode.off;

  final getIt = GetIt.I;
  final scrollController = ScrollController();

  double minHeight = 102.0;
  double height = 0;
  double width = 0;
  double diffHeight = 0;
  double stasutBarHeight = 0;
  double navBarHeight = 0;
  double blurAmount = 8;

  double currentPosition = 0;

  final double iconSize = 30;
  final Color iconColor = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double fadeIn = 25;
    // ignore: unused_local_variable
    double fadeOut = 25;
    stasutBarHeight = MediaQuery.of(context).viewPadding.top;
    navBarHeight = MediaQuery.of(context).padding.bottom;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    diffHeight = height - minHeight;

    return SingleChildScrollView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // * Collapsed part
          GestureDetector(
            onTap: () => widget.panelController.open(),
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(widget.ac),
              child: Container(
                height: minHeight,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: const [
                                    Colors.black,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black
                                  ],
                                  stops: [
                                    0.0,
                                    controller.hasClients
                                        ? fadeIn /
                                            controller.position.extentInside
                                        : 0.1,
                                    controller.hasClients
                                        ? 1 -
                                            fadeOut /
                                                controller.position.extentInside
                                        : 0.1,
                                    1.0
                                  ], // 10% black, 80% transparent, 10% black
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              // child: MiniTrackSliderWidget(
                              //   controller: controller,
                              // ),
                            ),
                          ),
                          StreamBuilder<bool>(
                              stream: GetIt.I<MusicPlayerClass>().playingStream,
                              builder: (context, snapshot) {
                                return TextButton(
                                  onPressed: () {
                                    if (snapshot.data ?? false) {
                                      GetIt.I.get<MusicPlayerClass>().pause();
                                    } else {
                                      GetIt.I.get<MusicPlayerClass>().play();
                                    }
                                  },
                                  child: Icon(
                                    snapshot.data ?? false
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      child: IgnorePointer(
                        ignoring: false,
                        child: StreamBuilder<DurationState>(
                          stream:
                              GetIt.I<MusicPlayerClass>().durationStateStream,
                          builder: (context, snapshot) {
                            final durationState = snapshot.data;
                            final progress =
                                durationState?.progress ?? Duration.zero;
                            final total = durationState?.total ?? Duration.zero;
                            return ProgressBar(
                              barHeight: 2,
                              thumbColor: Colors.black,
                              thumbRadius: 0,
                              thumbGlowRadius: 0,
                              progressBarColor: Colors.black.withOpacity(0.30),
                              baseBarColor: Colors.black.withAlpha(30),
                              progress: progress,
                              total: total,
                              timeLabelLocation: TimeLabelLocation.none,
                              onSeek: (duration) {
                                GetIt.I.get<MusicPlayerClass>().seek(duration);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.home_outlined,
                                size: iconSize,
                                color: iconColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.featured_play_list_outlined,
                                size: iconSize,
                                color: iconColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.person_outline,
                                size: iconSize,
                                color: iconColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // * Sizedbox with hight of system status bar
          SizedBox(
            height: stasutBarHeight,
          ),
          // * Panel part
          FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(widget.ac),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
