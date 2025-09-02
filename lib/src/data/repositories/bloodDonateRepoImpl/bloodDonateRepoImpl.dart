import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/data/models/BRModel2.dart';
import 'package:medicare/src/data/models/BRModel3.dart';

import 'package:medicare/src/domain/repositories/bloodDonateRepo/bloodDonateRepo.dart';

class BloodDonateRepoImpl extends BloodDonateRepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestBLooddonarList({
    required String accesstoken,
  }) async {
    final url = '${Url.baseUrl}/${Url.bloodDonors}';

    try {
      log(" 🔌 GET: $url");

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Response Status of $url: ${response.statusCode}");

        final criticalRequests = BRModel2.fromJsonList(
          response.data['critical_requests'],
        );

        final userGroup = BRModel2.fromJsonList(
          response.data['matching_requests'],
        );

        final general = BRModel3.fromJsonList(
          response.data['blood_type_summary'],
        );

        return right({
          "user_blood_type": response.data['user_blood_type'],
          "criticalRequest": criticalRequests,
          "matching_requests": userGroup,
          "general": general,
        });
      } else {
        log("❌ Response Status of $url: ${response.statusCode}");

        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url : ${e.message}");
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("💥 Unexpected error in $url : $e");
      return left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
