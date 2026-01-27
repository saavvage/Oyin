class Validators {
  const Validators._();

  static bool isPasswordValid(String value) => value.trim().length >= 6;

  static bool isPhoneComplete({
    required String digitsOnly,
    required int requiredLength,
  }) =>
      digitsOnly.length == requiredLength;
}
