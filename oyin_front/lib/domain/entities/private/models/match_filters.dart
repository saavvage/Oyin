class MatchFilters {
  const MatchFilters({
    required this.distanceKmMin,
    required this.distanceKmMax,
    required this.ageMin,
    required this.ageMax,
  });

  final double distanceKmMin;
  final double distanceKmMax;
  final int ageMin;
  final int ageMax;

  MatchFilters copyWith({
    double? distanceKmMin,
    double? distanceKmMax,
    int? ageMin,
    int? ageMax,
  }) {
    return MatchFilters(
      distanceKmMin: distanceKmMin ?? this.distanceKmMin,
      distanceKmMax: distanceKmMax ?? this.distanceKmMax,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
    );
  }

  static const defaults = MatchFilters(
    distanceKmMin: 0,
    distanceKmMax: 500,
    ageMin: 14,
    ageMax: 100,
  );
}
