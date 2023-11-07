// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
// ignore: unused_import
import 'dart:ui' as ui;

import '../classes/music_player_class.dart';

const _defoultArtUrl =
    "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/exontix-music-white.png?alt=media&token=fd38d7b8-1eb7-4351-8883-97adc9ae13cf&_gl=1*1t7po8d*_ga*MzMyNDEwNzEyLjE2ODUyMTAzNjI.*_ga_CW55HF8NVT*MTY4NTQ2MjMwOS4xLjEuMTY4NTQ2Mjg5OS4wLjAuMA..";

class MiniTrackCardForNavigationPanel extends StatefulWidget {
  final MusicItem musicItem;
  // final PageController controller;

  const MiniTrackCardForNavigationPanel({
    super.key,
    required this.musicItem,
    // required this.controller,
  });

  @override
  State<MiniTrackCardForNavigationPanel> createState() =>
      _MiniTrackCardForNavigationPanelState();
}

class _MiniTrackCardForNavigationPanelState
    extends State<MiniTrackCardForNavigationPanel> {
  // double height = 0;
  // double width = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: Icon(
              Icons.favorite_border,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                MarqueeWidget(
                  child: Text(
                    widget.musicItem.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                MarqueeWidget(
                  child: Text(
                    widget.musicItem.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TrackWidget extends StatefulWidget {
  const TrackWidget({super.key});

  @override
  State<TrackWidget> createState() => _TrackWidgetState();
}

class _TrackWidgetState extends State<TrackWidget> {
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

    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: width,
      width: width,
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
              pageController.hasClients
                  ? 5 / pageController.position.extentInside
                  : 0.1,
              pageController.hasClients
                  ? 1 - 5 / pageController.position.extentInside
                  : 0.1,
              1.0
            ], // 10% black, 80% transparent, 10% black
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: PageView(
          physics: BouncingScrollPhysics(),
          controller: pageController,
          children: [
            if (_musicItemsState.previousPlaying != MusicItem.empty)
              TrackCard(
                musicItem: _musicItemsState.previousPlaying,
              ),
            TrackCard(
              musicItem: _musicItemsState.currentPlaying,
            ),
            if (_musicItemsState.nextPlaying != MusicItem.empty)
              TrackCard(
                musicItem: _musicItemsState.nextPlaying,
              ),
          ],
          onPageChanged: (value) {
            currentPage = value;
          },
        ),
      ),
    );
  }
}

class TrackCard extends StatefulWidget {
  final MusicItem musicItem;

  const TrackCard({super.key, required this.musicItem});

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  final double blurAmount = 8;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: StreamBuilder<bool>(
        stream: mpc.playingStream,
        builder: (context, snapshot) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 350),
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  color: (snapshot.data ?? mpc.isPlaying)
                      ? widget.musicItem.color
                      : Colors.transparent,
                  blurRadius: 20,
                  spreadRadius: -15,
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.musicItem.mediaItem!.artUri.toString(),
              placeholder: (context, url) => Container(
                color: Colors.grey.shade400,
              ),
              errorWidget: (context, url, error) {
                return errorImage;
              },
            ),
          );
        },
      ),
    );
  }
}

/*BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: blurAmount,
                sigmaY: blurAmount,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: widget.mediaItem.artUri.toString(),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade400,
                  ),
                  errorWidget: (context, url, error) => errorImage,
                ),
              ),
            ),*/

// ==============================================================================================================================================
// ==============================================================================================================================================
// ==============================================================================================================================================
// ==============================================================================================================================================
// ==============================================================================================================================================
// ==============================================================================================================================================

class ImageWidget extends StatelessWidget {
  final MusicItem musicItem;
  final double? borderRadius;

  const ImageWidget({super.key, required this.musicItem, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width * 0.8,
      width: width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: musicItem.artUri != ""
            ? CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: musicItem.artUri.toString(),
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade400,
                ),
                errorWidget: (context, url, error) => errorImage,
              )
            : null,
      ),
    );
  }
}

class NeuBox extends StatelessWidget {
  final Widget child;
  const NeuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 15,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(-5, -5),
          ),
        ],
      ),
      child: Center(
        child: child,
      ),
    );
  }
}

class FlatBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color color;
  final Clip clipBehavior;
  final double? height, width;
  const FlatBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius,
    this.borderWidth = 2,
    this.borderColor = Colors.black,
    this.color = Colors.transparent,
    this.clipBehavior = Clip.hardEdge,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        color: color,
      ),
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class RoundIconButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;
  // final double size;
  final double? size, height, width, borderWidth;
  final EdgeInsetsGeometry? padding;
  final Color? iconColor;
  const RoundIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.size,
      this.height,
      this.width,
      this.borderWidth,
      this.padding,
      this.iconColor});
  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() {
        isDown = true;
      }),
      onTapCancel: () => setState(() {
        isDown = false;
      }),
      onTapUp: (details) => setState(() {
        isDown = false;
      }),
      onTap: () async {
        setState(() => isDown = true);
        // await Future.delayed(Duration(milliseconds: 50));
        widget.onPressed();
        await Future.delayed(Duration(milliseconds: 200));
        setState(() => isDown = false);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: widget.height,
        width: widget.width,
        padding: widget.padding,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10000,
            ),
            border: Border.all(
              width: widget.borderWidth ?? 2,
              color: Colors.black,
            ),
            color: isDown ? Colors.black : Colors.transparent),
        child: Icon(
          widget.icon,
          color: !isDown ? Colors.black : Colors.white,
          size: widget.size,
        ),
      ),
    );
  }
}

// * Marquee widget

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration pauseDuration;
  final double blankSpace, offset, velocity;
  final double fadeIn, fadeOut;
  final bool isScrolling;

  const MarqueeWidget({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.pauseDuration = const Duration(seconds: 3),
    this.blankSpace = 60,
    this.offset = 10,
    this.velocity = 40,
    this.fadeIn = 10,
    this.fadeOut = 10,
    this.isScrolling = true,
  }) : super(key: key);
  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;
  late PageController pageController;
  bool isAnimated = false;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0);
    pageController = PageController();
    // WidgetsBinding.instance.addPostFrameCallback(scroll);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScrolling && !isAnimated) {
      scroll(0);
      isAnimated = true;
    }
    return Expanded(
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
              scrollController.hasClients
                  ? widget.fadeIn / scrollController.position.extentInside
                  : 0.1,
              scrollController.hasClients
                  ? 1 - widget.fadeOut / scrollController.position.extentInside
                  : 0.1,
              1.0
            ], // 10% black, 80% transparent, 10% black
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.isScrolling ? 2 : 1,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: widget.direction,
            controller: index == 0 ? scrollController : null,
            child: widget.direction == Axis.horizontal
                ? Row(
                    children: [
                      SizedBox(width: widget.offset),
                      widget.child,
                      SizedBox(width: widget.blankSpace),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: widget.offset),
                      widget.child,
                      SizedBox(height: widget.blankSpace),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void scroll(_) async {
    await Future.delayed(widget.pauseDuration);

    double oCSV = scrollController.hasClients
        ? scrollController.position.maxScrollExtent
        : 0;
    double extentAfter =
        scrollController.hasClients ? scrollController.position.extentAfter : 0;

    if (scrollController.hasClients &&
        extentAfter - (widget.blankSpace + widget.offset) > 0) {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(
          milliseconds: (oCSV / widget.velocity * 1000).toInt(),
        ),
        curve: Curves.linear,
      );
    }
    if (pageController.hasClients &&
        extentAfter - (widget.blankSpace + widget.offset) > 0) {
      await pageController.animateToPage(
        1,
        duration: Duration(
          milliseconds:
              (pageController.position.extentInside / widget.velocity * 1000)
                  .toInt(),
        ),
        curve: Curves.linear,
      );
    }
    if (extentAfter - (widget.blankSpace + widget.offset) > 0) {
      if (scrollController.hasClients) scrollController.jumpTo(0);
      if (pageController.hasClients) pageController.jumpToPage(0);
      // }
    }
    scroll(0);
  }
}

CachedNetworkImage errorImage = CachedNetworkImage(
  imageUrl: _defoultArtUrl,
  placeholder: (context, url) => Container(
    color: Colors.grey.shade400,
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);
