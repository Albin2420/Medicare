import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Audiosrepo {
  Future<Either<Failure, Map<String, dynamic>>> saveAudio({
    required List<FileSystemEntity> audios,
    required String accessToken,
    required String mediaId,
    required int rideId,
  });
}
