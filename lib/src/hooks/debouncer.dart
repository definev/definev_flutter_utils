import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class DebouncerPool {
  DebouncerPool({this.delay = const Duration(milliseconds: 500)});

  final Duration delay;
  final Map<String, Debouncer> _pool = {};

  void run(
    String key,
    VoidCallback action, {
    Duration? delay,
  }) {
    _pool[key]?.dispose();
    _pool[key] = Debouncer(delay: delay ?? this.delay)..run(action);
  }

  void dispose() {
    for (var debouncer in _pool.values) {
      debouncer.dispose();
    }
    _pool.clear();
  }
}

DebouncerPool useDebouncerPool({Duration delay = const Duration(milliseconds: 500)}) {
  return use(_DebouncePoolHook(delay));
}

class _DebouncePoolHook extends Hook<DebouncerPool> {
  const _DebouncePoolHook(this.delay);

  final Duration delay;

  @override
  HookState<DebouncerPool, Hook<DebouncerPool>> createState() => _DebouncePoolHookState();
}

class _DebouncePoolHookState extends HookState<DebouncerPool, _DebouncePoolHook> {
  late final DebouncerPool _pool = DebouncerPool(delay: hook.delay);

  @override
  DebouncerPool build(BuildContext context) {
    return _pool;
  }

  @override
  void dispose() {
    _pool.dispose();
    super.dispose();
  }
}

Debouncer useDebouncer({Duration delay = const Duration(milliseconds: 500)}) {
  return use(_DebounceHook(delay));
}

class _DebounceHook extends Hook<Debouncer> {
  const _DebounceHook(this.delay);

  final Duration delay;

  @override
  HookState<Debouncer, Hook<Debouncer>> createState() => _DebounceHookState();
}

class _DebounceHookState extends HookState<Debouncer, _DebounceHook> {
  late final Debouncer _debouncer = Debouncer(delay: hook.delay);

  @override
  Debouncer build(BuildContext context) {
    return _debouncer;
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
} 