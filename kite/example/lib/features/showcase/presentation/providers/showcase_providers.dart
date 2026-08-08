import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/showcase_repository_impl.dart';
import '../../data/sources/showcase_remote_source.dart';
import '../../domain/repositories/showcase_repository.dart';
import '../../domain/usecases/get_showcase_use_case.dart';

final showcaseRemoteSourceProvider = Provider<ShowcaseRemoteSource>((ref) {
  return const ShowcaseRemoteSourceImpl();
});

final showcaseRepositoryProvider = Provider<ShowcaseRepository>((ref) {
  return ShowcaseRepositoryImpl(
    remoteSource: ref.watch(showcaseRemoteSourceProvider),
  );
});

final getShowcaseUseCaseProvider = Provider<GetShowcaseUseCase>((ref) {
  return GetShowcaseUseCase(repository: ref.watch(showcaseRepositoryProvider));
});
