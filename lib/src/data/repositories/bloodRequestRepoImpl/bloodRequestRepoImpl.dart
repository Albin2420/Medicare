import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/data/models/BRModel1.dart';

import 'package:medicare/src/domain/repositories/bloodRequestRepo/bloodRequestRepo.dart';

class BloodRequestrepoimpl extends BloodRequestRepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestBLood({
    required String accesstoken,
    required bool isCritical,
    required String reqstedDate,
    required String bloodType,
    required int noOfunits,
    required String contactNumber,
    required String patientName,
    required String hospitalName,
  }) async {
    final url = '${Url.baseUrl}/${Url.bloodRequest}';
    log("POST: $url");

    final requestData = jsonEncode({
      "required_date": reqstedDate,
      "blood_type": bloodType,
      "no_of_units": noOfunits,
      "contact_number": contactNumber,
      "patient_name": patientName,
      "hospital": hospitalName,
      "critical": isCritical,
    });

    log("📤 Sending Request Data:\n$requestData");

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
        data: requestData,
      );

      log("✅ Response Status: ${response.statusCode}");
      log("📥 Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("📦 Parsed Response Body: $response");
        final donors = BRModel1.listFromJson(response.data);
        log("donor:$donors");

        return right({"list_donors": donors});
      } else {
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
