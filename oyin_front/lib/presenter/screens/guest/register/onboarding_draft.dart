class RegistrationOnboardingDraft {
  const RegistrationOnboardingDraft({
    required this.phone,
    required this.name,
    required this.email,
    required this.city,
    required this.birthDate,
    required this.selectedSports,
    required this.level,
    required this.experienceYears,
    required this.skills,
  });

  final String phone;
  final String name;
  final String email;
  final String city;
  final DateTime? birthDate;
  final List<String> selectedSports;
  final String? level;
  final int? experienceYears;
  final List<String> skills;

  RegistrationOnboardingDraft copyWith({
    String? phone,
    String? name,
    String? email,
    String? city,
    DateTime? birthDate,
    List<String>? selectedSports,
    String? level,
    int? experienceYears,
    List<String>? skills,
  }) {
    return RegistrationOnboardingDraft(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
      birthDate: birthDate ?? this.birthDate,
      selectedSports: selectedSports ?? this.selectedSports,
      level: level ?? this.level,
      experienceYears: experienceYears ?? this.experienceYears,
      skills: skills ?? this.skills,
    );
  }
}
