// import 'package:dio/dio.dart';
//
// String getErrorMessage(DioException error) {
//   switch (error.type) {
//     case DioExceptionType.connectionTimeout:
//       return 'Connection to the server timed out. Please check your internet connection and try again.';
//     case DioExceptionType.sendTimeout:
//       return 'Request sending timed out. Please try again.';
//     case DioExceptionType.receiveTimeout:
//       return 'Receiving data from the server timed out. Please try again later.';
//     case DioExceptionType.badCertificate:
//       return 'Failed to verify the security certificate. Please ensure a secure connection.';
//     case DioExceptionType.badResponse:
//       final statusCode = error.response?.statusCode;
//       if (error == null) {
//         return 'An unknown error occurred.';}
//       if (statusCode != null) {
//         switch (statusCode) {
//           case 400:
//             return 'Bad request. Please check the input data.';
//           case 401:
//             return 'Unauthorized. Please log in and try again.';
//           case 403:
//             return 'Access forbidden. You do not have the necessary permissions.';
//           case 404:
//             return 'The requested resource was not found.';
//           case 500:
//             return 'Internal server error. Please try again later.';
//           case 503:
//             return 'Service is currently unavailable. Please try again later.';
//           default:
//             return 'An unexpected error occurred (Status code: $statusCode). Please try again later.';
//         }
//       }
//       return 'An unexpected error occurred while receiving the server response.';
//     case DioExceptionType.cancel:
//       return 'The request was canceled.';
//     case DioExceptionType.connectionError:
//       return 'Failed to connect to the server. Please check your internet connection.';
//     case DioExceptionType.unknown:
//     default:
//       return 'An unknown error occurred. Please try again later.';
//   }
// }


import 'package:equatable/equatable.dart';

/// Domain-layer failures — no Supabase/Exception imports here.
/// Presentation maps these to user-friendly messages.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Network/server is unreachable
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

/// Supabase returned an error response
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Wrong credentials, expired session, etc.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// User not found in DB (different from auth failure)
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'العنصر غير موجود']);
}

/// Input didn't pass validation
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// File upload/download problems
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Catch-all
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير متوقع']);
}