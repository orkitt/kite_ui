import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository_impl.dart';
import '../../data/sources/settings_remote_source.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings_use_case.dart';

final settingsRemoteSourceProvider = Provider<SettingsRemoteSource>((ref) {
  return const SettingsRemoteSourceImpl();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    remoteSource: ref.watch(settingsRemoteSourceProvider),
  );
});

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  return GetSettingsUseCase(repository: ref.watch(settingsRepositoryProvider));
});
