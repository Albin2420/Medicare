import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/domain/repositories/media/audiosrepo/audiosrepo.dart';

class Audiorepoimpl extends Audiosrepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> saveAudio({required List<File> audios, required String accessToken}) {
    // TODO: implement saveAudio
    throw UnimplementedError();
  }
  
}