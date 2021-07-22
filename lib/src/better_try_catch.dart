Result<R> runCatching<R>(R f()) {
  try {
    return Result.success(f());
  } catch (e) {
    return Result.failure(e);
  }
}

class Result<T> {
  dynamic value;

  Result(this.value);

  bool get isSuccess => value! is Failure;

  bool get isFailure => value is Failure;

  T? getOrNull() {
    if (isFailure)
      return null;
    else
      return value as T;
  }

  Object? exceptionOrNull() {
    if (isFailure)
      return value.exception;
    else
      return null;
  }

  @override
  String toString() {
    if (value.isFailute)
      return value.toString();
    else
      return "Success($value)";
  }

  static Result<T> success<T>(T value) => Result(value);

  static Result<T> failure<T>(Object exception) => Result(Failure(exception));
}

class Failure {
  Object exception;

  Failure(this.exception);

  @override
  String toString() => "Failure($exception)";
}

extension ResultExtensions<T> on Result<T> {
  throwOnFailure() {
    if (isFailure) throw value.exception;
  }

  Result<T> onSuccess(action(T value)) {
    if (isSuccess) {
      action(value);
    }
    return this;
  }

  T getOrThrow() {
    throwOnFailure();
    return value;
  }

  T getOrElse<R extends T>(T onFailure(Exception exception)) {
    Exception? exception = exceptionOrNull() as Exception?;
    if (exception == null)
      return value;
    else
      return onFailure(exception);
  }

  T getOrDefault<R extends T>(T defaultValue) {
    if (isFailure) return defaultValue;
    return value;
  }

  T fold<R>(T onSuccess(R value), T onFailure(Exception exception)) {
    Exception? exception = exceptionOrNull() as Exception?;
    if (exception == null)
      return onSuccess(value);
    else
      return onFailure(exception);
  }

  Result<T> map<R>(T transform(R value)) {
    if (isSuccess)
      return Result.success(transform(value));
    else
      return Result(value);
  }

  Result<T> mapCatching<R>(T transform(R value)) {
    if (isSuccess)
      return runCatching(() {
        return transform(value);
      });
    else
      return Result(value);
  }

  Result<T> recover<R extends T>(T transform(Exception exception)) {
    Exception? exception = exceptionOrNull() as Exception?;
    if (exception == null)
      return this;
    else
      return Result.success(transform(exception));
  }

  Result<T> recoverCatching<R extends T>(T transform(Exception exception)) {
    Exception? exception = exceptionOrNull() as Exception?;
    if (exception == null)
      return this;
    else
      return runCatching(() {
        return transform(exception);
      });
  }

  Result<T> onFailure(action(Exception exception)) {
    Exception? exception = exceptionOrNull() as Exception?;
    if (exception != null) action(exception);
    return this;
  }
}
