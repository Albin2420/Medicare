import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Isthereanyreqrepo {
  Future<Either<Failure, Map<String, dynamic>>> isthereAnyReq({
    required String accesstoken,
  });
}
