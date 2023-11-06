import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer_app/classes/user_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

class MusicianCard extends StatefulWidget {
  final double height, width;
  final Widget child;
  final Widget musicianName;
  final Color color;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const MusicianCard({
    super.key,
    this.height = 180,
    this.width = 140,
    required this.child,
    required this.musicianName,
    this.color = Colors.transparent,
    this.onPressed,
    this.onLongPress,
  });

  static MusicianCard standard({
    required Widget child,
    required String musicianName,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) =>
      MusicianCard(
        musicianName: Text(
          musicianName,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: child,
      );

  static MusicianCard fromUserclass({
    required UserClass userClass,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) =>
      MusicianCard(
        musicianName: Text(
          userClass.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: userClass.avatarUri != null
            ? CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: userClass.avatarUri!,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade400,
                ),
                errorWidget: (context, url, error) => errorImage,
              )
            : Container(),
      );

  @override
  State<MusicianCard> createState() => MusicianCardState();
}

class MusicianCardState extends State<MusicianCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      height: widget.height,
      width: widget.width,
      child: TextButton(
        onPressed: widget.onPressed ?? () {},
        onLongPress: widget.onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10000),
              ),
              clipBehavior: Clip.hardEdge,
              height: widget.width,
              width: widget.width,
              child: widget.child,
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: widget.height - widget.width,
              width: widget.width,
              child: widget.musicianName,
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistCardWidget extends StatefulWidget {
  final double height, width;
  final Widget? child;
  final Widget? title;
  final Widget? description;
  final Color color;

  final void Function()? onPressed, onLongPress;

  const PlaylistCardWidget({
    super.key,
    this.height = 180,
    this.width = 140,
    this.child,
    this.title,
    this.description,
    this.color = Colors.transparent,
    this.onPressed,
    this.onLongPress,
  });

  static PlaylistCardWidget standart({
    Widget? child,
    String? title,
    String? description,
    Color? textColor,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) =>
      PlaylistCardWidget(
        onPressed: onPressed ?? () {},
        onLongPress: onLongPress,
        title: title != null
            ? Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        description: description != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              )
            : null,
        child: child,
      );

  @override
  State<PlaylistCardWidget> createState() => CardWidgetState();
}

class CardWidgetState extends State<PlaylistCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      height: widget.description != null ? widget.height : widget.width,
      width: widget.width,
      child: TextButton(
        onPressed: widget.onPressed ?? () {},
        onLongPress: widget.onLongPress,
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                if (widget.child != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: widget.width,
                    width: widget.width,
                    child: widget.child!,
                  ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: widget.width,
                  width: widget.width,
                  alignment: Alignment.topRight,
                  child: const Icon(Icons.flash_on, size: 15),
                ),
                if (widget.title != null)
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: widget.width,
                    width: widget.width,
                    alignment: Alignment.bottomLeft,
                    child: widget.title!,
                  ),
              ],
            ),
            if (widget.description != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: widget.height - widget.width,
                width: widget.width,
                child: widget.description!,
              ),
          ],
        ),
      ),
    );
  }
}

class HomeChip extends StatefulWidget {
  final double height, width;
  final Widget? child;
  final Widget? text;
  final Color? color;
  const HomeChip({
    super.key,
    this.height = 60,
    this.width = 180,
    this.child,
    this.text,
    this.color,
  });

  static HomeChip standard({Widget? child, String? text}) => HomeChip(
        text: Container(
          alignment: Alignment.centerLeft,
          child: text != null
              ? Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        child: child,
      );

  @override
  State<HomeChip> createState() => _HomeChipState();
}

class _HomeChipState extends State<HomeChip> {
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color ?? Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      height: widget.height,
      width: widget.width,
      child: TextButton(
        onPressed: () {},
        onLongPress: () {},
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          children: [
            if (widget.child != null)
              SizedBox(
                height: widget.height,
                width: widget.height,
                child: widget.child!,
              ),
            if (widget.text != null)
              SizedBox(
                height: widget.height,
                width: widget.child != null
                    ? widget.width - widget.height
                    : widget.width,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: widget.text,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
