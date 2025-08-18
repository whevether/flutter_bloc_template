class AppError implements Exception {
  final int code;
  final String message;
  AppError(
    this.message, {
    this.code = -1,
  });

  @override
  String toString() {
    return message;
  }
}
