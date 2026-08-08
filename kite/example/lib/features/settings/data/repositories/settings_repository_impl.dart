import '../../domain/repositories/settings_repository.dart';
import '../sources/settings_remote_source.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.remoteSource});

  final SettingsRemoteSource remoteSource;
}
