// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: unused_import
import 'dart:ui' as ui;

import 'package:musicplayer_app/classes/music_player_class.dart';

const _defoultArtUrl =
    "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/exontix-music-white.png?alt=media&token=fd38d7b8-1eb7-4351-8883-97adc9ae13cf&_gl=1*1t7po8d*_ga*MzMyNDEwNzEyLjE2ODUyMTAzNjI.*_ga_CW55HF8NVT*MTY4NTQ2MjMwOS4xLjEuMTY4NTQ2Mjg5OS4wLjAuMA..";

class MiniTrackCardForNavigationPanel extends StatefulWidget {
  final MusicItem mediaItem;
  // final PageController controller;

  const MiniTrackCardForNavigationPanel({
    super.key,
    required this.mediaItem,
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
          width: 45,
          child: TextButton(
            onPressed: () {},
            child: Icon(
              Icons.favorite_border,
              size: 30,
              color: Colors.black,
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
                    widget.mediaItem.mediaItem.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                MarqueeWidget(
                  child: Text(
                    widget.mediaItem.mediaItem.artist ?? "Unknown artist",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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

class TrackCard extends StatefulWidget {
  final MusicItem mediaItem;

  const TrackCard({super.key, required this.mediaItem});

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  double blurAmount = 8;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: FlatBox(
        padding: EdgeInsets.zero,
        // height: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: widget.mediaItem.mediaItem.artUri.toString(),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade400,
                  ),
                  errorWidget: (context, url, error) => errorImage,
                ),
              ),
            ),
            MarqueeWidget(
              child: Text(
                widget.mediaItem.mediaItem.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            MarqueeWidget(
              child: Text(
                widget.mediaItem.mediaItem.artist ?? "Unknown artist",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
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
  placeholder: (context, url) =>
      const SizedBox(height: 80, width: 80, child: CircularProgressIndicator()),
  errorWidget: (context, url, error) => const Icon(Icons.error),
);
