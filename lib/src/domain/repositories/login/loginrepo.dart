import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Loginrepo {
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String phoneNumber,
  });
}
