import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class CheckRiderepo {
  Future<Either<Failure, Map<String, dynamic>>> checkRidestatus({
    required String accesstoken,
    required int rideId,
  });
}
