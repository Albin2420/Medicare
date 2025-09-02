import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Userbloodinforepo {
  Future<Either<Failure, Map<String, dynamic>>> updateBlood({
    required String accesstoken,
    required String bloodType,
    required bool iswillingtoDonate,
  });
}
