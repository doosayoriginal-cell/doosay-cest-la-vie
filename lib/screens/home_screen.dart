import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../data/tracks_data.dart';
import '../models/repeat_mode.dart';
import '../widgets/track_tile.dart';
import '../widgets/mini_player.dart';
import 'player_screen.dart';
import 'bio_screen.dart';
// ignore_for_file: unused_field

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = -1;
  bool _isPlaying = false;
  AppRepeatMode _repeat = AppRepeatMode.off;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state.playing);
      if (state.processingState == ProcessingState.completed) {
        if (_repeat == AppRepeatMode.one) {
          _player.seek(Duration.zero);
          _player.play();
        } else if (_currentIndex < kTracks.length - 1) {
          _playIndex(_currentIndex + 1);
        } else if (_repeat == AppRepeatMode.all) {
          _playIndex(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playIndex(int index) async {
    try {
      await _player.setAsset(kTracks[index].assetPath);
      await _player.play();
      if (mounted) setState(() => _currentIndex = index);
    } catch (_) {}
  }

  void _cycleRepeat() {
    setState(() {
      switch (_repeat) {
        case AppRepeatMode.off: _repeat = AppRepeatMode.all;
        case AppRepeatMode.all: _repeat = AppRepeatMode.one;
        case AppRepeatMode.one: _repeat = AppRepeatMode.off;
      }
    });
  }

  void _openPlayer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          currentIndex: index,
          player: _player,
          allTracks: kTracks,
          repeat: _repeat,
          onTrackChange: (i) => _playIndex(i),
          onCycleRepeat: _cycleRepeat,
          onIndexChanged: (i) { if (mounted) setState(() => _currentIndex = i); },
          onRepeatChanged: (r) { if (mounted) setState(() => _repeat = r); },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => TrackTile(
                  track: kTracks[index],
                  index: index + 1,
                  isPlaying: _currentIndex == index && _isPlaying,
                  duration: '--:--',
                  onTap: () { _playIndex(index); _openPlayer(index); },
                ),
                childCount: kTracks.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
      bottomNavigationBar: _currentIndex >= 0
          ? MiniPlayer(
              track: kTracks[_currentIndex],
              player: _player,
              isPlaying: _isPlaying,
              onTap: () => _openPlayer(_currentIndex),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset('assets/images/pochette.jpg', fit: BoxFit.cover, alignment: Alignment.topCenter),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF121212)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 48, right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BioScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('BIOGRAPHIE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kEpTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ClipOval(child: Image.asset('assets/images/pochette.jpg', width: 22, height: 22, fit: BoxFit.cover)),
                    const SizedBox(width: 8),
                    Text(kArtistName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('EP • ${kTracks.length} titres', style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 13)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _RepeatButton(mode: _repeat, onTap: _cycleRepeat),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex < 0) { _playIndex(0); _openPlayer(0); }
                        else { _isPlaying ? _player.pause() : _player.play(); }
                      },
                      child: Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(color: Color(0xFFE8C547), shape: BoxShape.circle),
                        child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.black, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Text('#', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 12)),
                      SizedBox(width: 20),
                      Expanded(child: Text('TITRE', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 11, letterSpacing: 1.5))),
                      Text('DURÉE', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 11, letterSpacing: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Color(0xFF2A2A2A), height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RepeatButton extends StatelessWidget {
  final AppRepeatMode mode;
  final VoidCallback onTap;
  const _RepeatButton({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        mode == AppRepeatMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
        color: mode != AppRepeatMode.off ? const Color(0xFFE8C547) : const Color(0xFF777777),
        size: 28,
      ),
    );
  }
}
