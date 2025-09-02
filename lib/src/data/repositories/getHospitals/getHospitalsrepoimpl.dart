import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';

import 'package:medicare/src/domain/repositories/getHospitals/getHospitalsrepo.dart';

class Getshospitalsrepoimpl extends Getshospitalsrepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> getHospitals() async {
    final url = "${Url.baseUrl}/${Url.hospitals}";
    try {
      log(" 🔌 GET : $url");

      final response = await _dio.get(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Response Status of $url: ${response.statusCode}");

        return right({"hospitals": response.data['Kerala']});
      } else {
        log("❌ Response Status of $url: ${response.statusCode}");
        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url: ${e.message}");
      if (e.response != null) {
        log("Dio error response: ${e.response?.data}");
        return left(Failure(message: 'error: ${e.response?.data}'));
      }
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("💥 Unexpected error in $url: $e");
      return left(Failure(message: 'Unexpected error occurred in $e'));
    }
  }
}
