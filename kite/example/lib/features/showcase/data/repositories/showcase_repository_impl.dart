import '../../domain/repositories/showcase_repository.dart';
import '../sources/showcase_remote_source.dart';

final class ShowcaseRepositoryImpl implements ShowcaseRepository {
  const ShowcaseRepositoryImpl({required this.remoteSource});

  final ShowcaseRemoteSource remoteSource;
}
