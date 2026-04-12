class UserProfileM {
  const UserProfileM({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.phone,
    required this.birthDate,
    this.selectedSports = const [],
    this.level = '',
    this.experienceYears = 0,
    this.skills = const [],
  });

  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String phone;
  final DateTime? birthDate;
  final List<String> selectedSports;
  final String level;
  final int experienceYears;
  final List<String> skills;

  String get fullName =>
      [firstName, lastName].where((v) => v.isNotEmpty).join(' ');
}
