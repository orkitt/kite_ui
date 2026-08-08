import '../repositories/settings_repository.dart';

final class GetSettingsUseCase {
  const GetSettingsUseCase({required this.repository});

  final SettingsRepository repository;
}
