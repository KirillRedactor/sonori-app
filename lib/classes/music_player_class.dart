import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_app/classes/audio_handler_class.dart';

class MusicPlayerClass {
  final getIt = GetIt.I;

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
        isPlaying ? _firstPlayer.play() : null;
      } else if (_secondPlayerCurrentMusicItem == event) {
        isPlaying ? _secondPlayer.play() : null;
      }
    });

    nextPlayingStream.listen((event) {
      if (_firstPlayerCurrentMusicItem != event &&
          _secondPlayerCurrentMusicItem != event) {
        _updateMediaItemSecondPlayer(event);
      }
    });
  }

  Future<void> updateQueue(
    List<MusicItem> newQueue, {
    int fromItem = 0,
    bool playQueue = true,
    bool isShuffle = false,
  }) async {
    _queue = newQueue;
    _musicItemList = newQueue;

    if (fromItem > 0) {
      _previousPlayingStreamController.add(_musicItemList[fromItem - 1]);
    }
    _currentPlayingStreamController.add(_musicItemList[fromItem]);
    if (fromItem != _musicItemList.length - 1) {
      _nextPlayingStreamController.add(_musicItemList[fromItem + 1]);
    }

    _playingStreamController.add(playQueue);
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

class MusicItem {
  double id;
  MediaItem mediaItem;

  MusicItem({
    required this.id,
    required this.mediaItem,
  });

  static final empty = MusicItem(
    id: 0,
    mediaItem: const MediaItem(
      id: "",
      title: "Unknown track title",
    ),
  );
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
