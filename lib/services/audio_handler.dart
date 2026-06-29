import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../data/tracks_data.dart';
import '../models/repeat_mode.dart';

class DoosayAudioHandler extends BaseAudioHandler {
  final AudioPlayer player = AudioPlayer();
  int currentIndex = -1;
  AppRepeatMode repeatMode = AppRepeatMode.off;
  void Function(int)? onIndexChanged;

  DoosayAudioHandler() {
    player.playerStateStream.listen(_broadcastState);
    player.positionStream.listen((pos) {
      playbackState.add(playbackState.value.copyWith(updatePosition: pos));
    });
    player.durationStream.listen((dur) {
      final item = mediaItem.value;
      if (item != null && dur != null) {
        mediaItem.add(item.copyWith(duration: dur));
      }
    });
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onTrackCompleted();
      }
    });
  }

  void _onTrackCompleted() {
    if (repeatMode == AppRepeatMode.one) {
      player.seek(Duration.zero);
      player.play();
    } else if (currentIndex < kTracks.length - 1) {
      playTrack(currentIndex + 1);
    } else if (repeatMode == AppRepeatMode.all) {
      playTrack(0);
    }
  }

  Future<void> playTrack(int index) async {
    currentIndex = index;
    onIndexChanged?.call(index);
    final track = kTracks[index];
    mediaItem.add(MediaItem(
      id: track.assetPath,
      title: track.title,
      artist: track.artist,
      album: "C'est la vie",
    ));
    await player.setAsset(track.assetPath);
    await player.play();
  }

  void _broadcastState(PlayerState state) {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        state.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {MediaAction.seek},
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[state.processingState]!,
      playing: state.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
    ));
  }

  @override Future<void> play() => player.play();
  @override Future<void> pause() => player.pause();
  @override Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (currentIndex < kTracks.length - 1) await playTrack(currentIndex + 1);
  }

  @override
  Future<void> skipToPrevious() async {
    if (currentIndex > 0) await playTrack(currentIndex - 1);
  }

  @override
  Future<void> stop() async {
    await player.stop();
    await super.stop();
  }
}
