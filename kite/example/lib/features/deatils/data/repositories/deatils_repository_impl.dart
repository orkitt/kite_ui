import '../../domain/repositories/deatils_repository.dart';
import '../sources/deatils_remote_source.dart';

final class DeatilsRepositoryImpl implements DeatilsRepository {
  const DeatilsRepositoryImpl({required this.remoteSource});

  final DeatilsRemoteSource remoteSource;
}
