class Track {
  final int id;
  final String title;
  final String artist;
  final String assetPath;
  final String lyrics;
  final Duration duration;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.lyrics,
    this.duration = Duration.zero,
  });
}
