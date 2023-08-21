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
  final Color iconColor = Colors.black;

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
                              child: const MiniTrackWidgetWithTransition(),
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
                RoundIconButton(
                  onPressed: () => widget.panelController.close(),
                  icon: Icons.arrow_downward,
                  padding: const EdgeInsets.all(8),
                ),
                const Column(
                  children: [
                    Text(
                      "NOW PLAYING FROM",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    Text(
                      "Test playlist",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                RoundIconButton(
                  onPressed: () {},
                  icon: Icons.menu,
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
            /*StreamBuilder<MusicItem>(
              stream: mpc.currentPlayingStream,
              builder: (context, snapshot) {
                return TrackCard(
                  musicItem: snapshot.data ?? MusicItem.empty,
                );
              },
            ),*/
            StreamBuilder<MusicItem>(
              stream: mpc.currentPlayingStream,
              builder: (context, snapshot) {
                return ImageWidget(
                  musicItem: snapshot.data ?? MusicItem.empty,
                  borderRadius: 10,
                );
              },
            ),
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
                            color: Colors.black,
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
                            color: Colors.black54,
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
                // if (durationState.total == Duration.zero) durationState = getIt<MusicPlayerClass>().getDurationState;
                final progress = durationState?.progress ?? Duration.zero;
                // final buffered = durationState?.buffered ?? Duration.zero;
                final total = durationState?.total ?? Duration.zero;
                return ProgressBar(
                  thumbColor: Colors.black,
                  // thumbCanPaintOutsideBar: false,
                  thumbRadius: 7,
                  thumbGlowRadius: 16,
                  progressBarColor: Colors.black,
                  baseBarColor: Colors.black.withOpacity(0.24),
                  progress: progress,
                  // buffered: buffered,
                  // bufferedBarColor: Colors.grey[500],
                  total: total,
                  onSeek: (duration) {
                    GetIt.I.get<MusicPlayerClass>().seek(duration);
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.heart_broken_outlined,
                    size: 30,
                  ),
                ),
                RoundIconButton(
                  onPressed: () =>
                      GetIt.I.get<MusicPlayerClass>().seekToPrevious(),
                  icon: Icons.skip_previous,
                  size: 45,
                ),
                StreamBuilder<bool>(
                    stream: mpc.playingStream,
                    builder: (context, snapshot) {
                      return RoundIconButton(
                        onPressed: () {
                          if (snapshot.data ?? false) {
                            GetIt.I.get<MusicPlayerClass>().pause();
                          } else {
                            GetIt.I.get<MusicPlayerClass>().play();
                          }
                        },
                        icon: snapshot.data ?? false
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 60,
                      );
                    }),
                RoundIconButton(
                  onPressed: () => GetIt.I.get<MusicPlayerClass>().seekToNext(),
                  icon: Icons.skip_next,
                  size: 45,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_outline,
                    size: 30,
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
                              ? Colors.black
                              : Colors.grey,
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () {
                    getIt<MusicPlayerClass>().setShuffleModeEnabled(true);
                  },
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.shuffle,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MiniTrackWidgetWithTransition extends StatefulWidget {
  const MiniTrackWidgetWithTransition({super.key});

  @override
  State<MiniTrackWidgetWithTransition> createState() =>
      _MiniTrackWidgetWithTransitionState();
}

class _MiniTrackWidgetWithTransitionState
    extends State<MiniTrackWidgetWithTransition> with TickerProviderStateMixin {
  late AnimationController _ac;
  Offset _offset = Offset.zero;
  double width = 0;
  double _value = 0;

  MusicItem previousPlaying = MusicItem.empty;
  MusicItem currentPlaying = MusicItem.empty;
  MusicItem nextPlaying = MusicItem.empty;

  @override
  void initState() {
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0,
    );

    GetIt.I
        .get<MusicPlayerClass>()
        .previousPlayingStream
        .listen((event) => previousPlaying = event);
    GetIt.I.get<MusicPlayerClass>().currentPlayingStream.listen(
      (event) {
        currentPlaying = event;
        changeWithAnimation();
      },
    );
    GetIt.I
        .get<MusicPlayerClass>()
        .nextPlayingStream
        .listen((event) => nextPlaying = event);

    super.initState();
  }

  void changeWithAnimation() async {
    if (_value != 0) return;
  }

  void goToZero() async {
    if (_value > 0.5) {
      _value = 1 - _value;
    } else if (_value < -0.5) {
      _value = 1 + _value;
    }

    int steps = (_value ~/ 0.05).abs();

    for (int i = 0; i < steps; i++) {
      if (_value > 0) {
        _value -= 0.05;
        _ac.value = _value;
      } else if (_value < 0) {
        _value += 0.05;
        _ac.value = _value.abs();
      }
      await Future.delayed(const Duration(milliseconds: 40));
    }

    _offset = Offset.zero;
    _value = 0;
    _ac.value = _value;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (details) {
        _offset = Offset.zero;
        _value = 0;
        _ac.value = _value;
      },
      onHorizontalDragUpdate: (details) {
        if ((previousPlaying == MusicItem.empty && details.delta.dx > 0) ||
            (nextPlaying == MusicItem.empty && details.delta.dx < 0)) {
          return;
        }
        _offset += details.delta;
        double newValue = (_offset.dx / (width * 0.4));
        _ac.value = newValue.abs();

        if (newValue.isNegative != _value.isNegative || newValue == 0) {
          _value = newValue;
          setState(() {});
        } else {
          _value = newValue;
        }
      },
      onHorizontalDragEnd: (details) {
        if (_value < -0.5 || details.primaryVelocity! < -1000) {
          mpc.seekToNext();
        } else if (_value > 0.5 || details.primaryVelocity! > 1000) {
          mpc.seekToPrevious();
        }

        goToZero();
      },
      child: Stack(
        children: [
          _value > 0
              ? FadeTransition(
                  opacity: Tween(begin: -0.8, end: 1.0).animate(_ac),
                  child: MiniTrackCardForNavigationPanel(
                      musicItem: previousPlaying),
                )
              : Container(),
          FadeTransition(
            opacity: Tween(begin: 1.0, end: -0.8).animate(_ac),
            child: MiniTrackCardForNavigationPanel(musicItem: currentPlaying),
          ),
          _value < 0
              ? FadeTransition(
                  opacity: Tween(begin: -0.8, end: 1.0).animate(_ac),
                  child:
                      MiniTrackCardForNavigationPanel(musicItem: nextPlaying),
                )
              : Container(),
        ],
      ),
    );
  }
}
