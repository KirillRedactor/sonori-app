import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

class ExoItem extends StatefulWidget {
  final Widget? child, title, subtitle;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const ExoItem({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.onPressed,
    this.onLongPress,
  });

  static ExoItem trackFromClass({
    required MusicItem musicItem,
  }) =>
      ExoItem(
        onPressed: () {
          mpc.updateQueue([musicItem], playQueue: true);
        },
        title: Text(
          musicItem.mediaItem.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 16,
          ),
        ),
        subtitle: musicItem.mediaItem.artist != null
            ? Text(
                musicItem.mediaItem.artist!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              )
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            fit: BoxFit.scaleDown,
            imageUrl: musicItem.mediaItem.artUri.toString(),
            placeholder: (context, url) => Container(
              color: Colors.grey.shade400,
            ),
            errorWidget: (context, url, error) => errorImage,
          ),
        ),
      );

  static FutureBuilder<MusicItem> fromTrackId({
    required String id,
  }) =>
      FutureBuilder(
        future: fc.getMusicItem(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ExoItem.trackFromClass(musicItem: snapshot.data!);
          } else {
            return const SizedBox(height: 54);
          }
        },
      );

  @override
  State<ExoItem> createState() => ExoItemState();
}

class ExoItemState extends State<ExoItem> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed ?? () {},
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              widget.child ?? Container(),
              const Gap(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title ?? Container(),
                  widget.subtitle ?? Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
