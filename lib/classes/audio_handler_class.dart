// ======== Audio handler code part ============

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:musicplayer_app/classes/music_player_class.dart';

/// Инициализация [AudioHandler]
Future<AudioHandler> initAudioService() async {
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
  MyAudioHandler() {
    // playMediaItem(MediaItem(
    //   id: "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/t123456789.mp3?alt=media&token=9c9c9bc3-9e71-42e6-a266-f4d46395d8c7&_gl=1*f8ypit*_ga*MzMyNDEwNzEyLjE2ODUyMTAzNjI.*_ga_CW55HF8NVT*MTY4NTQ2MjMwOS4xLjEuMTY4NTQ2MjM4My4wLjAuMA..",
    //   title: "8 Legged Dreams",
    //   artist: "Unlike Pluto",
    //   album: "No album",
    //   duration: const Duration(minutes: 4),
    //   artUri: Uri.parse(
    //       "https://firebasestorage.googleapis.com/v0/b/flutterfire-music-tests.appspot.com/o/243b9e26190d947bfc046b6360446b2b.1000x1000x1.jpg?alt=media&token=7b901867-934c-4030-a05a-40d878916459"),
    // ));
    // _notifyAudioHandlerAboutPlaybackEvents();
    // _notifyCurrentMusicItemPlaybackEvent();
    // _setNotificationButtons();
  }

  /*@override
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
    GetIt.I.get<MusicPlayerClass>().seekTo(position);
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
  // ignore: avoid_renaming_method_parameters
  Future<void> playMediaItem(MediaItem newMediaItem) {
    mediaItem.add(newMediaItem);
    return super.playMediaItem(newMediaItem);
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

  void _notifyCurrentMusicItemPlaybackEvent() {
    GetIt.I
        .get<MusicPlayerClass>()
        .currentPlayingMediaItemStream
        .listen((event) {
      mediaItem.add(event);
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    final _firstPlayer = GetIt.I.get<MusicPlayerClass>().firstPlayer;
    _firstPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _firstPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.stop,
          MediaControl.skipToPrevious,
          if (_firstPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.seek,
        },
        androidCompactActionIndices: [1, 2, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_firstPlayer.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_firstPlayer.loopMode]!,
        shuffleMode: (_firstPlayer.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: _firstPlayer.position,
        bufferedPosition: _firstPlayer.bufferedPosition,
        speed: _firstPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });

    _firstPlayer.durationStream.listen((duration) {
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
    });
  }*/
}
