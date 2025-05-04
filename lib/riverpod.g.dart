// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPrefsHash() => r'af0b48181804adbf944f6315474b662017cd3fb4';

/// See also [sharedPrefs].
@ProviderFor(sharedPrefs)
final sharedPrefsProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  sharedPrefs,
  name: r'sharedPrefsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sharedPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPrefsRef = AutoDisposeFutureProviderRef<SharedPreferences>;
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
String _$sharedUtilityHash() => r'48a1611d661074e3bb90fb9a3becab6a91f6dcb0';

/// See also [SharedUtility].
@ProviderFor(SharedUtility)
final sharedUtilityProvider = NotifierProvider<SharedUtility, void>.internal(
  SharedUtility.new,
  name: r'sharedUtilityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedUtilityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SharedUtility = Notifier<void>;
String _$highestScoreHash() => r'8040835ac82429fa9c585275427ec275f55c7ee1';

///Highest Score Provider
///
/// Copied from [HighestScore].
@ProviderFor(HighestScore)
final highestScoreProvider =
    AutoDisposeNotifierProvider<HighestScore, int>.internal(
  HighestScore.new,
  name: r'highestScoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$highestScoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HighestScore = AutoDisposeNotifier<int>;
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
String _$pauseStateHash() => r'18c695063aa056214ba88fa6a9de25bab5300fbc';

///Pause State Provider
///
/// Copied from [PauseState].
@ProviderFor(PauseState)
final pauseStateProvider =
    AutoDisposeNotifierProvider<PauseState, bool>.internal(
  PauseState.new,
  name: r'pauseStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pauseStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PauseState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
