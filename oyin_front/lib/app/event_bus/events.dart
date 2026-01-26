import '../../domain/export.dart';

abstract class AppEvent {}

class AppEventMatch extends AppEvent {
  AppEventMatch(this.pair);
  final PairCompactM pair;
}

class AppEventMatchMessage extends AppEvent {
  AppEventMatchMessage(this.pair);
  final PairCompactM pair;
}

class AppEventDeleteMatch extends AppEvent {
  AppEventDeleteMatch(this.pairId);
  final int pairId;
}

class AppEventRemoveLike extends AppEvent {
  AppEventRemoveLike(this.pairId);
  final int pairId;
}

class AppEventUpdateBalance extends AppEvent {
  AppEventUpdateBalance(this.newBalance);
  final int newBalance;
}
