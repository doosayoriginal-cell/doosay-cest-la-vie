import 'package:flutter/material.dart';
import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final int index;
  final bool isPlaying;
  final String duration;
  final VoidCallback onTap;

  const TrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.isPlaying,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF1C1C1C))),
        ),
        child: Row(
          children: [
            // Numéro ou indicateur lecture
            SizedBox(
              width: 28,
              child: isPlaying
                  ? const _PlayingIndicator()
                  : Text(
                      '$index',
                      style: const TextStyle(color: Color(0xFF555555), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(width: 16),
            // Titre + artiste
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: TextStyle(
                      color: isPlaying ? const Color(0xFFE8C547) : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(track.artist, style: const TextStyle(color: Color(0xFF666666), fontSize: 13)),
                ],
              ),
            ),
            // Durée
            Text(
              duration,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _PlayingIndicator extends StatefulWidget {
  const _PlayingIndicator();

  @override
  State<_PlayingIndicator> createState() => _PlayingIndicatorState();
}

class _PlayingIndicatorState extends State<_PlayingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Bar(height: 8 + _ctrl.value * 8),
          const SizedBox(width: 2),
          _Bar(height: 4 + _ctrl.value * 12),
          const SizedBox(width: 2),
          _Bar(height: 10 + _ctrl.value * 6),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(color: const Color(0xFFE8C547), borderRadius: BorderRadius.circular(2)),
    );
  }
}
