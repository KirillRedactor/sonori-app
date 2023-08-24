import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/audio_handler_class.dart';

MusicPlayerClass get mpc => GetIt.I<MusicPlayerClass>();

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

  final StreamController<List<MusicItem>> _queueStreamController =
      StreamController<List<MusicItem>>.broadcast();
  Stream<List<MusicItem>> get queuegStream => _queueStreamController.stream;

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

  // Music items state variables
  final StreamController<MusicItemsState> _musicItemsStateStreamController =
      StreamController<MusicItemsState>.broadcast();
  Stream<MusicItemsState> get musicItemsStateStream =>
      _musicItemsStateStreamController.stream;
  MusicItemsState _musicItemsState = MusicItemsState.empty;
  MusicItemsState get musicItemsState => _musicItemsState;

  Future<void> _updateMusicItemsState() async {
    _musicItemsState = MusicItemsState(
      previousPlaying: _previousPlaying,
      currentPlaying: _currentPlaying,
      nextPlaying: _nextPlaying,
    );
    _musicItemsStateStreamController.add(_musicItemsState);
  }

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

  // Duration variables
  final StreamController<Duration> _durationStreamController =
      StreamController<Duration>.broadcast();
  Stream<Duration> get durationStream => _durationStreamController.stream;
  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  // Playback variables
  final StreamController<PlaybackEvent> _playbackEventStreamController =
      StreamController<PlaybackEvent>.broadcast();
  Stream<PlaybackEvent> get playbackEventStream =>
      _playbackEventStreamController.stream;

  // Loop mode variables
  final StreamController<LoopMode> _loopModeSteamController =
      StreamController<LoopMode>.broadcast();
  Stream<LoopMode> get loopModeStream => _loopModeSteamController.stream;
  LoopMode _loopMode = LoopMode.off;
  LoopMode get loopMode => _loopMode;

  // Shuffle mode variables
  final StreamController<bool> _shuffleModeEnabledSteamController =
      StreamController<bool>.broadcast();
  Stream<bool> get shuffleModeEnabledSteam =>
      _shuffleModeEnabledSteamController.stream;
  bool _shuffleModeEnabled = false;
  bool get huffleModeEnabled => _shuffleModeEnabled;

  Duration smoothTransition = const Duration(seconds: 0);

  MusicPlayerClass() {
    init();
  }

  Future<void> init() async {
    final AudioHandler ah = await initAudioService();
    GetIt.I.registerSingleton<AudioHandler>(ah);

    await getIt.allReady();
    _handler = getIt<AudioHandler>();

    // Streams
    currentPlayingStream.listen((event) {
      _currentPlaying = event;
      if (isPlaying) return;
      if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
        DurationState durationState = DurationState(
            progress: _zerothPlayer.position,
            buffered: _zerothPlayer.bufferedPosition,
            total: _zerothPlayer.duration ?? Duration.zero);
        _durationStateStreamController.add(durationState);
      } else if (_firstPlayerCurrentMusicItem == _currentPlaying) {
        DurationState durationState = DurationState(
            progress: _firstPlayer.position,
            buffered: _firstPlayer.bufferedPosition,
            total: _firstPlayer.duration ?? Duration.zero);
        _durationStateStreamController.add(durationState);
      } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
        DurationState durationState = DurationState(
            progress: _secondPlayer.position,
            buffered: _secondPlayer.bufferedPosition,
            total: _secondPlayer.duration ?? Duration.zero);
        _durationStateStreamController.add(durationState);
      }
    });

    previousPlayingStream.listen((event) => _previousPlaying = event);
    nextPlayingStream.listen((event) => _nextPlaying = event);

    playingStream.listen((event) => _isPlaying = event);
    durationStateStream.listen((event) => _durationState = event);
    durationStream.listen((event) => _duration = event);

    loopModeStream.listen((event) => _loopMode = event);

    durationStateStream.listen((event) {
      if (event.total == Duration.zero || !_isPlaying) return;

      int time = event.total.inMilliseconds - event.progress.inMilliseconds;
      if (smoothTransition != Duration.zero) {
        if (time < smoothTransition.inMilliseconds &&
            time >
                smoothTransition.inMilliseconds -
                    const Duration(seconds: 1).inMilliseconds) {
          seekToNext(smooth: true);
        }
      } else {
        if (time < const Duration(milliseconds: 300).inMilliseconds) {
          if (loopMode == LoopMode.off) {
            seekToNext();
          } else if (loopMode == LoopMode.one) {
            _seekAllToZero();
          } else if (loopMode == LoopMode.all) {
            if (_currentPlaying == _queue.last) {
              updateQueue(
                _musicItemList,
                isShuffle: _shuffleModeEnabled,
                playQueue: true,
              );
            } else {
              seekToNext();
            }
          }
        }
      }
    });

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
      _durationStreamController.add(durationState.total);
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
      _durationStreamController.add(durationState.total);
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
      _durationStreamController.add(durationState.total);
    });

    _zerothPlayer.playbackEventStream.listen((event) {
      if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
        _playbackEventStreamController.add(event);
      }
    });
    _firstPlayer.playbackEventStream.listen((event) {
      if (_firstPlayerCurrentMusicItem == _currentPlaying) {
        _playbackEventStreamController.add(event);
      }
    });
    _secondPlayer.playbackEventStream.listen((event) {
      if (_secondPlayerCurrentMusicItem == _currentPlaying) {
        _playbackEventStreamController.add(event);
      }
    });
  }

  Future<void> updateQueue(
    List<MusicItem> newQueue, {
    int fromItem = 0,
    bool playQueue = false,
    bool isShuffle = false,
  }) async {
    for (int i = 0; i < newQueue.length; i++) {
      newQueue[i] = newQueue[i].copyWith(index: i);
    }
    _queue = [...newQueue];
    _musicItemList = [...newQueue];
    isShuffle ? _queue.shuffle() : null;

    pause();

    if (fromItem > 0) {
      _previousPlayingStreamController.add(_queue[fromItem - 1]);
      _previousPlaying = _queue[fromItem - 1];
    } else {
      _previousPlayingStreamController.add(MusicItem.empty);
      _previousPlaying = MusicItem.empty;
    }
    _updateMediaItemZerothPlayer(
        fromItem > 0 ? _queue[fromItem - 1] : MusicItem.empty);

    _currentPlayingStreamController.add(_queue[fromItem]);
    _currentPlaying = _queue[fromItem];
    _updateMediaItemFirstPlayer(_queue[fromItem]);

    if (fromItem != _queue.length - 1) {
      _updateMediaItemSecondPlayer(_queue[fromItem + 1]);
      _nextPlayingStreamController.add(_queue[fromItem + 1]);
      _nextPlaying = _queue[fromItem + 1];
    }

    // _playingStreamController.add(playQueue);
    playQueue ? play() : null;
    _updateMusicItemsState();
  }

  Future<void> play({bool smooth = false}) async {
    if (currentPlaying == MusicItem.empty) return;
    _playingStreamController.add(true);
    if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
      _zerothPlayer.play();
      if (smooth) {
        _smoothVolumeReductionZerothPlayer(
            invert: true, duration: smoothTransition);
      }
    } else if (_firstPlayerCurrentMusicItem == _currentPlaying) {
      _firstPlayer.play();
      if (smooth) {
        _smoothVolumeReductionFirstPlayer(
            invert: true, duration: smoothTransition);
      }
    } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
      _secondPlayer.play();
      if (smooth) {
        _smoothVolumeReductionSecondPlayer(
            invert: true, duration: smoothTransition);
      }
    }
  }

  Future<void> pause() async {
    _playingStreamController.add(false);
    _zerothPlayer.pause();
    _firstPlayer.pause();
    _secondPlayer.pause();
  }

  Future<void> stop() async {
    return; // TODO Make this function (maybe)
    // ignore: dead_code
    _zerothPlayer.stop();
    _firstPlayer.stop();
    _secondPlayer.stop();
  }

  // Future<void> seekTo(Duration duration) async => seek(duration);

  Future<void> seek(Duration duration) async {
    if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
      _zerothPlayer.seek(duration);
    } else if (_firstPlayerCurrentMusicItem == _currentPlaying) {
      _firstPlayer.seek(duration);
    } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
      _secondPlayer.seek(duration);
    }
  }

  Future<void> seekToNext({bool smooth = false}) async {
    if (_queue.indexOf(_currentPlaying) == _queue.length - 1) return;

    if (smooth) {
      if (_zerothPlayerCurrentMusicItem == _currentPlaying) {
        _firstPlayer.pause();
        _secondPlayer.pause();
        _smoothVolumeReductionZerothPlayer(duration: smoothTransition);
      } else if (_firstPlayerCurrentMusicItem == _currentPlaying) {
        _zerothPlayer.pause();
        _secondPlayer.pause();
        _smoothVolumeReductionFirstPlayer(duration: smoothTransition);
      } else if (_secondPlayerCurrentMusicItem == _currentPlaying) {
        _zerothPlayer.pause();
        _firstPlayer.pause();
        _smoothVolumeReductionSecondPlayer(duration: smoothTransition);
      }
    } else {
      _zerothPlayer.pause();
      _firstPlayer.pause();
      _secondPlayer.pause();
      _seekAllToZero();
    }

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
    if (_queue.indexOf(_currentPlaying) != _queue.length - 1) {
      _nextPlayingStreamController
          .add(_queue[_queue.indexOf(_nextPlaying) + 1]);
      _nextPlaying = _queue[_queue.indexOf(_nextPlaying) + 1];
    } else {
      _nextPlayingStreamController.add(MusicItem.empty);
      _nextPlaying = MusicItem.empty;
    }
    if (_queue.indexOf(_currentPlaying) != _queue.length - 1) {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(_queue[_queue.indexOf(_nextPlaying)]);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(_queue[_queue.indexOf(_nextPlaying)]);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(_queue[_queue.indexOf(_nextPlaying)]);
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

    isPlaying ? play(smooth: smooth) : null;
    _updateMusicItemsState();
  }

  Future<void> seekToPrevious() async {
    if (_queue.indexOf(_currentPlaying) == 0) return;
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

    if (_queue.indexOf(_currentPlaying) != 0) {
      _previousPlayingStreamController
          .add(_queue[_queue.indexOf(_currentPlaying) - 1]);
      _previousPlaying = _queue[_queue.indexOf(_currentPlaying) - 1];
    } else {
      _previousPlayingStreamController.add(MusicItem.empty);
      _previousPlaying = MusicItem.empty;
    }

    if (_queue.indexOf(_currentPlaying) != 0) {
      if (needToUpdate == Player.zeroth) {
        _updateMediaItemZerothPlayer(
            _queue[_queue.indexOf(_currentPlaying) - 1]);
      } else if (needToUpdate == Player.first) {
        _updateMediaItemFirstPlayer(
            _queue[_queue.indexOf(_currentPlaying) - 1]);
      } else if (needToUpdate == Player.second) {
        _updateMediaItemSecondPlayer(
            _queue[_queue.indexOf(_currentPlaying) - 1]);
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

    isPlaying ? play() : null;
    _updateMusicItemsState();
  }

  Future<void> setShuffleModeEnabled(bool enabled) async {
    _shuffleModeEnabledSteamController.add(enabled);
    _shuffleModeEnabled = enabled;
    if (enabled) {
      // Если включено

      List<MusicItem> newQueue = _queue;
      newQueue.shuffle();
      newQueue.remove(_currentPlaying);
      newQueue.insert(0, _currentPlaying);
      _queue = newQueue;

      if (_previousPlaying == _zerothPlayerCurrentMusicItem) {
        _updateMediaItemZerothPlayer(MusicItem.empty);
      } else if (_previousPlaying == _firstPlayerCurrentMusicItem) {
        _updateMediaItemFirstPlayer(MusicItem.empty);
      } else if (_previousPlaying == _secondPlayerCurrentMusicItem) {
        _updateMediaItemSecondPlayer(MusicItem.empty);
      }
      _previousPlayingStreamController.add(MusicItem.empty);
      _previousPlaying = MusicItem.empty;

      if (_queue.length > 1) {
        if (_nextPlaying == _zerothPlayerCurrentMusicItem) {
          _updateMediaItemZerothPlayer(_queue[1]);
        } else if (_nextPlaying == _firstPlayerCurrentMusicItem) {
          _updateMediaItemFirstPlayer(_queue[1]);
        } else if (_nextPlaying == _secondPlayerCurrentMusicItem) {
          _updateMediaItemSecondPlayer(_queue[1]);
        }
      }
      _nextPlayingStreamController.add(_queue[1]);
      _nextPlaying = _queue[1];
    } else {
      _queue = [..._musicItemList];

      if (_currentPlaying == _zerothPlayerCurrentMusicItem) {
        _updateMediaItemFirstPlayer(_currentPlaying.index! != 0
            ? _queue[_currentPlaying.index! - 1]
            : MusicItem.empty);
        _updateMediaItemSecondPlayer(_currentPlaying.index! != _queue.length - 1
            ? _queue[_currentPlaying.index! + 1]
            : MusicItem.empty);
      } else if (_currentPlaying == _firstPlayerCurrentMusicItem) {
        _updateMediaItemZerothPlayer(_currentPlaying.index! != 0
            ? _queue[_currentPlaying.index! - 1]
            : MusicItem.empty);
        _updateMediaItemSecondPlayer(_currentPlaying.index! != _queue.length - 1
            ? _queue[_currentPlaying.index! + 1]
            : MusicItem.empty);
      } else if (_currentPlaying == _secondPlayerCurrentMusicItem) {
        _updateMediaItemZerothPlayer(_currentPlaying.index! != 0
            ? _queue[_currentPlaying.index! - 1]
            : MusicItem.empty);
        _updateMediaItemFirstPlayer(_currentPlaying.index! != _queue.length - 1
            ? _queue[_currentPlaying.index! + 1]
            : MusicItem.empty);
      }

      _previousPlaying = _currentPlaying.index! != 0
          ? _queue[_currentPlaying.index! - 1]
          : MusicItem.empty;
      _previousPlayingStreamController.add(_previousPlaying);

      _nextPlaying = _currentPlaying.index! != _queue.length - 1
          ? _queue[_currentPlaying.index! + 1]
          : MusicItem.empty;
      _nextPlayingStreamController.add(_nextPlaying);
    }

    _updateMusicItemsState();
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    _loopModeSteamController.add(loopMode);
  }

  Future<void> _smoothVolumeReductionZerothPlayer({
    bool invert = false,
    Duration duration = Duration.zero,
  }) async {
    double startVolume = invert ? 0 : _zerothPlayer.volume;
    double endVolume = invert ? _zerothPlayer.volume : 0;

    double currentVolume = invert ? startVolume : startVolume - endVolume;

    int count = duration.inMilliseconds ~/ 50;
    int timeStep = duration.inMilliseconds ~/ count;
    double step = invert ? endVolume / count : currentVolume / count;

    for (int i = 0; i < count; i++) {
      invert ? currentVolume += step : currentVolume -= step;
      _zerothPlayer.setVolume(currentVolume);
      await Future.delayed(Duration(milliseconds: timeStep));
    }

    invert ? null : _zerothPlayer.pause();
    invert ? null : _zerothPlayer.seek(Duration.zero);
    _zerothPlayer.setVolume(invert ? endVolume : startVolume);
  }

  Future<void> _smoothVolumeReductionFirstPlayer({
    bool invert = false,
    Duration duration = Duration.zero,
  }) async {
    double startVolume = invert ? 0 : _firstPlayer.volume;
    double endVolume = invert ? _firstPlayer.volume : 0;

    double currentVolume = invert ? startVolume : startVolume - endVolume;

    int count = duration.inMilliseconds ~/ 50;
    int timeStep = duration.inMilliseconds ~/ count;
    double step = invert ? endVolume / count : currentVolume / count;

    for (int i = 0; i < count; i++) {
      invert ? currentVolume += step : currentVolume -= step;
      _firstPlayer.setVolume(currentVolume);
      await Future.delayed(Duration(milliseconds: timeStep));
    }

    invert ? null : _firstPlayer.pause();
    invert ? null : _firstPlayer.seek(Duration.zero);
    _firstPlayer.setVolume(invert ? endVolume : startVolume);
  }

  Future<void> _smoothVolumeReductionSecondPlayer({
    bool invert = false,
    Duration duration = Duration.zero,
  }) async {
    double startVolume = invert ? 0 : _secondPlayer.volume;
    double endVolume = invert ? _secondPlayer.volume : 0;

    double currentVolume = invert ? startVolume : startVolume - endVolume;

    int count = duration.inMilliseconds ~/ 50;
    int timeStep = duration.inMilliseconds ~/ count;
    double step = invert ? endVolume / count : currentVolume / count;

    for (int i = 0; i < count; i++) {
      invert ? currentVolume += step : currentVolume -= step;
      _secondPlayer.setVolume(currentVolume);
      await Future.delayed(Duration(milliseconds: timeStep));
    }

    invert ? null : _secondPlayer.pause();
    invert ? null : _secondPlayer.seek(Duration.zero);
    _secondPlayer.setVolume(invert ? endVolume : startVolume);
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
      await _zerothPlayer.setAudioSource(
        playlist,
        // preload: false,
      );
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
      await _firstPlayer.setAudioSource(
        playlist,
        // preload: false,
      );
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
      await _secondPlayer.setAudioSource(
        playlist,
        // preload: false,
      );
    } catch (e) {
      print("Error: $e");
    }
    return;
  }
}

enum Player { unknown, zeroth, first, second }

class MusicItemsState {
  MusicItem previousPlaying;
  MusicItem currentPlaying;
  MusicItem nextPlaying;

  MusicItemsState({
    required this.previousPlaying,
    required this.currentPlaying,
    required this.nextPlaying,
  });

  static final empty = MusicItemsState(
    previousPlaying: MusicItem.empty,
    currentPlaying: MusicItem.empty,
    nextPlaying: MusicItem.empty,
  );

  MusicItemsState copyWith({
    MusicItem? previousPlaying,
    MusicItem? currentPlaying,
    MusicItem? nextPlaying,
  }) {
    return MusicItemsState(
      previousPlaying: previousPlaying ?? this.previousPlaying,
      currentPlaying: currentPlaying ?? this.currentPlaying,
      nextPlaying: nextPlaying ?? this.nextPlaying,
    );
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
