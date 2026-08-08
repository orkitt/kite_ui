import '../../domain/repositories/home_repository.dart';
import '../sources/home_remote_source.dart';

final class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required this.remoteSource});

  final HomeRemoteSource remoteSource;
}
