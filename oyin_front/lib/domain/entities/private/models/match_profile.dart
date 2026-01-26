class MatchProfile {
  const MatchProfile({
    required this.name,
    required this.age,
    required this.distanceKm,
    required this.rating,
    required this.sport,
    required this.level,
    required this.tags,
    required this.imageUrl,
    this.verified = false,
  });

  final String name;
  final int age;
  final double distanceKm;
  final double rating;
  final String sport;
  final String level;
  final List<String> tags;
  final String imageUrl;
  final bool verified;
}
