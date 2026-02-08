class NumberFormatter {
  String formatWithSpaces(
    num value, {
    int decimals = 0,
    String thousandSeparator = ' ',
    String decimalSeparator = ',',
  }) {
    final isNegative = value < 0;
    final absValue = value.abs();

    final fixed = absValue.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts.first;
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final formattedInt = intPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}$thousandSeparator',
    );

    final buffer = StringBuffer();
    if (isNegative) buffer.write('-');
    buffer.write(formattedInt);
    if (decimals > 0) {
      buffer.write(decimalSeparator);
      buffer.write(decimalPart);
    }
    return buffer.toString();
  }

  String formatShort(num value) {
    final isNegative = value < 0;
    final absValue = value.abs();

    String withSuffix(double number, String suffix) {
      final shortened = number >= 10 ? number.toStringAsFixed(0) : number.toStringAsFixed(1);
      return '${isNegative ? '-' : ''}$shortened$suffix';
    }

    if (absValue >= 1e9) return withSuffix(absValue / 1e9, 'B');
    if (absValue >= 1e6) return withSuffix(absValue / 1e6, 'M');
    if (absValue >= 1e3) return withSuffix(absValue / 1e3, 'K');

    return '${isNegative ? '-' : ''}${absValue.toStringAsFixed(0)}';
  }
}
