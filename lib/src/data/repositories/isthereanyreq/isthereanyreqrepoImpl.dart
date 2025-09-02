import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/data/models/BRModel1.dart';
import 'package:medicare/src/data/models/BRModel4.dart';
import 'package:medicare/src/domain/repositories/isthereanyreq/isthereanyreqrepo.dart';

class Isthereanyrepoimpl extends Isthereanyreqrepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> isthereAnyReq({
    required String accesstoken,
  }) async {
    final url = '${Url.baseUrl}/${Url.bloodreqres}';

    try {
      log(" 🔌 GET : $url");

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

        final responseBody = response.data as Map<String, dynamic>;

        final List<BRModel1> users = BRModel1.listFromJson(
          responseBody['accepted_users_details'],
        );

        final List<BRModel4> activeBloodReq = BRModel4.listFromJson(
          responseBody['active_blood_requests'],
        );

        return right({
          "active_blood_requests": activeBloodReq,
          "acceptedusers": users,
        });
      } else {
        log("❌ Response Status of $url: ${response.statusCode}");
        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url: ${e.message}");
      if (e.response != null) {
        log("Dio error response: ${e.response?.data}");
      }
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("💥 Unexpected error in $url: $e");
      return left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
