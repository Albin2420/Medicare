import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:medicare/src/core/network/failure.dart';
import 'package:medicare/src/core/url.dart';
import 'package:medicare/src/domain/repositories/media/imagesrepo/imagesrepo.dart';

class Imagesrepoimpl extends Imagesrepo {
  final Dio _dio = Dio();

  @override
  Future<Either<Failure, Map<String, dynamic>>> saveImage({
    required List<File> images,
    required String accessToken,
    required int rideId,
    required String mediaId,
  }) async {
    try {
      final multipartImages = [];
      for (final image in images) {
        final multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
        multipartImages.add(multipartFile);
      }

      final formData = FormData.fromMap({
        'images': multipartImages,
        'media_id': mediaId,
        'ride_id': rideId,
      });

      log("img:${multipartImages[0].filename} rideId :$rideId");

      final response = await _dio.post(
        '${Url.baseUrl}/${Url.image}',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        log("ohk bie");
        return Right(response.data);
      } else {
        return Left(
          Failure(
            message: 'Server responded with status code ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      log("error:$e");
      return Left(Failure(message: e.toString()));
    }
  }
}
