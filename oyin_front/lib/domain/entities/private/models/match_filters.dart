class MatchFilters {
  const MatchFilters({
    required this.distanceKmMin,
    required this.distanceKmMax,
    required this.ageMin,
    required this.ageMax,
    this.sport,
  });

  final double distanceKmMin;
  final double distanceKmMax;
  final int ageMin;
  final int ageMax;
  final String? sport;

  MatchFilters copyWith({
    double? distanceKmMin,
    double? distanceKmMax,
    int? ageMin,
    int? ageMax,
    String? sport,
  }) {
    return MatchFilters(
      distanceKmMin: distanceKmMin ?? this.distanceKmMin,
      distanceKmMax: distanceKmMax ?? this.distanceKmMax,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      sport: sport ?? this.sport,
    );
  }

  static const defaults = MatchFilters(
    distanceKmMin: 0,
    distanceKmMax: 500,
    ageMin: 14,
    ageMax: 100,
  );
}
