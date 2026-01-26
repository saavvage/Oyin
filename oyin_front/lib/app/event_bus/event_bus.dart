import 'dart:async';

import '../../domain/export.dart';
import 'events.dart';

class EventBus {
  EventBus._();
  static final EventBus _instance = EventBus._();
  factory EventBus() => _instance;

  final StreamController<AppEvent> _controller = StreamController<AppEvent>.broadcast();

  Stream<T> on<T extends AppEvent>() => _controller.stream.where((event) => event is T).cast<T>();

  void fire(AppEvent event) => _controller.add(event);

  void dispose() => _controller.close();
}
