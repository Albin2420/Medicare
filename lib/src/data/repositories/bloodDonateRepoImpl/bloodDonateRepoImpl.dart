import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/data/models/BRModel2.dart';
import 'package:medicare/src/domain/repositories/bloodDonateRepo/bloodDonateRepo.dart';

class BloodDonateRepoImpl extends BloodDonateRepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestBLooddonarList({
    required String accesstoken,
  }) async {
    final url = '${Url.baseUrl}/${Url.bloodDonors}';
    log("GET: $url");

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accesstoken',
          },
        ),
      );

      log("✅ Response Status of ${Url.bloodDonors}: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Convert API response to a list of BRModel2
        final requests = (response.data as List<dynamic>)
            .map((item) => BRModel2.fromJson(item))
            .toList();

        log("totalReq:${requests.length}");

        // Group donors by blood type
        final aPositive = requests.where((r) => r.bloodType == "A+").toList();
        final bPositive = requests.where((r) => r.bloodType == "B+").toList();
        final abPositive = requests.where((r) => r.bloodType == "AB+").toList();
        final oPositive = requests.where((r) => r.bloodType == "O+").toList();
        final aNegative = requests.where((r) => r.bloodType == "A-").toList();
        final bNegative = requests.where((r) => r.bloodType == "B-").toList();
        final abNegative = requests.where((r) => r.bloodType == "AB-").toList();
        final oNegative = requests.where((r) => r.bloodType == "O-").toList();

        return right({
          "A+": aPositive,
          "B+": bPositive,
          "AB+": abPositive,
          "O+": oPositive,
          "A-": aNegative,
          "B-": bNegative,
          "AB-": abNegative,
          "O-": oNegative,
          "requests": requests,
        });
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
