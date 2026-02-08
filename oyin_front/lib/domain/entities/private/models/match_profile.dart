class MatchProfile {
  const MatchProfile({
    required this.id,
    required this.name,
    required this.age,
    this.city,
    required this.distanceKm,
    required this.rating,
    required this.sport,
    this.sports = const [],
    required this.level,
    required this.tags,
    required this.imageUrl,
    this.verified = false,
  });

  final String id;
  final String name;
  final int age;
  final String? city;
  final double distanceKm;
  final double rating;
  final String sport;
  final List<String> sports;
  final String level;
  final List<String> tags;
  final String imageUrl;
  final bool verified;

  factory MatchProfile.fromMap(Map<String, dynamic> map) {
    final sports = <String>[];
    final rawSports = map['sports'];
    if (rawSports is List) {
      for (final item in rawSports) {
        if (item is String && item.isNotEmpty) {
          sports.add(item);
        }
      }
    }
    final sport = (map['sport'] ?? '').toString();
    if (sports.isEmpty && sport.isNotEmpty) {
      sports.add(sport);
    }

    return MatchProfile(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      age: (map['age'] is num) ? (map['age'] as num).toInt() : 0,
      city: map['city']?.toString(),
      distanceKm: (map['distanceKm'] is num) ? (map['distanceKm'] as num).toDouble() : 0,
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0,
      sport: sport,
      sports: sports,
      level: (map['level'] ?? '').toString(),
      tags: (map['tags'] is List)
          ? (map['tags'] as List).whereType<String>().toList()
          : const [],
      imageUrl: (map['imageUrl'] ?? '').toString(),
      verified: map['verified'] == true,
    );
  }
}
