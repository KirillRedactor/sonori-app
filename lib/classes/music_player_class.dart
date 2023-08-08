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
  final _zerothPlayer = AudioPlayer();

  MusicItem _firstPlayerCurrentMusicItem = MusicItem.empty;
  MusicItem _secondPlayerCurrentMusicItem = MusicItem.empty;
  MusicItem _zerothPlayerCurrentMusicItem = MusicItem.empty;

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
    durationStateStream.listen((event) => _durationState = event);

    // End streams

    _zerothPlayer.positionStream.listen((event) {
      if (_zerothPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: event,
          buffered: _zerothPlayer.bufferedPosition,
          total: _zerothPlayer.duration ?? Duration.zero);
      _durationStateStreamController.add(durationState);
    });
    _zerothPlayer.durationStream.listen((event) {
      if (_zerothPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: _zerothPlayer.position,
          buffered: _zerothPlayer.bufferedPosition,
          total: event ?? Duration.zero);
      _durationStateStreamController.add(durationState);
    });

    _firstPlayer.positionStream.listen((event) {
      if (_firstPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: event,
          buffered: _firstPlayer.bufferedPosition,
          total: _firstPlayer.duration ?? Duration.zero);
      _durationStateStreamController.add(durationState);
    });
    _firstPlayer.durationStream.listen((event) {
      if (_firstPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: _firstPlayer.position,
          buffered: _firstPlayer.bufferedPosition,
          total: event ?? Duration.zero);
      _durationStateStreamController.add(durationState);
    });

    _secondPlayer.positionStream.listen((event) {
      if (_secondPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: event,
          buffered: _secondPlayer.bufferedPosition,
          total: _secondPlayer.duration ?? Duration.zero);
      _durationStateStreamController.add(durationState);
    });
    _secondPlayer.durationStream.listen((event) {
      if (_secondPlayerCurrentMusicItem != _currentPlaying) return;
      DurationState durationState = DurationState(
          progress: _secondPlayer.position,
          buffered: _secondPlayer.bufferedPosition,
          total: event ?? Duration.zero);
      _durationStateStreamController.add(durationState);
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
    } else {
      _previousPlayingStreamController.add(MusicItem.empty);
    }
    _updateMediaItemZerothPlayer(
        fromItem > 0 ? _musicItemList[fromItem - 1] : MusicItem.empty);

    _currentPlayingStreamController.add(_musicItemList[fromItem]);
    _currentPlaying = _musicItemList[fromItem];
    _updateMediaItemFirstPlayer(_musicItemList[fromItem]);

    if (fromItem != _musicItemList.length - 1) {
      _updateMediaItemSecondPlayer(_musicItemList[fromItem + 1]);
      _nextPlayingStreamController.add(_musicItemList[fromItem + 1]);
    }

    // _playingStreamController.add(playQueue);
    playQueue ? play() : null;
  }

  Future<void> play() async {
    if (currentPlaying == MusicItem.empty) return;
    !_isPlaying ? _playingStreamController.add(true) : null;
    if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
      print("Hello zeroth play func");
      _zerothPlayer.play();
    } else if (_firstPlayerCurrentMusicItem == _currentPlaying) {
      _firstPlayer.play();
    } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
      _secondPlayer.play();
    }
  }

  Future<void> pause() async {
    _playingStreamController.add(false);
    _zerothPlayer.pause();
    _firstPlayer.pause();
    _secondPlayer.pause();
  }

  Future<void> seekToNext() async {
    if (_currentPlaying.index == _musicItemList.length - 1) return;
    _zerothPlayer.pause();
    _firstPlayer.pause();
    _secondPlayer.pause();
    _seekAllToZero();

    Player needToUpdate = Player.unknown;
    List<MusicItem> filter = [_previousPlaying, MusicItem.empty];
    if (filter.contains(_zerothPlayerCurrentMusicItem)) {
      needToUpdate = Player.zeroth;
    } else if (filter.contains(_firstPlayerCurrentMusicItem)) {
      needToUpdate = Player.first;
    } else if (filter.contains(_secondPlayerCurrentMusicItem)) {
      needToUpdate = Player.second;
    }
    _previousPlayingStreamController.add(_currentPlaying);
    _previousPlaying = _currentPlaying;
    _currentPlayingStreamController.add(_nextPlaying);
    _currentPlaying = _nextPlaying;
    if (_currentPlaying.index != _musicItemList.length - 1) {
      _nextPlayingStreamController.add(_musicItemList[_nextPlaying.index! + 1]);
      _nextPlaying = _musicItemList[_nextPlaying.index! + 1];
    } else {
      _nextPlayingStreamController.add(MusicItem.empty);
      _nextPlaying = MusicItem.empty;
    }
    if (_currentPlaying.index != _musicItemList.length - 1) {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(_musicItemList[_nextPlaying.index!]);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(_musicItemList[_nextPlaying.index!]);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(_musicItemList[_nextPlaying.index!]);
      }
    } else {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(MusicItem.empty);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(MusicItem.empty);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(MusicItem.empty);
      }
    }

    play();
  }

  Future<void> seekToPrevious() async {
    if (_currentPlaying.index == 0) return;
    _zerothPlayer.pause();
    _firstPlayer.pause();
    _secondPlayer.pause();
    _seekAllToZero();

    Player needToUpdate = Player.unknown;
    List<MusicItem> filter = [_nextPlaying, MusicItem.empty];

    if (filter.contains(_zerothPlayerCurrentMusicItem)) {
      needToUpdate = Player.zeroth;
    } else if (filter.contains(_firstPlayerCurrentMusicItem)) {
      needToUpdate = Player.first;
    } else if (filter.contains(_secondPlayerCurrentMusicItem)) {
      needToUpdate = Player.second;
    }

    _nextPlayingStreamController.add(_currentPlaying);
    _nextPlaying = _currentPlaying;
    _currentPlayingStreamController.add(_previousPlaying);
    _currentPlaying = _previousPlaying;

    if (_currentPlaying.index != 0) {
      _previousPlayingStreamController
          .add(_musicItemList[_currentPlaying.index! - 1]);
      _previousPlaying == _musicItemList[_currentPlaying.index! - 1];
    } else {
      _previousPlayingStreamController.add(MusicItem.empty);
      _previousPlaying == MusicItem.empty;
    }

    if (_currentPlaying.index != 0) {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(
            _musicItemList[_currentPlaying.index! - 1]);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(_musicItemList[_currentPlaying.index! - 1]);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(
            _musicItemList[_currentPlaying.index! - 1]);
      }
    } else {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(MusicItem.empty);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(MusicItem.empty);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(MusicItem.empty);
      }
    }

    play();
  }

  Future<void> _seekAllToZero() async {
    _zerothPlayer.seek(Duration.zero);
    _firstPlayer.seek(Duration.zero);
    _secondPlayer.seek(Duration.zero);
  }

  Future<void> _updateMediaItemZerothPlayer(MusicItem musicItem) async {
    try {
      _zerothPlayerCurrentMusicItem = musicItem;
      AudioSource as = AudioSource.uri(
        Uri.parse(musicItem.mediaItem.id),
        tag: musicItem.mediaItem,
      );
      final playlist = ConcatenatingAudioSource(children: [as]);
      await _zerothPlayer.setAudioSource(playlist);
    } catch (e) {
      print("Error: $e");
    }
    return;
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

enum Player { unknown, zeroth, first, second }

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
