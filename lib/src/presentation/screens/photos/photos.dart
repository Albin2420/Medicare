import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:medicare/src/presentation/controller/homecontroller/homecontroller.dart';
import 'package:medicare/src/presentation/controller/photoscontroller/photoscontroller.dart';
import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class Photos extends StatelessWidget {
  const Photos({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhotosController());
    final ctrlr = Get.find<Homecontroller>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(screenWidth, screenHeight),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              _buildTitle(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildPhotoContainer(controller, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.04),
              _buildControlButtons(controller, screenWidth),
              SizedBox(height: screenHeight * 0.04),
              _buildSubmitButton(controller),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(double screenWidth, double screenHeight) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.all(screenWidth * 0.015),
        child: SizedBox(
          height: screenHeight * 0.06,
          width: screenWidth * 0.08,
          child: Image.asset("assets/icons/menu.png"),
        ),
      ),
      title: Text(
        "MediCare",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * 0.05,
        ),
      ),
      flexibleSpace: Column(
        children: [
          const Spacer(),
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build title section
  Widget _buildTitle(double screenWidth) {
    return Center(
      child: Text(
        "upload photos",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * 0.08,
          color: const Color(0xff353459),
        ),
      ),
    );
  }

  /// Build main photo container
  Widget _buildPhotoContainer(
    PhotosController controller,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight * 0.45,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => controller.isCameraView
            ? _buildCameraView(controller)
            : _buildImageView(controller),
      ),
    );
  }

  /// Build camera view with live preview
  Widget _buildCameraView(PhotosController controller) {
    if (!controller.isCameraAvailable) {
      if (controller.isflipping.value) {
        log("flipping");
      } else {}
    }

    return Obx(() {
      // Show loading indicator when camera is initializing
      if (controller.isCameraInitializing) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const CircularProgressIndicator(color: Colors.black)],
          ),
        );
      }

      return FutureBuilder<void>(
        future: controller.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Camera preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Transform(
                      alignment: Alignment.center,
                      // Mirror the preview for front camera (but not the captured image)
                      transform: controller.currentCameraIndex == 1
                          ? Matrix4.rotationY(3.14159) // 180 degrees in radians
                          : Matrix4.identity(),
                      child: CameraPreview(controller.controller!),
                    ),
                    // child: CameraPreview(controller.controller!,),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }
        },
      );
    });
  }

  /// Build image view showing selected photos
  Widget _buildImageView(PhotosController controller) {
    return Obx(() {
      if (controller.selectedImages.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.selectedImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final image = controller.selectedImages[index];
              return GestureDetector(
                onLongPress: () {},
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.clearSelectedImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No photo selected',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap camera or gallery to add photo',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  /// Build control buttons (Gallery, Camera, Switch Camera)
  Widget _buildControlButtons(PhotosController controller, double screenWidth) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gallery button
          _buildControlButton(
            onTap: controller.pickFromGallery,
            size: screenWidth * 0.15,
            imagePath: "assets/icons/gallery.png",
            isActive: false,
            label: "Gallery",
          ),
          // Camera button
          _buildControlButton(
            onTap: controller.showCameraView,
            size: screenWidth * 0.20,
            imagePath: "assets/icons/cam1.png",
            isActive: controller.isCameraView,
            activeColor: Colors.blue,
            label: controller.isCameraView ? "Capture" : "Camera",
          ),
          // Switch Camera button
          _buildControlButton(
            onTap: controller.switchCamera,
            size: screenWidth * 0.15,
            imagePath: "assets/icons/flip-camera-ios.png",
            isActive: controller.isCameraInitializing,
            activeColor: Colors.orange,
            label: "Switch",
            isLoading: controller.isCameraInitializing,
          ),
        ],
      ),
    );
  }

  /// Build individual control button
  Widget _buildControlButton({
    required VoidCallback onTap,
    required double size,
    required String imagePath,
    required bool isActive,
    required String label,
    Color? activeColor,
    bool isLoading = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isActive
                  ? (activeColor ?? Colors.blue).withOpacity(0.15)
                  : Colors.grey.withOpacity(0.1),
              border: isActive
                  ? Border.all(color: activeColor ?? Colors.blue, width: 2)
                  : Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                color: isActive ? (activeColor ?? Colors.blue) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive
                ? (activeColor ?? Colors.blue)
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Build submit button
  Widget _buildSubmitButton(PhotosController controller) {
    return Obx(
      () => GradientBorderContainer(
        onTap: controller.selectedImages.isNotEmpty
            ? controller.submitPhoto
            : () {},
        name: "Submit",
      ),
    );
  }
}
