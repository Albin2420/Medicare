import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Endmyreqrepo {
  Future<Either<Failure, Map<String, dynamic>>> endMyReq({
    required String accesstoken,
    required int reqId,
  });
}
