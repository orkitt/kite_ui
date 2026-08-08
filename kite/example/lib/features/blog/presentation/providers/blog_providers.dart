import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/blog_repository_impl.dart';
import '../../data/sources/blog_remote_source.dart';
import '../../domain/repositories/blog_repository.dart';
import '../../domain/usecases/get_blog_use_case.dart';

final blogRemoteSourceProvider = Provider<BlogRemoteSource>((ref) {
  return const BlogRemoteSourceImpl();
});

final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  return BlogRepositoryImpl(remoteSource: ref.watch(blogRemoteSourceProvider));
});

final getBlogUseCaseProvider = Provider<GetBlogUseCase>((ref) {
  return GetBlogUseCase(repository: ref.watch(blogRepositoryProvider));
});
