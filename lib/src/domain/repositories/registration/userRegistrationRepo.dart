import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class UserRegistrationRepo {
  Future<Either<Failure, Map<String, dynamic>>> saveStudent({
    required String frstName,
    required String secondName,
    required String phoneNumber,
    required String dob,
    required String fcmtoKen,
    required String district,
  });
}
