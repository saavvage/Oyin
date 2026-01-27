class UserProfileM {
  const UserProfileM({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.phone,
    required this.birthDate,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String phone;
  final DateTime? birthDate;

  String get fullName => [firstName, lastName].where((v) => v.isNotEmpty).join(' ');
}
