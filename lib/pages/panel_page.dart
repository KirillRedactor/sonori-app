import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/music_player_class.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../components/cards_widgets.dart';

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
  // bool isPlaynig = false;
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
  final Color iconColor = Colors.white;

  @override
  void initState() {
    widget.ac.addListener(() {
      scrollController.jumpTo(widget.ac.value * minHeight);
    });
    // mpc.playingStream.listen((event) => setState(() => isPlaynig = event));
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
              child: SizedBox(
                height: minHeight,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black
                                  ],
                                  stops: [0, 0, 1, 1],
                                  /*stops: [
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
                                  ], // 10% black, 80% transparent, 10% black*/
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              // child: MiniTrackSliderWidget(
                              //   controller: controller,
                              // ),
                              // child: const MiniTrackWidgetWithTransition(),
                              child: const MiniTrackWidget(),
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
                                style: TextButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                child: Icon(
                                  snapshot.data ?? false
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      child: IgnorePointer(
                        // ignoring: false,
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
                              thumbColor: Colors.white,
                              thumbRadius: 0,
                              thumbGlowRadius: 0,
                              progressBarColor: Colors.white.withOpacity(0.30),
                              baseBarColor: Colors.white.withAlpha(30),
                              progress: progress,
                              total: total,
                              timeLabelLocation: TimeLabelLocation.none,
                              onSeek: (duration) {
                                mpc.seek(duration);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
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
          PanelPartWidget(
              widget: widget,
              height: height,
              stasutBarHeight: stasutBarHeight,
              getIt: getIt),
        ],
      ),
    );
  }
}

class PanelPartWidget extends StatelessWidget {
  const PanelPartWidget({
    super.key,
    required this.widget,
    required this.height,
    required this.stasutBarHeight,
    required this.getIt,
  });

  final PanelPage widget;
  final double height;
  final double stasutBarHeight;
  final GetIt getIt;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(widget.ac),
      child: Container(
        height: height - stasutBarHeight,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => widget.panelController.close(),
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    )),
                Column(
                  children: [
                    Text(
                      "NOW PLAYING FROM",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const Text(
                      "Test playlist",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const TrackWidget(),
            StreamBuilder<MusicItem>(
              stream: mpc.currentPlayingStream,
              builder: (context, snapshot) {
                // ignore: sized_box_for_whitespace
                return Container(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MarqueeWidget(
                        child: Text(
                          (snapshot.data ?? MusicItem.empty).mediaItem.title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      MarqueeWidget(
                        child: Text(
                          (snapshot.data ?? MusicItem.empty).mediaItem.artist ??
                              "Unknown artist",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<DurationState>(
              stream: mpc.durationStateStream,
              builder: (context, snapshot) {
                final durationState = snapshot.data;
                final progress = durationState?.progress ?? Duration.zero;
                final total = durationState?.total ?? Duration.zero;
                return ProgressBar(
                  thumbColor: Colors.white,
                  timeLabelTextStyle: const TextStyle(color: Colors.white),
                  thumbRadius: 7,
                  thumbGlowRadius: 16,
                  progressBarColor: Colors.white,
                  baseBarColor: Colors.white.withOpacity(0.24),
                  progress: progress,
                  total: total,
                  onSeek: (duration) {
                    mpc.seek(duration);
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.heart_broken_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () => mpc.seekToPrevious(),
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.skip_previous,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: mpc.playingStream,
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {
                        if (snapshot.data ?? false) {
                          mpc.pause();
                        } else {
                          mpc.play();
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: Icon(
                        snapshot.data ?? false
                            ? Icons.pause
                            : Icons.play_arrow_sharp,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () => GetIt.I.get<MusicPlayerClass>().seekToNext(),
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.skip_next,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.favorite_outline,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<LoopMode>(
                    stream: mpc.loopModeStream,
                    builder: (context, snapshot) {
                      return TextButton(
                        onPressed: () {
                          switch (snapshot.data ?? LoopMode.off) {
                            case LoopMode.off:
                              getIt<MusicPlayerClass>()
                                  .setLoopMode(LoopMode.one);
                              break;
                            case LoopMode.one:
                              getIt<MusicPlayerClass>()
                                  .setLoopMode(LoopMode.all);
                              break;
                            case LoopMode.all:
                              getIt<MusicPlayerClass>()
                                  .setLoopMode(LoopMode.off);
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: Icon(
                          snapshot.data == LoopMode.off
                              ? Icons.repeat
                              : snapshot.data == LoopMode.one
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                          size: 30,
                          color: snapshot.data == LoopMode.one ||
                                  snapshot.data == LoopMode.all
                              ? Colors.white
                              : Colors.grey,
                        ),
                      );
                    }),
                StreamBuilder<bool>(
                  stream: mpc.shuffleModeEnabledSteam,
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {
                        getIt<MusicPlayerClass>()
                            .setShuffleModeEnabled(!(snapshot.data ?? false));
                      },
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: Icon(Icons.shuffle,
                          size: 30,
                          color: snapshot.data == true
                              ? Colors.white
                              : Colors.grey),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MiniTrackWidget extends StatefulWidget {
  const MiniTrackWidget({super.key});

  @override
  State<MiniTrackWidget> createState() => _MiniTrackWidgetState();
}

class _MiniTrackWidgetState extends State<MiniTrackWidget> {
  MusicItemsState _musicItemsState = MusicItemsState.empty;
  PageController pageController = PageController();
  int currentPage = 0;

  MusicItem previousPlaying = MusicItem.empty;
  MusicItem currentPlaying = MusicItem.empty;
  MusicItem nextPlaying = MusicItem.empty;

  @override
  void initState() {
    mpc.musicItemsStateStream.listen(
      (event) {
        setState(
          () {
            _musicItemsState = event;
            animate();
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageController.position.isScrollingNotifier.addListener(() {
        if (!pageController.position.isScrollingNotifier.value) {
          // print('scroll is stopped');

          if ((currentPage > 0 && previousPlaying == MusicItem.empty) ||
              (currentPage > 1 && previousPlaying != MusicItem.empty)) {
            mpc.seekToNext();
          } else if (currentPage < 1 && previousPlaying != MusicItem.empty) {
            mpc.seekToPrevious();
          }
        } else {
          // print('scroll is started');
        }
      });
    });

    super.initState();
  }

  void animate() {
    if (!pageController.hasClients) return;

    if (_musicItemsState.currentPlaying == currentPlaying &&
        previousPlaying != MusicItem.empty &&
        _musicItemsState.previousPlaying == MusicItem.empty) {
      pageController.jumpToPage(0);
    } else if (_musicItemsState.currentPlaying == currentPlaying &&
        previousPlaying == MusicItem.empty &&
        _musicItemsState.previousPlaying != MusicItem.empty) {
      pageController.jumpToPage(1);
    } else if (previousPlaying == _musicItemsState.currentPlaying) {
      if (currentPage == 0) {
        pageController.jumpToPage(
          _musicItemsState.previousPlaying == MusicItem.empty ? 0 : 1,
        );
      } else {
        pageController.jumpToPage(
          _musicItemsState.previousPlaying == MusicItem.empty ? 1 : 2,
        );
        pageController.animateToPage(
          _musicItemsState.previousPlaying == MusicItem.empty ? 0 : 1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutSine,
        );
      }
    } else if (nextPlaying == _musicItemsState.currentPlaying) {
      if (currentPage == (previousPlaying == MusicItem.empty ? 1 : 2)) {
        pageController.jumpToPage(1);
      } else {
        pageController.jumpToPage(0);
        pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutSine,
        );
      }
    } else {}

    previousPlaying = _musicItemsState.previousPlaying;
    currentPlaying = _musicItemsState.currentPlaying;
    nextPlaying = _musicItemsState.nextPlaying;
  }

  @override
  Widget build(BuildContext context) {
    pageController = PageController(
      initialPage: previousPlaying == MusicItem.empty ? 0 : 1,
    );

    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: pageController,
      children: [
        if (_musicItemsState.previousPlaying != MusicItem.empty)
          MiniTrackCardForNavigationPanel(
            musicItem: _musicItemsState.previousPlaying,
          ),
        MiniTrackCardForNavigationPanel(
          musicItem: _musicItemsState.currentPlaying,
        ),
        if (_musicItemsState.nextPlaying != MusicItem.empty)
          MiniTrackCardForNavigationPanel(
            musicItem: _musicItemsState.nextPlaying,
          ),
      ],
      onPageChanged: (value) {
        currentPage = value;
      },
    );
  }
}
