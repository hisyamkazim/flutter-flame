import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'riverpod.g.dart';

@riverpod
Future<SharedPreferences> sharedPrefs(_) async =>
    await SharedPreferences.getInstance();

///Shares Preferences Provider
@riverpod
SharedPreferences sharedPreferences(ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use.');
}

@Riverpod(keepAlive: true)
class SharedUtility extends _$SharedUtility {
  late final SharedPreferences sharedPreferences;

  @override
  void build() {
    sharedPreferences = ref.watch(sharedPreferencesProvider);
  }

  int getHighestScore() {
    return sharedPreferences.getInt('highest_score') ?? 0;
  }

  void setHighestScore({required int value}) {
    sharedPreferences.setInt('highest_score', value);
  }
}

///Highest Score Provider
@riverpod
class HighestScore extends _$HighestScore {
  late final SharedUtility sharedUtility;

  @override
  int build() {
    sharedUtility = ref.watch(sharedUtilityProvider.notifier);
    return sharedUtility.getHighestScore();
  }

  void newHighScore(int value) {
    sharedUtility.setHighestScore(value: value);
    state = sharedUtility.getHighestScore();
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
  bool build() {
    return true;
  }

  void toggle() => state = !state;
}
