import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/check-ride/check_rideRepo.dart';

class CheckRiderepoimpl extends CheckRiderepo {
  final Dio _dio = Dio();
  @override
  Future<Either<Failure, Map<String, dynamic>>> checkRidestatus({
    required String accesstoken,
    required int rideId,
  }) async {
    final url = '${Url.baseUrl}/${Url.userCheckonGoingRide}';
    log("POST: $url  rideId:$rideId");

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
        data: jsonEncode({"ride_id": rideId}),
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Response Status of $url : ${response.statusCode}");
        final responseBody = response.data as Map<String, dynamic>;

        if (responseBody['ongoing'] == true) {
          return right({
            "ongoing": responseBody['ongoing'],
            "latitude": responseBody['driver_location']['latitude'],
            "longitude": responseBody['driver_location']['longitude'],
          });
        } else {
          return right({"ongoing": responseBody['ongoing']});
        }
      } else {
        log("❌ Response Status of $url : ${response.statusCode}");
        return left(Failure(message: 'Server error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log("❌ Dio error: ${e.message}");
      return left(Failure(message: 'Network error: ${e.message}'));
    } catch (e) {
      log("💥 Unexpected error: $e");
      return left(Failure(message: 'Unexpected error occurred'));
    }
  }
}
