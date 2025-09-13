class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException(this.message, this.prefix, this.url);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message!, "Bad Request", url!);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message!, "Unable to process", url!);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message!, "Api not responding", url!);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message, String? url])
      : super(message!, "Unauthorised", url!);
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message, String? url])
      : super(message!, "Invalid Input", url!);
}