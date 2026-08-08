import '../../domain/repositories/blog_repository.dart';
import '../sources/blog_remote_source.dart';

final class BlogRepositoryImpl implements BlogRepository {
  const BlogRepositoryImpl({required this.remoteSource});

  final BlogRemoteSource remoteSource;
}
