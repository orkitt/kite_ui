sealed class AppFailure {
  const AppFailure(this.message, {this.cause});

  final String message;
  final Object? cause;
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, {super.cause});
}
