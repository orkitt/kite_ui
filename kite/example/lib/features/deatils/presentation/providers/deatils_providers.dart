import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/deatils_repository_impl.dart';
import '../../data/sources/deatils_remote_source.dart';
import '../../domain/repositories/deatils_repository.dart';
import '../../domain/usecases/get_deatils_use_case.dart';

final deatilsRemoteSourceProvider = Provider<DeatilsRemoteSource>((ref) {
  return const DeatilsRemoteSourceImpl();
});

final deatilsRepositoryProvider = Provider<DeatilsRepository>((ref) {
  return DeatilsRepositoryImpl(
    remoteSource: ref.watch(deatilsRemoteSourceProvider),
  );
});

final getDeatilsUseCaseProvider = Provider<GetDeatilsUseCase>((ref) {
  return GetDeatilsUseCase(repository: ref.watch(deatilsRepositoryProvider));
});
