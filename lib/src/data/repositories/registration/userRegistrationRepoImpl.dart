// import 'dart:convert';
// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;
// import 'package:medicare/src/core/network/failure.dart';
// import 'package:medicare/src/core/url.dart';
// import 'package:medicare/src/domain/repositories/registration/userRegistrationRepo.dart';

// class UserRegistrationRepoImpl extends UserRegistrationRepo {
//   @override
//   Future<Either<Failure, Map<String, dynamic>>> saveStudent({
//     required String frstName,
//     required String secondName,
//     required String phoneNumber,
//   }) async {
//     final url = Uri.parse('${Url.baseUrl}/${Url.users}');
//     log("POST: $url");

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'first_name': frstName,
//           'last_name': secondName,
//           'mobile': phoneNumber,
//         }),
//       );

//       log("Response Status: ${response.statusCode}");
//       log("Response Body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
//         log("response body:$responseBody");
//         return right({"access_token": responseBody["access_token"]});
//       } else {
//         return left(Failure(message: 'Server error: ${response.statusCode}'));
//       }
//     } catch (e) {
//       log("HTTP error: $e");
//       return left(Failure(message: 'Network error occurred'));
//     }
//   }
// }

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/registration/userRegistrationRepo.dart';

class UserRegistrationRepoImpl extends UserRegistrationRepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> saveStudent({
    required String frstName,
    required String secondName,
    required String phoneNumber,
  }) async {
    final url = '${Url.baseUrl}/${Url.users}';
    log("POST: $url");

    try {
      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'first_name': frstName,
          'last_name': secondName,
          'mobile': phoneNumber,
        },
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.data as Map<String, dynamic>;
        log("response body: $responseBody");
        return right({
          "access_token": responseBody["access_token"],
          "userId": responseBody['user_id'],
        });
      } else {
        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("Dio error: ${e.message}");
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("Unexpected error: $e");
      return left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
