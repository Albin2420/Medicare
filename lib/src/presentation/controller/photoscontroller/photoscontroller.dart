import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:medicare/src/data/repositories/media/imagesrepo/imagesrepoimpl.dart';
import 'package:medicare/src/domain/repositories/media/imagesrepo/imagesrepo.dart';
import 'package:medicare/src/presentation/controller/homecontroller/Homecontroller.dart';
import 'package:medicare/src/presentation/screens/photos/photos.dart';

class PhotosController extends GetxController {
  final ctrl = Get.find<Homecontroller>();
  Imagesrepo imagesrepo = Imagesrepoimpl();
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;

  final RxBool _isCameraView = false.obs;
  final RxList<File> _selectedImages = <File>[].obs;
  final RxBool _isCameraInitializing = false.obs;
  final ImagePicker _picker = ImagePicker();

  RxInt currentCameraIndex = 0.obs;
  RxBool isflipping = RxBool(false);

  // Performance tracking
  final RxBool _isCapturing = false.obs;
  final RxDouble _zoomLevel = 1.0.obs;
  final RxBool _flashEnabled = false.obs;

  // Camera capabilities
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  // Getters
  bool get isCameraView => _isCameraView.value;
  List<File> get selectedImages => _selectedImages;
  CameraController? get controller => _controller;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  bool get isCameraInitializing => _isCameraInitializing.value;
  bool get isCapturing => _isCapturing.value;
  double get zoomLevel => _zoomLevel.value;
  bool get flashEnabled => _flashEnabled.value;
  double get minZoom => _minZoom;
  double get maxZoom => _maxZoom;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  @override
  void onClose() {
    _controller?.dispose();
    super.onClose();
  }

  /// Initialize camera with optimal settings
  Future<void> _initializeCamera() async {
    try {
      _isCameraInitializing.value = true;
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        // Find the best rear camera first, then front camera
        int bestCameraIndex = _findBestCamera();
        currentCameraIndex.value = bestCameraIndex;

        await _setupCamera(cameras![bestCameraIndex]);
        log("Initialized camera: ${cameras![currentCameraIndex.value].name}");
      } else {
        log("No cameras found.");
        Fluttertoast.showToast(msg: "Camera not found");
      }
    } catch (e) {
      log('Error initializing camera: $e');
      Fluttertoast.showToast(msg: "Camera initialization failed: $e");
    } finally {
      _isCameraInitializing.value = false;
    }
  }

  /// Find the best available camera (prefer higher resolution rear camera)
  int _findBestCamera() {
    if (cameras == null || cameras!.isEmpty) return 0;

    // Try to find the best rear camera first
    int bestRearIndex = -1;
    int bestFrontIndex = -1;

    for (int i = 0; i < cameras!.length; i++) {
      final camera = cameras![i];
      if (camera.lensDirection == CameraLensDirection.back) {
        if (bestRearIndex == -1) {
          bestRearIndex = i;
        }
      } else if (camera.lensDirection == CameraLensDirection.front) {
        if (bestFrontIndex == -1) {
          bestFrontIndex = i;
        }
      }
    }

    // Prefer rear camera, fallback to front, then any available
    return bestRearIndex != -1
        ? bestRearIndex
        : (bestFrontIndex != -1 ? bestFrontIndex : 0);
  }

  /// Setup camera with optimal configuration
  Future<void> _setupCamera(CameraDescription camera) async {
    // Dispose existing controller
    await _controller?.dispose();

    // Create new controller with optimized settings
    _controller = CameraController(
      camera,
      ResolutionPreset.max, // Use maximum available resolution
      enableAudio: false, // Disable audio for photos
      imageFormatGroup: ImageFormatGroup.jpeg, // Optimize for JPEG
    );

    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    // Configure camera settings for optimal performance
    await _configureCameraSettings();
  }

  /// Configure camera settings for optimal quality and performance
  Future<void> _configureCameraSettings() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Set zoom capabilities
      _minZoom = await _controller!.getMinZoomLevel();
      _maxZoom = await _controller!.getMaxZoomLevel();
      _zoomLevel.value = _minZoom;

      // Set optimal exposure and focus modes
      await _controller!.setExposureMode(ExposureMode.auto);
      await _controller!.setFocusMode(FocusMode.auto);

      // Set flash mode
      await _controller!.setFlashMode(
        _flashEnabled.value ? FlashMode.auto : FlashMode.off,
      );

      log("Camera settings configured - Zoom: ${_minZoom}x - ${_maxZoom}x");
    } catch (e) {
      log('Error configuring camera settings: $e');
    }
  }

  /// Switch camera with improved performance
  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length <= 1) {
      log("Only one camera available or no cameras found.");
      return;
    }

    try {
      isflipping.value = true;
      _isCameraInitializing.value = true;

      // Find next available camera
      final nextIndex = _findNextCamera();
      currentCameraIndex.value = nextIndex;

      // Setup new camera
      await _setupCamera(cameras![nextIndex]);

      log("Switched to camera: ${cameras![currentCameraIndex.value].name}");
    } catch (e) {
      log('Error switching camera: $e');
      await _handleCameraSwitchError();
    } finally {
      isflipping.value = false;
      _isCameraInitializing.value = false;
    }
  }

  /// Find next available camera in sequence
  int _findNextCamera() {
    if (cameras == null || cameras!.isEmpty) return 0;

    int nextIndex = (currentCameraIndex.value + 1) % cameras!.length;

    // Skip any unavailable cameras
    int attempts = 0;
    while (attempts < cameras!.length) {
      try {
        return nextIndex;
      } catch (e) {
        nextIndex = (nextIndex + 1) % cameras!.length;
        attempts++;
      }
    }

    return currentCameraIndex.value; // Fallback to current camera
  }

  /// Handle camera switch errors
  Future<void> _handleCameraSwitchError() async {
    try {
      // Try to reinitialize the original camera
      await _setupCamera(cameras![0]);
      currentCameraIndex.value = 0;
    } catch (reinitError) {
      log('Failed to reinitialize camera: $reinitError');
      Fluttertoast.showToast(msg: "Camera switch failed");
    }
  }

  Future<void> takePicture() async {
    if (_isCameraInitializing.value || _isCapturing.value) {
      return;
    }

    try {
      _isCapturing.value = true;

      if (_controller != null && _initializeControllerFuture != null) {
        await _initializeControllerFuture;

        // Ensure proper focus before capture
        await _ensureFocus();

        // Capture image
        final image = await _controller!.takePicture();

        File capturedFile = File(image.path);

        // Flip the image if it's from the front camera
        if (currentCameraIndex.value == 1) {
          EasyLoading.show();
          final bytes = await capturedFile.readAsBytes();
          final decodedImage = img.decodeImage(bytes);

          if (decodedImage != null) {
            final flippedImage = img.flipHorizontal(decodedImage);
            final flippedBytes = img.encodeJpg(flippedImage);

            // Overwrite the original file
            capturedFile = await capturedFile.writeAsBytes(flippedBytes);
          }
          EasyLoading.dismiss();
        }

        // Add flipped (or original) image to selected list
        _selectedImages.add(capturedFile);
        _isCameraView.value = false;

        log('Photo saved to ${capturedFile.path}');
      }
    } catch (e) {
      log("Error taking picture: $e");
      Fluttertoast.showToast(msg: "Failed to capture photo: $e");
    } finally {
      _isCapturing.value = false;
    }
  }

  /// Ensure proper focus before capturing
  Future<void> _ensureFocus() async {
    if (_controller == null) return;

    try {
      // Trigger auto-focus
      await _controller!.setFocusMode(FocusMode.auto);

      // Small delay to allow focus to stabilize
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      log('Focus adjustment failed: $e');
    }
  }

  /// Provide capture feedback
  void _provideFeedback() {
    // You can add haptic feedback here if needed
    // HapticFeedback.lightImpact();
  }

  /// Pick images with optimized settings
  Future<void> pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 3840, // 4K width for high quality
        maxHeight: 2160, // 4K height
        imageQuality: 95, // Higher quality (was 85)
        requestFullMetadata: false, // Optimize performance
      );

      if (images.isNotEmpty) {
        // Process images in batches to avoid memory issues
        await _processSelectedImages(images);
        _isCameraView.value = false;
        log("Selected ${images.length} high-quality images from gallery");
      }
    } catch (e) {
      log("Error picking from gallery: $e");
      Fluttertoast.showToast(msg: "Gallery selection failed: $e");
    }
  }

  /// Process selected images efficiently
  Future<void> _processSelectedImages(List<XFile> images) async {
    const int batchSize = 5; // Process in batches to avoid memory issues

    for (int i = 0; i < images.length; i += batchSize) {
      final batch = images.skip(i).take(batchSize);
      final batchFiles = batch.map((xfile) => File(xfile.path)).toList();
      _selectedImages.addAll(batchFiles);

      // Small delay between batches
      if (i + batchSize < images.length) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
  }

  /// Show camera view or take picture if already active
  void showCameraView() {
    if (_isCameraView.value == true) {
      log("current cam index:$currentCameraIndex");
      if (currentCameraIndex.value == 1) {
        log("flip and save");
        takePicture();
      } else {
        takePicture();
      }
    } else {
      _isCameraView.value = true;
    }
  }

  /// Remove image at index from selected list
  void clearSelectedImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      final file = _selectedImages[index];
      _selectedImages.removeAt(index);

      // Optional: Delete file from device storage if it was captured by camera
      _cleanupImageFile(file);
    }
  }

  /// Clean up temporary image files
  void _cleanupImageFile(File file) {
    try {
      // Only delete if it's in the app's temporary directory
      if (file.path.contains('cache') || file.path.contains('tmp')) {
        file.deleteSync();
      }
    } catch (e) {
      log('Error cleaning up image file: $e');
    }
  }

  /// Submit selected photos with validation
  void submitPhoto() {
    if (_selectedImages.isNotEmpty) {
      log('Submitting ${_selectedImages.length} high-quality images');
      // Add your upload logic here

      // Example: Validate image sizes and formats
      _validateImages();
    } else {
      Fluttertoast.showToast(msg: "Please select at least one photo");
    }
  }

  /// Validate selected images
  Future<void> _validateImages() async {
    try {
      for (final image in _selectedImages) {
        try {
          final stats = image.statSync();
          final sizeInMB = stats.size / (1024 * 1024);

          if (sizeInMB > 10) {
            // Warn if image is larger than 10MB
            log(
              'Large image detected: ${image.path} (${sizeInMB.toStringAsFixed(1)}MB)',
            );
          }
        } catch (e) {
          log('Error validating image ${image.path}: $e');
        }
      }
      //try to upload
      EasyLoading.show();
      final repo = await imagesrepo.saveImage(
        images: _selectedImages,
        accessToken: ctrl.accessToken.value,
        mediaId: ctrl.mediaId.value,
        rideId: ctrl.rideId.value,
      );

      repo.fold(
        (l) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "something went wrong");
        },
        (R) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "Image uploaded successfully");
          Get.back();
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      log("error in _validateImages():$e");
    }
  }

  /// Enhanced camera availability check
  bool get isCameraAvailable {
    return _controller != null &&
        _controller!.value.isInitialized &&
        !_isCameraInitializing.value &&
        !_isCapturing.value;
  }

  /// Enhanced camera status
  String get cameraStatus {
    if (_isCapturing.value) return 'Capturing...';
    if (_isCameraInitializing.value) return 'Camera initializing...';
    if (_controller == null) return 'Camera not available';
    if (!_controller!.value.isInitialized) return 'Camera not initialized';
    return 'Camera ready';
  }

  /// Get current camera info
  String get currentCameraInfo {
    if (cameras != null && currentCameraIndex.value < cameras!.length) {
      final camera = cameras![currentCameraIndex.value];
      return '${camera.lensDirection.name.toUpperCase()} Camera';
    }
    return 'Unknown Camera';
  }
}
