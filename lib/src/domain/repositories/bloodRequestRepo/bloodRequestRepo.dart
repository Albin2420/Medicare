import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class BloodRequestRepo {
  Future<Either<Failure, Map<String, dynamic>>> requestBLood({
    required String accesstoken,
    required bool isCritical,
    required String reqstedDate,
    required String bloodType,
    required int noOfunits,
    required String contactNumber,
    required String patientName,
    required String hospitalName,
    required String district,
  });
}
