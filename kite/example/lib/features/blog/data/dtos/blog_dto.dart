import '../../domain/entities/blog_entity.dart';

final class BlogDto {
  const BlogDto();

  BlogEntity toDomain() {
    return const BlogEntity();
  }
}
