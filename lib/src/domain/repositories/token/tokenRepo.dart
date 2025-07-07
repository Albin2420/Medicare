import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Tokenrepo {
  Future<Either<Failure, Map<String, dynamic>>> checkToken({
    required String accesstoken,
  });
}
