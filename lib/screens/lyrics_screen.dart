import 'package:flutter/material.dart';
import '../models/track.dart';

class LyricsScreen extends StatelessWidget {
  final Track track;

  const LyricsScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 34, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('PAROLES', style: TextStyle(color: Color(0xFF9B9B9B), fontSize: 11, letterSpacing: 2)),
            Text(track.title,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: track.lyrics.isEmpty
          ? const Center(
              child: Text('Paroles non disponibles', style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 16)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset('assets/images/pochette.jpg', width: 40, height: 40, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(track.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(track.artist, style: const TextStyle(color: Color(0xFF9B9B9B), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Container(height: 1, color: const Color(0xFF1E1E1E), margin: const EdgeInsets.symmetric(vertical: 20)),
                  Text(
                    track.lyrics,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.9,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
