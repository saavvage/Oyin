mixin TimeMixin {
  static String get currentDateTimeIso => DateTime.now().toIso8601String();

  DateTime toLocalTime(DateTime dateTime) => dateTime.toLocal();

  String formatDateTimeHHMM(DateTime dateTime) {
    final local = toLocalTime(dateTime);
    return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  String formatTimeTo_ddMMyyyy(DateTime dateTime) {
    final local = toLocalTime(dateTime);
    return '${_twoDigits(local.day)} ${_monthName(local.month)} ${local.year}';
  }

  String formatTimeToMMddyyyy(DateTime dateTime) {
    final local = toLocalTime(dateTime);
    return '${_twoDigits(local.month)}/${_twoDigits(local.day)}/${local.year}';
  }

  String formatDateToHuman(DateTime dateTime) {
    final local = toLocalTime(dateTime);
    return '${local.day} ${_monthName(local.month)} '
        '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  String formatTimeToDateOrString(
    DateTime dateTime, {
    DateTime? now,
  }) {
    final local = toLocalTime(dateTime);
    final reference = toLocalTime(now ?? DateTime.now());

    final startOfToday = DateTime(reference.year, reference.month, reference.day);
    final startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    if (local.isAfter(startOfToday)) {
      return 'Сегодня';
    } else if (local.isAfter(startOfYesterday)) {
      return 'Вчера';
    } else if (local.year == reference.year) {
      return '${_twoDigits(local.day)} ${_monthName(local.month)}';
    } else {
      return '${_twoDigits(local.day)} ${_monthName(local.month)} ${local.year}';
    }
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _monthName(int month) {
    final index = month - 1;
    if (index < 0 || index >= _monthNamesRu.length) return '';
    return _monthNamesRu[index];
  }
}

const List<String> _monthNamesRu = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];
