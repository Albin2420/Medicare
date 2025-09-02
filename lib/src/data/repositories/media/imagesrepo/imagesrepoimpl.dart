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
    final url = '${Url.baseUrl}/${Url.image}';
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

      log("🔌 POST: $url");

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        log("✅ Response Status of $url: ${response.statusCode}");
        return Right(response.data);
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
      return Left(Failure(message: "Unexpected error in :$e"));
    }
  }
}
