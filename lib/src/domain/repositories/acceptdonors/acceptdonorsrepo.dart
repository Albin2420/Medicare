import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Acceptdonorsrepo {
  Future<Either<Failure, Map<String, dynamic>>> acceptReq({
    required String accesstoken,
    required int id,
  });
}
