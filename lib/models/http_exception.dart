class HttpExeption implements Exception {
  final String message;

  HttpExeption(this.message);
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
