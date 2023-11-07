import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';
import 'package:musicplayer_app/classes/playlist_class.dart';
import 'package:musicplayer_app/components/cards_widgets.dart';

class ExoItem extends StatefulWidget {
  final Widget? child, title, subtitle;
  final PlaylistClass? playlistClass;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const ExoItem({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.playlistClass,
    this.onPressed,
    this.onLongPress,
  });

  static ExoItem trackFromClass({
    required MusicItem musicItem,
    PlaylistClass? playlistClass,
  }) =>
      ExoItem(
        onPressed: () {
          if (playlistClass != null) {
            final index = playlistClass.indexOf(musicItem.id);
            if (index != -1) {
              mpc.playPlaylist(
                playlistClass,
                fromItem: index,
                playPlaylist: true,
              );
            } else {
              return;
            }
          } else {
            mpc.updateQueue([musicItem], playQueue: true);
          }
        },
        title: Text(
          musicItem.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          musicItem.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            fit: BoxFit.scaleDown,
            imageUrl: musicItem.artUri.toString(),
            placeholder: (context, url) => Container(
              color: Colors.grey.shade400,
            ),
            errorWidget: (context, url, error) => errorImage,
          ),
        ),
      );

  static ExoItem get loading => ExoItem(
        onPressed: () {},
        /*title: Text(
          musicItem.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[100],
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          musicItem.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),*/
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: CircularProgressIndicator(),
        ),
      );

  /*static FutureBuilder<MusicItem> fromTrackId({
    required String id,
  }) =>
      FutureBuilder(
        future: fc.getMusicItem(id),
        builder: (context, snapshot) {
          print("hello ${snapshot.data}");
          if (snapshot.hasData) {
            return ExoItem.trackFromClass(musicItem: snapshot.data!);
          } else {
            return ExoItem.loading;
          }
        },
      );*/

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
