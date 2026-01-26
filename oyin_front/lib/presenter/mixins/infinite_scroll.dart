import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

mixin InfiniteScrollMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  VoidCallback? _teardownInfiniteScroll;

  void setupInfiniteScroll({
    required VoidCallback onLoadMore,
    double startThreshold = 200,
    double endThreshold = 70,
    bool Function()? canLoadMore,
  }) {
    _teardownInfiniteScroll?.call();

    void listener() {
      if (!scrollController.hasClients) return;
      final position = scrollController.position;

      if (position.pixels < startThreshold) return;
      if (position.userScrollDirection == ScrollDirection.forward) return;

      if (position.pixels >= position.maxScrollExtent - endThreshold) {
        if (canLoadMore?.call() ?? true) {
          onLoadMore();
        }
      }
    }

    scrollController.addListener(listener);
    _teardownInfiniteScroll = () => scrollController.removeListener(listener);
  }

  @override
  void dispose() {
    _teardownInfiniteScroll?.call();
    scrollController.dispose();
    super.dispose();
  }
}
