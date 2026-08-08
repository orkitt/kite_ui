import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_repository_impl.dart';
import '../../data/sources/home_remote_source.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_use_case.dart';

final homeRemoteSourceProvider = Provider<HomeRemoteSource>((ref) {
  return const HomeRemoteSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(remoteSource: ref.watch(homeRemoteSourceProvider));
});

final getHomeUseCaseProvider = Provider<GetHomeUseCase>((ref) {
  return GetHomeUseCase(repository: ref.watch(homeRepositoryProvider));
});
