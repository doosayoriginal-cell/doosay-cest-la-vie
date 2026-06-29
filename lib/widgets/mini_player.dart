import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

class MiniPlayer extends StatelessWidget {
  final Track track;
  final AudioPlayer player;
  final bool isPlaying;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.track,
    required this.player,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          decoration: BoxDecoration(
            color: const Color(0xFF282828),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Pochette
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/images/pochette.jpg',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Titre + artiste
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            track.artist,
                            style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Bouton play/pause
                    StreamBuilder<PlayerState>(
                      stream: player.playerStateStream,
                      builder: (_, snapshot) {
                        final playing = snapshot.data?.playing ?? false;
                        return IconButton(
                          icon: Icon(
                            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                          onPressed: () => playing ? player.pause() : player.play(),
                        );
                      },
                    ),
                    // Bouton suivant
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 30),
                      onPressed: null, // géré depuis home
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
              // Barre de progression fine en bas
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (_, snapshot) {
                  final pos = snapshot.data ?? Duration.zero;
                  final dur = player.duration ?? Duration.zero;
                  final progress = dur.inMilliseconds > 0
                      ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                      : 0.0;
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF3A3A3A),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE8C547)),
                    minHeight: 2,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
