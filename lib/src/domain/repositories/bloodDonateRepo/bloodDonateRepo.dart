import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class BloodDonateRepo {
  Future<Either<Failure, Map<String, dynamic>>> requestBLooddonarList({
    required String accesstoken,
  });
}
