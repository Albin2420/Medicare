import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/location/locationrepo.dart';

class Locationrepoimpl extends Locationrepo {
  final Dio _dio = Dio();
  @override
  Future<Either<Failure, Map<String, dynamic>>> location({
    required double longitude,
    required double latitude,
    required String landmark,
    required String accesstoken,
  }) async {
    final url = '${Url.baseUrl}/${Url.loc}';
    log("POST: $url");

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
        data: {
          "latitude": latitude,
          "longitude": longitude,
          "landmark": landmark,
        },
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.data as Map<String, dynamic>;

        return right({
          "Name": responseBody["first_name"],
          "mobileNo": responseBody["mobile"],
          "ambulance_number": responseBody["ambulance_number"],
          "id": responseBody["media_id"],
          "eta_minutes": responseBody["eta_minutes"].toString(),
          "latitude": responseBody["driver_latitude"],
          "longitude": responseBody["driver_longitude"],
          "rideId": responseBody["ride_id"],
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
