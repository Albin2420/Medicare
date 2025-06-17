import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';

abstract class Audiosrepo {
  Future<Either<Failure, Map<String, dynamic>>> saveAudio({
    required List<File> audios,
    required String accessToken,
  });
}
