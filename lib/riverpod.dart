import 'package:infinite_circle/constant/keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'riverpod.g.dart';

///Shares Preferences Provider
@riverpod
SharedPreferences sharedPreferences(ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use.');
}

///Highest Score Provider
@Riverpod(keepAlive: true)
class HighestScore extends _$HighestScore {
  @override
  int build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getInt(highScoreKey) ?? 0;
    listenSelf((prev, next) {
      preferences.setInt(highScoreKey, next);
    });
    return currentValue;
  }

  void setHighestScore({required int value}) async {
    state = value;
  }
}

///Score Provider
@Riverpod(keepAlive: true)
class Score extends _$Score {
  @override
  int build() => 0;

  void increment() => state++;

  void reset() => state = 0;
}

///Pause State Provider
@Riverpod(keepAlive: true)
class PauseState extends _$PauseState {
  @override
  bool build() => true;

  void show() => state = false;
  void hide() => state = true;
  void toggle() => state = !state;
}

///Retry State Provider
@Riverpod(keepAlive: true)
class AttemptCounter extends _$AttemptCounter {
  static const String _attemptCountKey = 'attempt_count';
  static const String _resetTimeKey = 'reset_time';
  static const int _maxAttempts = 3;

  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final attemptCount = prefs.getInt(_attemptCountKey) ?? 0;
    final resetTimeString = prefs.getString(_resetTimeKey);
    final resetTime =
        resetTimeString != null ? DateTime.tryParse(resetTimeString) : null;

    listenSelf((prev, next) {
      prefs.setInt(_attemptCountKey, next);
      if (next == 0) {
        prefs.setString(_resetTimeKey, DateTime.now().toIso8601String());
      }
    });

    // Reset the attempt count if the reset time is more than 1 day old
    if (resetTime != null &&
        resetTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      resetAttemptCount();
      return 0;
    }

    return attemptCount;
  }

  void incrementAttemptCount() => state++;

  void resetAttemptCount() => state = 0;

  bool hasReachedMaxAttempts() => state >= _maxAttempts;
}
