import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Imagesrepo {
  Future<Either<Failure, Map<String, dynamic>>> saveImage({
    required List<File> images,
    required String accessToken,
    required int rideId,
    required String mediaId,
  });
}
