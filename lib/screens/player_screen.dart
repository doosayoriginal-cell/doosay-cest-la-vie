import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../models/track.dart';
import '../models/repeat_mode.dart';
import '../data/tracks_data.dart';
import 'lyrics_screen.dart';

class PlayerScreen extends StatefulWidget {
  final int currentIndex;
  final AudioPlayer player;
  final List<Track> allTracks;
  final AppRepeatMode repeat;
  final Future<void> Function(int) onTrackChange;
  final VoidCallback onCycleRepeat;
  final void Function(int) onIndexChanged;
  final void Function(AppRepeatMode) onRepeatChanged;

  const PlayerScreen({
    super.key,
    required this.currentIndex,
    required this.player,
    required this.allTracks,
    required this.repeat,
    required this.onTrackChange,
    required this.onCycleRepeat,
    required this.onIndexChanged,
    required this.onRepeatChanged,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late int _index;
  late AppRepeatMode _repeat;
  final Set<int> _likedTracks = {};

  @override
  void initState() {
    super.initState();
    _index = widget.currentIndex;
    _repeat = widget.repeat;
    widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_repeat == AppRepeatMode.one) {
          widget.player.seek(Duration.zero);
          widget.player.play();
        } else if (_index < kTracks.length - 1) {
          _changeTrack(_index + 1);
        } else if (_repeat == AppRepeatMode.all) {
          _changeTrack(0);
        }
      }
    });
  }

  void _changeTrack(int index) {
    widget.onTrackChange(index);
    widget.onIndexChanged(index);
    setState(() => _index = index);
  }

  void _cycleRepeat() {
    final AppRepeatMode next;
    switch (_repeat) {
      case AppRepeatMode.off: next = AppRepeatMode.all;
      case AppRepeatMode.all: next = AppRepeatMode.one;
      case AppRepeatMode.one: next = AppRepeatMode.off;
    }
    widget.onCycleRepeat();
    widget.onRepeatChanged(next);
    setState(() => _repeat = next);
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Track get _current => kTracks[_index];

  @override
  Widget build(BuildContext context) {
    final active = _repeat != AppRepeatMode.off;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 34, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('EN LECTURE', style: TextStyle(color: Color(0xFF9B9B9B), fontSize: 11, letterSpacing: 2)),
            Text(_current.title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => Share.share('🎵 Écoute "${_current.title}" de ${_current.artist} sur l\'EP C\'est la vie par DOOSAY !\n\n👉 Android : https://play.google.com/store/apps/details?id=com.doosay.cestlavie'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/pochette.jpg', fit: BoxFit.cover, alignment: Alignment.topCenter),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_current.title,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(_current.artist, style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 14)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    if (_likedTracks.contains(_index)) {
                      _likedTracks.remove(_index);
                    } else {
                      _likedTracks.add(_index);
                    }
                  }),
                  child: Icon(
                    _likedTracks.contains(_index) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _likedTracks.contains(_index) ? const Color(0xFFE8C547) : Colors.grey,
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<Duration>(
              stream: widget.player.positionStream,
              builder: (context, snapshot) {
                final pos = snapshot.data ?? Duration.zero;
                final dur = widget.player.duration ?? Duration.zero;
                final progress = dur.inMilliseconds > 0
                    ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                    : 0.0;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: const Color(0xFF3A3A3A),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white24,
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (v) {
                          if (dur.inMilliseconds > 0) {
                            widget.player.seek(Duration(milliseconds: (v * dur.inMilliseconds).round()));
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_format(pos), style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
                          Text(_format(dur), style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _cycleRepeat,
                  child: Icon(
                    _repeat == AppRepeatMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                    color: active ? const Color(0xFFE8C547) : const Color(0xFF6B6B6B),
                    size: 26,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, size: 44),
                  color: _index == 0 ? const Color(0xFF3A3A3A) : Colors.white,
                  onPressed: _index > 0 ? () => _changeTrack(_index - 1) : null,
                ),
                StreamBuilder<PlayerState>(
                  stream: widget.player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return GestureDetector(
                      onTap: () => playing ? widget.player.pause() : widget.player.play(),
                      child: Container(
                        width: 68, height: 68,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.black, size: 38),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, size: 44),
                  color: _index == kTracks.length - 1 ? const Color(0xFF3A3A3A) : Colors.white,
                  onPressed: _index < kTracks.length - 1 ? () => _changeTrack(_index + 1) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.ios_share_rounded, size: 24),
                  color: const Color(0xFF6B6B6B),
                  onPressed: () => Share.share('🎵 Écoute "${_current.title}" de ${_current.artist} sur l\'EP C\'est la vie par DOOSAY !\n\n👉 Android : https://play.google.com/store/apps/details?id=com.doosay.cestlavie'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LyricsScreen(track: _current))),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lyrics_rounded, color: Color(0xFFE8C547), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _current.lyrics.isEmpty ? 'Paroles non disponibles' : 'Voir les paroles',
                      style: TextStyle(
                        color: _current.lyrics.isEmpty ? const Color(0xFF6B6B6B) : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
