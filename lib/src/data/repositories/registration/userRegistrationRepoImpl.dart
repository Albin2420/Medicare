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
    required String dob,
    required String fcmtoKen,
    required String district,
  }) async {
    final url = '${Url.baseUrl}/${Url.users}';

    try {
      log("🔌 POST: $url");

      final response = await _dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'first_name': frstName,
          'last_name': secondName,
          'mobile': phoneNumber,
          'birth_date': dob,
          'fcm_token': "abcdef",
          'district': district,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Response Status of $url: ${response.statusCode}");

        final responseBody = response.data as Map<String, dynamic>;

        return right({
          "access_token": responseBody["access_token"],
          "userId": responseBody['user_id'],
        });
      } else {
        log("❌ Response Status of $url: ${response.statusCode}");
        return Left(Failure(message: "statuscode:${response.statusCode}"));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url: ${e.message}");
      if (e.response != null) {
        log("❌ Dio error response : ${e.response?.data}");
        return left(Failure(message: "${e.response}"));
      }
      return Left(Failure(message: "error in :$e"));
    } catch (e) {
      log("💥 Unexpected error in $url : $e");
      return Left(Failure(message: "Unexpected error in :$e"));
    }
  }
}
