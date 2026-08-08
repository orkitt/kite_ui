import '../repositories/home_repository.dart';

final class GetHomeUseCase {
  const GetHomeUseCase({required this.repository});

  final HomeRepository repository;
}
