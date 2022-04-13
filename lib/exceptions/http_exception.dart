class HttpException implements Exception {
  final String mgs;

  const HttpException(this.mgs);

  @override
  String toString() {
    return mgs;
  }
}
