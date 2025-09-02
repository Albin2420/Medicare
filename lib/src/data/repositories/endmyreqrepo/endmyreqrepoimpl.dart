import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/endmyreq/endmyreqrepo.dart';

class Endmyreqrepoimpl extends Endmyreqrepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> endMyReq({
    required String accesstoken,
    required int reqId,
  }) async {
    final url = '${Url.baseUrl}/${Url.bloodRequest}/$reqId/${Url.endmyReq}';

    try {
      log(" 🔌 POST : $url");

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Response Status of $url :${response.statusCode}");

        return right({});
      } else {
        log("❌ Response Status of $url :${response.statusCode}");
        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url: ${e.message}");
      if (e.response != null) {
        log("🥶 Dio error response: ${e.response?.data}");
      }
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("💥 Unexpected error in $url: $e");
      return left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
