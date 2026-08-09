import 'package:meta/meta.dart';

import '../errors/app_failure.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
/// Represents the outcome of an operation: either a [Success] containing [T]
/// or a [Failure] containing an [AppFailure].
@immutable
sealed class Result<T> {
  const Result();

  /// Creates a [Success] instance with the given [value].
  const factory Result.success(T value) = Success<T>;

  /// Creates a [Failure] instance with the given [failure].
  const factory Result.failure(AppFailure failure) = Failure<T>;

  /// Returns `true` if this instance is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this instance is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the underlying value if [Success], otherwise returns `null`.
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  /// Returns the underlying [AppFailure] if [Failure], otherwise returns `null`.
  AppFailure? get failureOrNull => switch (this) {
    Success() => null,
    Failure(:final failure) => failure,
  };

  /// Executes [onSuccess] if the result is [Success], or [onFailure] if it is [Failure].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return switch (this) {
      Success(:final value) => onSuccess(value),
      Failure(:final failure) => onFailure(failure),
    };
  }

  /// Transforms the success value using [transform] while preserving any failure.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(:final value) => Result<R>.success(transform(value)),
      Failure(:final failure) => Result<R>.failure(failure),
    };
  }
}

/// Indicates a successful operation containing [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Result.success($value)';
}

/// Indicates a failed operation containing an [AppFailure].
final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Result.failure($failure)';
}
