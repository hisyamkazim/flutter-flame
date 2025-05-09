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
@riverpod
class PauseState extends _$PauseState {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
