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
    final url = "${Url.baseUrl}/${Url.audio}";
    final dio = Dio();
    try {
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

      log("🔌 POST: $url");

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        log("✅ Response Status of $url: ${response.statusCode}");
        return Right({});
      } else {
        log("❌ Response Status of $url: ${response.statusCode}");
        return Left(Failure(message: "statuscode:${response.statusCode}"));
      }
    } on DioException catch (e) {
      log("❌ Dio error in $url: ${e.message}");
      if (e.response != null) {
        log("❌ Dio error response : ${e.response?.data}");
        return left(Failure(message: "${e.response}"));
      }
      return Left(Failure(message: "error in :$e"));
    } catch (e) {
      log("💥 Unexpected error in $url : $e");
      return Left(Failure(message: "error in :$e"));
    }
  }
}
