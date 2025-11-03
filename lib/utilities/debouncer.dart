import 'dart:async';
import 'dart:ui';

class Debouncer {
  /// Debounces API calls.
  Debouncer({required this.delay});
  final Duration delay;
  Timer? _debounceTimer;

  /// Returns true if action should be executed now (after debounce delay)
  bool run(VoidCallback action) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(delay, () {
      action();
    });

    return true;
  }
}
