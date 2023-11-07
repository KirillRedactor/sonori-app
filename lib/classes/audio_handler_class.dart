// ignore_for_file: unused_import

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/classes_shortcuts.dart';
import 'package:musicplayer_app/classes/music_player_class.dart';
import 'package:musicplayer_app/classes/musicitem_class.dart';

/// Инициализация [AudioHandler]
Future<AudioHandler> initAudioService() async {
  ///Session part
  final session = await AudioSession.instance;
  await session.configure(
    const AudioSessionConfiguration.music().copyWith(
      androidWillPauseWhenDucked: true,
    ),
  );
  session.interruptionEventStream.listen((event) {
    if (event.type == AudioInterruptionType.unknown) {
      mpc.pause();
    }
  });

  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.anomalouszone.music.audio',
      androidNotificationChannelName: 'Exontix music player',
      // androidNotificationOngoing: true,
      androidStopForegroundOnPause: false,
      // androidShowNotificationBadge: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late MediaItem _mediaItem = const MediaItem(
    id: "",
    title: "Unknown track title",
  );

  MyAudioHandler() {
    // _initAudioPlayback();

    _notifyAudioHandlerAboutPlaybackEvents();

    GetIt.I<MusicPlayerClass>().currentPlayingStream.listen((event) {
      playMediaItem(event.mediaItem!.copyWith(
          duration: GetIt.I.get<MusicPlayerClass>().durationState.total));
    });
  }

  // ignore: unused_element
  Future<void> _initStreams() async {
    GetIt.I<MusicPlayerClass>().playingStream.listen((event) {
      // print(event ? "MediaControl.pause" : "MediaControl.play");
      event = GetIt.I<MusicPlayerClass>().isPlaying;
      playbackState.add(playbackState.value.copyWith(
        playing: event,
        controls: [
          MediaControl.stop,
          MediaControl.skipToPrevious,
          if (event) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
      ));
    });

    // GetIt.I<MusicPlayerClass>().durationStateStream.listen((event) {
    //   playMediaItem(_mediaItem.copyWith(duration: event.total));
    // });

    GetIt.I<MusicPlayerClass>().currentPlayingStream.listen((event) {
      playMediaItem(event.mediaItem!.copyWith(
          duration: GetIt.I.get<MusicPlayerClass>().durationState.total));
    });
  }

  @override
  Future<void> play() async {
    GetIt.I.get<MusicPlayerClass>().play();
  }

  @override
  Future<void> pause() async {
    GetIt.I.get<MusicPlayerClass>().pause();
  }

  @override
  Future<void> stop() async {
    GetIt.I.get<MusicPlayerClass>().stop();
  }

  @override
  Future<void> seek(Duration position) async {
    GetIt.I.get<MusicPlayerClass>().seek(position);
  }

  @override
  Future<void> skipToNext() async {
    GetIt.I.get<MusicPlayerClass>().seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    GetIt.I.get<MusicPlayerClass>().seekToPrevious();
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == "pause") {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[ProcessingState.idle]!,
        playing: false,
      ));
    }
    return super.customAction(name, extras);
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    _mediaItem = mediaItem;
    this.mediaItem.add(mediaItem);
    // return super.playMediaItem(mediaItem);
  }

  /*void _setNotificationButtons() {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.stop,
        MediaControl.skipToPrevious,
        if (_firstPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        // const MediaControl(
        //     androidIcon: "drawable/audio_service_stop",
        //     label: "Test",
        //     action: MediaAction.stop),
      ],
      systemActions: {
        MediaAction.seek,
      },
      androidCompactActionIndices: [1, 2, 3],
    ));
  }*/

  /*void _notifyCurrentMusicItemPlaybackEvent() {
    GetIt.I
        .get<MusicPlayerClass>()
        .currentPlayingMediaItemStream
        .listen((event) {
      mediaItem.add(event);
    });
  }*/

  @override
  Future<void> fastForward() async {}

  @override
  Future<void> rewind() async {}

  void _notifyAudioHandlerAboutPlaybackEvents() {
    GetIt.I
        .get<MusicPlayerClass>()
        .playbackEventStream
        .listen((PlaybackEvent event) {
      playMediaItem(_mediaItem.copyWith(
          duration: GetIt.I.get<MusicPlayerClass>().durationState.total));
      final playing = GetIt.I.get<MusicPlayerClass>().isPlaying;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          /*const MediaControl(
            androidIcon: 'drawable/audio_service_stop',
            label: 'Unlike',
            action: MediaAction.rewind,
          ),*/
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
          /*const MediaControl(
            androidIcon: 'drawable/audio_service_stop',
            label: 'Like',
            action: MediaAction.fastForward,
          ),*/
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[event.processingState]!,
        playing: playing,
        updatePosition: GetIt.I.get<MusicPlayerClass>().durationState.progress,
        bufferedPosition: event.bufferedPosition,
        speed: 1,
        queueIndex: event.currentIndex,
      ));
    });
  }

  // ignore: unused_element
  void _initAudioPlayback() {
    playMediaItem(GetIt.I<MusicPlayerClass>().currentPlaying.mediaItem ??
        const MediaItem(
          id: "",
          title: "Unknown track title",
        ));

    bool playing = GetIt.I<MusicPlayerClass>().isPlaying;
    DurationState durationState = GetIt.I<MusicPlayerClass>().durationState;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.stop,
        MediaControl.skipToPrevious,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
      },
      androidCompactActionIndices: [1, 2, 3],
      playing: playing,
      updatePosition: durationState.progress,
      bufferedPosition: durationState.buffered,
      speed: 1,
    ));

    /*_firstPlayer.durationStream.listen((duration) {
      var index = _firstPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_firstPlayer.shuffleModeEnabled) {
        index = _firstPlayer.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });*/
  }
}
