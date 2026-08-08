import '../repositories/blog_repository.dart';

final class GetBlogUseCase {
  const GetBlogUseCase({required this.repository});

  final BlogRepository repository;
}
