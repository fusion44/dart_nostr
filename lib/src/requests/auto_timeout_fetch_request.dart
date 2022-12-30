import 'dart:async';

import '../repositories/relay_repository.dart';

const String timeoutErrorDescription =
    'Request timed out on one or more relays';

class AutoTimeoutFetchRequest<T> {
  final RelayRepository repo;
  final Duration timeoutDuration;

  bool _isClosed = false;

  AutoTimeoutFetchRequest(
    this.repo, {
    this.timeoutDuration = const Duration(seconds: 5),
  }) {
    _startTimeout();
  }

  bool get isClosed => _isClosed;

  void onTimeout() async {}

  Future<void> close() async {
    _isClosed = true;
  }

  void _startTimeout() async {
    await Future.delayed(timeoutDuration);
    if (!_isClosed) onTimeout();
  }
}
