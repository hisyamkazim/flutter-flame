// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'558e5cab629f53962f0e1544ef75c4a35b0f6738';

///Shares Preferences Provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = AutoDisposeProviderRef<SharedPreferences>;
String _$highestScoreHash() => r'f264cbd96db30901f5669aef1e9d8a9971bda4ac';

///Highest Score Provider
///
/// Copied from [HighestScore].
@ProviderFor(HighestScore)
final highestScoreProvider = NotifierProvider<HighestScore, int>.internal(
  HighestScore.new,
  name: r'highestScoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$highestScoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HighestScore = Notifier<int>;
String _$scoreHash() => r'04a0e81d822cb38ec373c9789c8b279d0dd35d98';

///Score Provider
///
/// Copied from [Score].
@ProviderFor(Score)
final scoreProvider = NotifierProvider<Score, int>.internal(
  Score.new,
  name: r'scoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Score = Notifier<int>;
String _$scoreHistoryHash() => r'bad65d681c27b60393e15d08f63d37bca732bf4d';

/// See also [ScoreHistory].
@ProviderFor(ScoreHistory)
final scoreHistoryProvider =
    AsyncNotifierProvider<ScoreHistory, List<Scores>>.internal(
  ScoreHistory.new,
  name: r'scoreHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scoreHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScoreHistory = AsyncNotifier<List<Scores>>;
String _$pauseStateHash() => r'aaf435339375db97203a0f3ebe6a4c411d8ca6c5';

///Pause State Provider
///
/// Copied from [PauseState].
@ProviderFor(PauseState)
final pauseStateProvider = NotifierProvider<PauseState, bool>.internal(
  PauseState.new,
  name: r'pauseStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pauseStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PauseState = Notifier<bool>;
String _$attemptCounterHash() => r'e527418165d423a8cd76ba7f2e3444f97047783e';

///Retry State Provider
///
/// Copied from [AttemptCounter].
@ProviderFor(AttemptCounter)
final attemptCounterProvider = NotifierProvider<AttemptCounter, int>.internal(
  AttemptCounter.new,
  name: r'attemptCounterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$attemptCounterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AttemptCounter = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
