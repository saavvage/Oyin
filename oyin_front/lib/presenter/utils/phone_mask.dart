class PhoneCountry {
  const PhoneCountry({
    required this.code,
    required this.dialCode,
    required this.name,
    required this.flag,
    required this.maxDigits,
  });

  final String code; 
  final String dialCode; 
  final String name;
  final String flag; 
  final int maxDigits;
}

const List<PhoneCountry> kPhoneCountries = [
  PhoneCountry(code: 'US', dialCode: '+1', name: 'United States', flag: '🇺🇸', maxDigits: 10),
  PhoneCountry(code: 'RU', dialCode: '+7', name: 'Russia', flag: '🇷🇺', maxDigits: 10),
  PhoneCountry(code: 'KZ', dialCode: '+7', name: 'Kazakhstan', flag: '🇰🇿', maxDigits: 10),
  PhoneCountry(code: 'KG', dialCode: '+996', name: 'Kyrgyzstan', flag: '🇰🇬', maxDigits: 9),
  PhoneCountry(code: 'BY', dialCode: '+375', name: 'Belarus', flag: '🇧🇾', maxDigits: 9),
  PhoneCountry(code: 'AM', dialCode: '+374', name: 'Armenia', flag: '🇦🇲', maxDigits: 8),
  PhoneCountry(code: 'GE', dialCode: '+995', name: 'Georgia', flag: '🇬🇪', maxDigits: 9),
  PhoneCountry(code: 'AZ', dialCode: '+994', name: 'Azerbaijan', flag: '🇦🇿', maxDigits: 9),
  PhoneCountry(code: 'UZ', dialCode: '+998', name: 'Uzbekistan', flag: '🇺🇿', maxDigits: 9),
];

PhoneCountry countryByDial(String dial) =>
    kPhoneCountries.firstWhere((c) => c.dialCode == dial, orElse: () => kPhoneCountries.first);

String formatPhoneDigits(String digits) {
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    buf.write(digits[i]);
    final pos = i + 1;
    if (pos % 3 == 0 && pos != digits.length) buf.write(' ');
  }
  return buf.toString();
}
