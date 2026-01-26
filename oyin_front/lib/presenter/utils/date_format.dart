class DateFormatter {
  static String get currentDateTimeIso => DateTime.now().toIso8601String();

  static DateTime _toLocal(DateTime dateTime) => dateTime.toLocal();

  static String formatDateSmart(
    DateTime dateTime, {
    DateTime? now,
  }) {
    final local = _toLocal(dateTime);
    final reference = _toLocal(now ?? DateTime.now());
    final startOfToday = DateTime(reference.year, reference.month, reference.day);
    final startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    if (local.isAfter(startOfToday)) return 'Сегодня';
    if (local.isAfter(startOfYesterday)) return 'Вчера';
    if (local.year == reference.year) {
      return '${_two(local.day)} ${_monthName(local.month)}';
    }
    return '${_two(local.day)} ${_monthName(local.month)} ${local.year}';
  }

  static String getLastSeenStatus(
    DateTime lastOnlineUtc, {
    DateTime? now,
    LastSeenLabels labels = LastSeenLabels.ru,
  }) {
    final reference = now ?? DateTime.now().toUtc();
    final diff = reference.difference(lastOnlineUtc);

    if (diff.inMinutes <= 30) return labels.online;
    if (diff.inMinutes <= 120) return labels.recently;

    final localSeen = lastOnlineUtc.toLocal();
    final localNow = _toLocal(reference);

    final hhmm = '${_two(localSeen.hour)}:${_two(localSeen.minute)}';
    final yesterday = DateTime(localNow.year, localNow.month, localNow.day - 1);
    final twoDaysAgo = yesterday.subtract(const Duration(days: 1));

    if (_isSameDay(localSeen, localNow)) return labels.todayAt(hhmm);
    if (_isSameDay(localSeen, yesterday)) return labels.yesterdayAt(hhmm);
    if (_isSameDay(localSeen, twoDaysAgo)) return labels.beforeYesterdayAt(hhmm);

    if (localNow.difference(localSeen).inDays < 7) {
      final weekday = _weekdayName(localSeen.weekday, labels);
      return labels.weekdayAt(weekday, hhmm);
    }

    return labels.forLongTime;
  }

  static bool _isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _monthName(int month) {
    final index = month - 1;
    if (index < 0 || index >= _monthsRu.length) return '';
    return _monthsRu[index];
  }

  static String _weekdayName(int weekday, LastSeenLabels labels) {
    final index = weekday - 1;
    if (index < 0 || index >= labels.weekdays.length) return '';
    return labels.weekdays[index];
  }
}

class LastSeenLabels {
  const LastSeenLabels({
    required this.online,
    required this.recently,
    required this.todayAt,
    required this.yesterdayAt,
    required this.beforeYesterdayAt,
    required this.weekdayAt,
    required this.forLongTime,
    required this.weekdays,
  });

  final String online;
  final String recently;
  final String Function(String time) todayAt;
  final String Function(String time) yesterdayAt;
  final String Function(String time) beforeYesterdayAt;
  final String Function(String weekday, String time) weekdayAt;
  final String forLongTime;
  final List<String> weekdays;

  static const ru = LastSeenLabels(
    online: 'Онлайн',
    recently: 'Недавно',
    todayAt: _todayAtRu,
    yesterdayAt: _yesterdayAtRu,
    beforeYesterdayAt: _beforeYesterdayAtRu,
    weekdayAt: _weekdayAtRu,
    forLongTime: 'Был(а) давно',
    weekdays: [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ],
  );
}

String _todayAtRu(String time) => 'Сегодня в $time';
String _yesterdayAtRu(String time) => 'Вчера в $time';
String _beforeYesterdayAtRu(String time) => 'Позавчера в $time';
String _weekdayAtRu(String weekday, String time) => '$weekday, $time';

const List<String> _monthsRu = [
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
