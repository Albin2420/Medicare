import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Getshospitalsrepo {
  Future<Either<Failure, Map<String, dynamic>>> getHospitals();
}
