import 'package:dio/dio.dart';

class BooksException implements Exception {
  BooksException.fromDioError(DioError dioError) {
    if (dioError.type == DioErrorType.cancel) {
      message = "Request to API server was cancelled";
    } else if (dioError.type == DioErrorType.connectTimeout) {
      message = "Connection timeout with API server";
    } else if (dioError.type == DioErrorType.receiveTimeout) {
      message = "Receive timeout in connection with API server";
    } else if (dioError.type == DioErrorType.response) {
      message = _handleError(dioError.response!.statusCode);
    } else if (dioError.type == DioErrorType.sendTimeout) {
      message = "Send timeout in connection with API server";
    } else {
      message = "Something went wrong";
    }
  }

  String? message;

  String _handleError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return 'The requested resource was not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message!;
}
