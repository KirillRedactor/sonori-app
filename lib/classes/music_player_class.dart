import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/audio_handler_class.dart';

class MusicPlayerClass {
  final getIt = GetIt.I;

  // ignore: unused_field
  AudioHandler _handler = EmptyAudioHandler();

  final _firstPlayer = AudioPlayer();
  final _secondPlayer = AudioPlayer();

  MusicItem _firstPlayerCurrentMusicItem = MusicItem.empty;
  MusicItem _secondPlayerCurrentMusicItem = MusicItem.empty;

  List<MusicItem> _queue = [];
  List<MusicItem> get getQueue => _queue;
  List<MusicItem> _musicItemList = [];

  // Current playing variables
  final StreamController<MusicItem> _currentPlayingStreamController =
      StreamController<MusicItem>.broadcast();
  Stream<MusicItem> get currentPlayingStream =>
      _currentPlayingStreamController.stream;
  MusicItem _currentPlaying = MusicItem.empty;
  MusicItem get currentPlaying => _currentPlaying;

  // Previous playing variables
  final StreamController<MusicItem> _previousPlayingStreamController =
      StreamController<MusicItem>.broadcast();
  Stream<MusicItem> get previousPlayingStream =>
      _previousPlayingStreamController.stream;
  MusicItem _previousPlaying = MusicItem.empty;
  MusicItem get previousPlaying => _previousPlaying;

  // Next playing variables
  final StreamController<MusicItem> _nextPlayingStreamController =
      StreamController<MusicItem>.broadcast();
  Stream<MusicItem> get nextPlayingStream =>
      _nextPlayingStreamController.stream;
  MusicItem _nextPlaying = MusicItem.empty;
  MusicItem get nextPlaying => _nextPlaying;

  // Playing variables
  final StreamController<bool> _playingStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> get playingStream => _playingStreamController.stream;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // DurationState variables
  final StreamController<DurationState> _durationStateStreamController =
      StreamController<DurationState>.broadcast();
  Stream<DurationState> get durationStateStream =>
      _durationStateStreamController.stream;
  DurationState _durationState = DurationState.zero;
  DurationState get durationState => _durationState;

  MusicPlayerClass() {
    init();
  }

  Future<void> init() async {
    final AudioHandler ah = await initAudioService();
    GetIt.I.registerSingleton<AudioHandler>(ah);

    await getIt.allReady();
    _handler = getIt<AudioHandler>();

    // Streams
    currentPlayingStream.listen((event) => _currentPlaying = event);
    previousPlayingStream.listen((event) => _previousPlaying = event);
    nextPlayingStream.listen((event) => _nextPlaying = event);

    playingStream.listen((event) => _isPlaying = event);

    // End streams

    currentPlayingStream.listen((event) {
      if (_firstPlayerCurrentMusicItem != event &&
          _secondPlayerCurrentMusicItem != event) {
        _updateMediaItemFirstPlayer(event);
      } else if (_firstPlayerCurrentMusicItem == event) {
        if (isPlaying) {
          _firstPlayer.play();
          _secondPlayer.pause();
        }
      } else if (_secondPlayerCurrentMusicItem == event) {
        if (isPlaying) {
          _secondPlayer.play();
          _firstPlayer.pause();
        }
      }
    });

    nextPlayingStream.listen((event) {
      /*if (_firstPlayerCurrentMusicItem != event &&
          _secondPlayerCurrentMusicItem != event) {
        _updateMediaItemSecondPlayer(event);
      } else*/
      if (_firstPlayerCurrentMusicItem == _currentPlaying) {
        _updateMediaItemSecondPlayer(event);
      } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
        _updateMediaItemFirstPlayer(event);
      }
    });
  }

  Future<void> updateQueue(
    List<MusicItem> newQueue, {
    int fromItem = 0,
    bool playQueue = true,
    bool isShuffle = false,
  }) async {
    for (int i = 0; i < newQueue.length; i++) {
      newQueue[i] = newQueue[i].copyWith(index: i);
    }
    _queue = newQueue;
    _musicItemList = newQueue;

    if (fromItem > 0) {
      _previousPlayingStreamController.add(_musicItemList[fromItem - 1]);
    }
    _updateMediaItemFirstPlayer(_musicItemList[fromItem]);
    _currentPlayingStreamController.add(_musicItemList[fromItem]);
    _currentPlaying = _musicItemList[fromItem];
    if (fromItem != _musicItemList.length - 1) {
      _updateMediaItemSecondPlayer(_musicItemList[fromItem + 1]);
      _nextPlayingStreamController.add(_musicItemList[fromItem + 1]);
    }

    // _playingStreamController.add(playQueue);
    playQueue ? play() : null;
  }

  Future<void> _updateMediaItemFirstPlayer(MusicItem musicItem) async {
    try {
      _firstPlayerCurrentMusicItem = musicItem;
      AudioSource as = AudioSource.uri(
        Uri.parse(musicItem.mediaItem.id),
        tag: musicItem.mediaItem,
      );
      final playlist = ConcatenatingAudioSource(children: [as]);
      await _firstPlayer.setAudioSource(playlist);
    } catch (e) {
      print("Error: $e");
    }
    return;
  }

  Future<void> play() async {
    if (currentPlaying == MusicItem.empty) return;
    _playingStreamController.add(true);
    if (_firstPlayerCurrentMusicItem == _currentPlaying) {
      _firstPlayer.play();
    } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
      _secondPlayer.play();
    }
  }

  Future<void> pause() async {
    _playingStreamController.add(false);
    _firstPlayer.pause();
    _secondPlayer.pause();
  }

  Future<void> seekToNext() async {
    _previousPlayingStreamController.add(_currentPlaying);
    _currentPlayingStreamController.add(_nextPlaying);
    if (_nextPlaying.index != _musicItemList.length - 1) {
      _nextPlayingStreamController
          .add(_musicItemList[_nextPlaying.index ?? 0 + 1]);
    }
  }

  Future<void> seekToPrevious() async {
    _nextPlayingStreamController.add(_currentPlaying);
    _currentPlayingStreamController.add(_previousPlaying);
    if (_previousPlaying.index! > 0) {
      _previousPlayingStreamController
          .add(_musicItemList[_previousPlaying.index! - 1]);
    }
  }

  Future<void> _updateMediaItemSecondPlayer(MusicItem musicItem) async {
    try {
      _secondPlayerCurrentMusicItem = musicItem;
      AudioSource as = AudioSource.uri(
        Uri.parse(musicItem.mediaItem.id),
        tag: musicItem.mediaItem,
      );
      final playlist = ConcatenatingAudioSource(children: [as]);
      await _secondPlayer.setAudioSource(playlist);
    } catch (e) {
      print("Error: $e");
    }
    return;
  }
}

class MusicItem {
  int id;
  MediaItem mediaItem;
  int? index;

  MusicItem({required this.id, required this.mediaItem, this.index});

  static final empty = MusicItem(
    id: 0,
    mediaItem: const MediaItem(
      id: "",
      title: "Unknown track title",
    ),
  );

  MusicItem copyWith({int? id, MediaItem? mediaItem, int? index}) {
    return MusicItem(
      id: id ?? this.id,
      mediaItem: mediaItem ?? this.mediaItem,
      index: index ?? this.index,
    );
  }
}

class DurationState {
  const DurationState({
    this.progress = Duration.zero,
    this.buffered = Duration.zero,
    this.total = Duration.zero,
  });
  final Duration progress;
  final Duration buffered;
  final Duration total;

  static const zero = DurationState(
    progress: Duration.zero,
    total: Duration.zero,
    buffered: Duration.zero,
  );
}

class EmptyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {}
