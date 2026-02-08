import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/export.dart';

class SessionStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setAccessToken(String token) async {
    await init();
    await _prefs!.setString(_Keys.accessToken, token);
  }

  static Future<String?> getAccessToken() async {
    await init();
    return _prefs!.getString(_Keys.accessToken);
  }

  static Future<void> setMatchFilters(MatchFilters filters) async {
    await init();
    await _prefs!.setDouble(_Keys.matchDistanceMin, filters.distanceKmMin);
    await _prefs!.setDouble(_Keys.matchDistanceMax, filters.distanceKmMax);
    await _prefs!.setInt(_Keys.matchAgeMin, filters.ageMin);
    await _prefs!.setInt(_Keys.matchAgeMax, filters.ageMax);
  }

  static Future<MatchFilters> getMatchFilters() async {
    await init();
    final distanceMin = _prefs!.getDouble(_Keys.matchDistanceMin) ?? MatchFilters.defaults.distanceKmMin;
    final distanceMax = _prefs!.getDouble(_Keys.matchDistanceMax) ?? MatchFilters.defaults.distanceKmMax;
    final ageMin = _prefs!.getInt(_Keys.matchAgeMin) ?? MatchFilters.defaults.ageMin;
    final ageMax = _prefs!.getInt(_Keys.matchAgeMax) ?? MatchFilters.defaults.ageMax;
    return MatchFilters(
      distanceKmMin: distanceMin,
      distanceKmMax: distanceMax,
      ageMin: ageMin,
      ageMax: ageMax,
    );
  }
}

class _Keys {
  static const String accessToken = 'access_token';
  static const String matchDistanceMin = 'match_distance_min';
  static const String matchDistanceMax = 'match_distance_max';
  static const String matchAgeMin = 'match_age_min';
  static const String matchAgeMax = 'match_age_max';
}
