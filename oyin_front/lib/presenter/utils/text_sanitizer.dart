import 'package:flutter/widgets.dart';

class TextSanitizer {
  static final RegExp removeNonDigits = RegExp(r'\D');
  static final RegExp collapseSpaces = RegExp(r'\s+');
  static final RegExp splitToSlash = RegExp(r'[^/]+$');
  static final RegExp splitToSpace = RegExp(r'[\s\n]');

  static void removeSpacesFromController(
    TextEditingController controller,
    String text,
  ) {
    final newValue = text.replaceAll(collapseSpaces, '');
    if (text != newValue) {
      controller.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );
    }
  }

  static String onlyDigits(String text) => text.replaceAll(removeNonDigits, '');

  static String collapseWhitespace(String text) =>
      text.replaceAll(collapseSpaces, ' ').trim();

  static String trimLines(String text) =>
      text.split('\n').map((line) => line.trim()).join('\n').trim();

  static String limitLength(String text, int maxLength) =>
      text.length <= maxLength ? text : text.substring(0, maxLength);

  static PhoneFormatResult formatPhone(String input) {
    final digits = _normalizeLeading(onlyDigits(input));
    final country = PhoneCountry.detect(digits);
    final formatted = _applyMask(digits, country.mask);
    return PhoneFormatResult(
      country: country,
      sanitizedDigits: digits,
      formatted: formatted,
    );
  }

  static String _normalizeLeading(String digits) {
    if (digits.startsWith('8')) {
      return '7${digits.substring(1)}';
    }
    return digits;
  }

  static String _applyMask(String digits, String mask) {
    final buffer = StringBuffer();
    var digitIndex = 0;
    for (final char in mask.split('')) {
      if (char == '#') {
        if (digitIndex < digits.length) {
          buffer.write(digits[digitIndex]);
          digitIndex++;
        }
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }
}

class PhoneFormatResult {
  const PhoneFormatResult({
    required this.country,
    required this.sanitizedDigits,
    required this.formatted,
  });

  final PhoneCountry country;
  final String sanitizedDigits;
  final String formatted;
}

class PhoneCountry {
  const PhoneCountry({
    required this.code,
    required this.name,
    required this.mask,
    required this.prefixes,
  });

  final String code; 
  final String name;
  final String mask; 
  final List<String> prefixes; 

  static PhoneCountry detect(String digits) {
    if (digits.isEmpty) return _defaultRu;

    
    PhoneCountry? bestMatch;
    for (final country in _countries) {
      for (final prefix in country.prefixes) {
        if (digits.startsWith(prefix)) {
          if (bestMatch == null || prefix.length > bestMatch!.prefixes.first.length) {
            bestMatch = country;
          }
        }
      }
    }

    if (bestMatch == _defaultRu && digits.startsWith('77')) {
      return _kazakhstan;
    }

    return bestMatch ?? _defaultRu;
  }
}

const PhoneCountry _defaultRu = PhoneCountry(
  code: 'RU',
  name: 'Russia',
  mask: '+7 (###) ###-##-##',
  prefixes: ['7'],
);

const PhoneCountry _kazakhstan = PhoneCountry(
  code: 'KZ',
  name: 'Kazakhstan',
  mask: '+7 (###) ###-##-##',
  prefixes: ['77'],
);

const List<PhoneCountry> _countries = [
  PhoneCountry(
    code: 'KG',
    name: 'Kyrgyzstan',
    mask: '+996 (###) ### ###',
    prefixes: ['996'],
  ),
  PhoneCountry(
    code: 'BY',
    name: 'Belarus',
    mask: '+375 (##) ###-##-##',
    prefixes: ['375'],
  ),
  PhoneCountry(
    code: 'AM',
    name: 'Armenia',
    mask: '+374 (##) ##-##-##',
    prefixes: ['374'],
  ),
  PhoneCountry(
    code: 'GE',
    name: 'Georgia',
    mask: '+995 (###) ##-##-##',
    prefixes: ['995'],
  ),
  PhoneCountry(
    code: 'AZ',
    name: 'Azerbaijan',
    mask: '+994 (##) ###-##-##',
    prefixes: ['994'],
  ),
  PhoneCountry(
    code: 'UZ',
    name: 'Uzbekistan',
    mask: '+998 (##) ###-##-##',
    prefixes: ['998'],
  ),
  _kazakhstan,
  _defaultRu,
];
