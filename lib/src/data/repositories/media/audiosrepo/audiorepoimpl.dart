import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/media/audiosrepo/audiosrepo.dart';

class Audiorepoimpl extends Audiosrepo {
  @override
  Future<Either<Failure, Map<String, dynamic>>> saveAudio({
    required List<FileSystemEntity> audios,
    required String accessToken,
    required String mediaId,
    required int rideId,
  }) async {
    try {
      final dio = Dio();

      try {
        // Convert files to MultipartFile
        final List<MultipartFile> audioFiles = [];

        for (var audio in audios) {
          if (audio is File) {
            final fileName = audio.path.split('/').last;
            audioFiles.add(
              await MultipartFile.fromFile(audio.path, filename: fileName),
            );
          }
        }

        final formData = FormData.fromMap({
          'audios': audioFiles,
          'media_id': mediaId,
          'ride_id': rideId,
        });

        log("rideId :$rideId");

        final response = await dio.post(
          "${Url.baseUrl}/${Url.audio}",
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200) {
          log("response.data :$response");
          return Right({});
        } else {
          log("failed in statuscode:${response.statusCode}");
          return Left(Failure(message: "statuscode:${response.statusCode}"));
        }
      } catch (e) {
        log("error in saveAudio():$e");
        return Left(Failure(message: "error in :$e"));
      }
    } catch (e) {
      log("error(main) in saveAudio():$e");
      return Left(Failure(message: "error in :$e"));
    }
  }
}
