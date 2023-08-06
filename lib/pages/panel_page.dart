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
    double fadeIn = 25;
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
/*
class MiniTrackSliderWidget extends StatefulWidget {
  final PageController controller;

  const MiniTrackSliderWidget({super.key, required this.controller});

  @override
  State<MiniTrackSliderWidget> createState() => _MiniTrackSliderWidgetState();
}

class _MiniTrackSliderWidgetState extends State<MiniTrackSliderWidget> {
  // late PageController controller;
  late List<MusicItem> queue;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // widget.controller;
    queue = [
      MusicItem(
        id: 0,
        mediaItem: const MediaItem(
          id: "",
          title: "Unknown track title",
        ),
      ),
    ];
    currentIndex = 0;

    GetIt.I<MusicPlayerClass>().queueStream.listen((event) {
      setState(() {
        queue = event;
        widget.controller.jumpToPage(0);
      });
    });

    GetIt.I<MusicPlayerClass>().currentIndexStream.listen((event) {
      widget.controller.hasClients
          ? widget.controller.animateToPage(
              event,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
          : null;
      currentIndex = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      physics: const BouncingScrollPhysics(),
      itemCount: queue.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MiniTrackCardForNavigationPanel(
            mediaItem: queue[index],
          ),
        );
      },
      onPageChanged: (value) {
        if (value > currentIndex) {
          GetIt.I.get<MusicPlayerClass>().seekToNext();
        } else if (value < currentIndex) {
          GetIt.I.get<MusicPlayerClass>().seekToPrevious();
        }
        widget.controller.animateToPage(value,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
      },
    );
  }
}

class TrackSliderWidget extends StatefulWidget {
  final PageController controller;

  const TrackSliderWidget({super.key, required this.controller});

  @override
  State<TrackSliderWidget> createState() => _TrackSliderWidgetState();
}

class _TrackSliderWidgetState extends State<TrackSliderWidget> {
  late List<MusicItem> queue;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // widget.controller;
    queue = [
      MusicItem(
        id: 0,
        mediaItem: const MediaItem(
          id: "",
          title: "Unknown track title",
        ),
      ),
    ];
    currentIndex = 0;

    GetIt.I<MusicPlayerClass>().queueStream.listen((event) {
      setState(() {
        queue = event;
        widget.controller.jumpToPage(0);
      });
    });

    GetIt.I<MusicPlayerClass>().currentIndexStream.listen((event) {
      widget.controller.hasClients
          ? widget.controller.animateToPage(
              event,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
          : null;
      currentIndex = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      physics: const BouncingScrollPhysics(),
      itemCount: queue.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TrackCard(
            mediaItem: queue[index],
          ),
        );
      },
      onPageChanged: (value) {
        if (value > currentIndex) {
          GetIt.I.get<MusicPlayerClass>().seekToNext();
        } else if (value < currentIndex) {
          GetIt.I.get<MusicPlayerClass>().seekToPrevious();
        }
        widget.controller.animateToPage(value,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
      },
    );
  }
}*/
