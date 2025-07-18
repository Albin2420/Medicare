import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicare/src/data/repositories/media/audiosrepo/audiorepoimpl.dart';
import 'package:medicare/src/domain/repositories/media/audiosrepo/audiosrepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';
import 'package:medicare/src/presentation/controller/homecontroller/Homecontroller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends GetxController {
  final ctrl = Get.find<Appstartupcontroller>();
  final homectrl = Get.find<Homecontroller>();
  Audiosrepo audiosrepo = Audiorepoimpl();

  late RecorderController recorderController;
  final Rx<Duration> recordingDuration = Duration.zero.obs;
  Timer? timer;
  RxBool isRecording = false.obs;

  final RxList<FileSystemEntity> recordings = <FileSystemEntity>[].obs;

  final AudioPlayer audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  RxString currentPlayingPath = ''.obs;
  RxInt currentplayingIndex = RxInt(-1);

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;

  RxString accesstoken = RxString("initialToken");
  RxString mediaId = RxString("initialid");
  RxInt rideId = RxInt(-1);

  @override
  void onInit() {
    super.onInit();

    fetchId();

    recorderController = RecorderController();
    _requestMicrophonePermission();

    loadRecordings();

    audioPlayer.onPositionChanged.listen((pos) {
      currentPosition.value = pos;
    });

    audioPlayer.onDurationChanged.listen((dur) {
      totalDuration.value = dur;
    });

    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      currentPosition.value = Duration.zero;
    });
  }

  void fetchId() async {
    accesstoken.value = (await ctrl.getAccessToken())!;
    mediaId.value = homectrl.mediaId.value;
    rideId.value = homectrl.rideId.value;
  }

  @override
  void onClose() {
    _stopAndCleanupTimer();
    recorderController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void _stopAndCleanupTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus.isPermanentlyDenied) await openAppSettings();
  }

  void _resetRecordingState() {
    _stopAndCleanupTimer();
    isRecording.value = false;
    recordingDuration.value = Duration.zero;
  }

  // Helper method to get formatted duration
  String get formattedDuration {
    final minutes = recordingDuration.value.inMinutes;
    final seconds = recordingDuration.value.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> startRecording() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return;

    final dir = await getApplicationDocumentsDirectory();
    final subDir = Directory('${dir.path}/medicare');
    if (!await subDir.exists()) await subDir.create(recursive: true);

    final path =
        '${subDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 48000
      ..bitRate = 320000;

    await recorderController.record(path: path);
    recordingDuration.value = Duration.zero;

    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (isRecording.value) {
        recordingDuration.value += const Duration(milliseconds: 100);
        if (recordingDuration.value.inMinutes >= 10) stopRecording();
      }
    });

    isRecording.value = true;
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;
    await recorderController.stop();
    _resetRecordingState();
    await loadRecordings();
  }

  Future<void> loadRecordings() async {
    final dir = await getApplicationDocumentsDirectory();
    final subdir = Directory('${dir.path}/medicare');
    if (!await subdir.exists()) return;

    final files =
        subdir.listSync().where((f) => f.path.endsWith('.m4a')).toList()..sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );

    recordings.value = files;
  }

  Future<void> deleteRecording(FileSystemEntity file) async {
    await file.delete();
    await loadRecordings();
  }

  Future<void> playRecording(FileSystemEntity file, int index) async {
    if (isPlaying.value) {
      await audioPlayer.stop();
      isPlaying.value = false;
    }

    if (!await File(file.path).exists()) return;

    await audioPlayer.play(DeviceFileSource(file.path));
    currentplayingIndex.value = index;
    currentPlayingPath.value = file.path;
    isPlaying.value = true;
  }

  Future<void> seekTo(double seconds) async {
    await audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  Future<void> submitAudios() async {
    try {
      EasyLoading.show();
      final fl = await audiosrepo.saveAudio(
        audios: recordings,
        accessToken: accesstoken.value,
        mediaId: mediaId.value,
        rideId: rideId.value,
      );

      fl.fold(
        (l) {
          log("failed");
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "failed to upload voice note");
        },
        (r) {
          log("success");
          EasyLoading.dismiss();
          Get.back();
          Fluttertoast.showToast(msg: "voice uploaded successfully");
        },
      );
    } catch (e) {
      log("Error in submitAudios():$e");
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Error in submitAudios()$e");
    }
  }
}















//older one 


// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:audioplayers/audioplayers.dart';

// class AudioController extends GetxController {
//   late RecorderController recorderController;
//   final Rx<Duration> recordingDuration = Duration.zero.obs;
//   Timer? timer;
//   RxBool isRecording = RxBool(false);

//   final RxList<FileSystemEntity> recordings = <FileSystemEntity>[].obs;

//   final AudioPlayer audioPlayer = AudioPlayer();
//   final RxBool isPlaying = false.obs;
//   RxString currentPlayingPath = ''.obs;
//   RxInt currentplayingIndex = RxInt(-1);

//   @override
//   void onInit() {
//     super.onInit();
//     log("AudioController initialized()");
//     recorderController = RecorderController();
//     _requestMicrophonePermission();
//   }

//   @override
//   void onClose() {
//     // CRITICAL: Always clean up timer when controller is disposed
//     _stopAndCleanupTimer();
//     recorderController.dispose();
//     super.onClose();
//   }

//   // Centralized timer cleanup method
//   void _stopAndCleanupTimer() {
//     log("🧹 Cleaning up timer...");
//     if (timer != null) {
//       timer!.cancel();
//       timer = null;
//       log("✅ Timer cancelled and nullified");
//     }
//   }

//   Future<void> _requestMicrophonePermission() async {
//     final micStatus = await Permission.microphone.request();

//     if (micStatus.isGranted) {
//       log("✅ Microphone permission granted on init");
//     } else if (micStatus.isDenied) {
//       log("❌ Microphone permission denied on init");
//       Fluttertoast.showToast(
//         msg: "Microphone permission is required to record audio",
//         fontSize: 16,
//       );
//     } else if (micStatus.isPermanentlyDenied) {
//       log("🚫 Microphone permission permanently denied");
//       Fluttertoast.showToast(
//         msg:
//             "Microphone permission permanently denied. Please enable it from settings.",
//         fontSize: 16,
//       );
//       await openAppSettings(); // Direct user to settings
//     }
//   }

//   // Reset recording state
//   void _resetRecordingState() {
//     log("🔄 Resetting recording state...");
//     _stopAndCleanupTimer();
//     isRecording.value = false;
//     recordingDuration.value = Duration.zero;
//   }

//   Future<void> startRecording() async {
//     log("🎤 Starting recording...");

//     // If already recording, stop first
//     if (isRecording.value) {
//       log("⚠️ Already recording, stopping first...");
//       await stopRecording();
//     }

//     final micStatus = await Permission.microphone.request();
//     if (!micStatus.isGranted) {
//       log("❌ Microphone permission denied");
//       Fluttertoast.showToast(msg: "Microphone permission denied", fontSize: 16);
//       return;
//     }

//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       log("📁 Directory path: ${directory.path}/medicare");

//       final subDir = Directory('${directory.path}/medicare');
//       if (!await subDir.exists()) {
//         await subDir.create(recursive: true);
//       }

//       final path =
//           '${subDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
//       log("🎵 Recording path: $path");

//       // Configure recorder
//       recorderController
//         ..androidEncoder = AndroidEncoder.aac
//         ..androidOutputFormat = AndroidOutputFormat.mpeg4
//         ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//         ..sampleRate = 48000
//         ..bitRate = 320000;

//       // Start recording
//       await recorderController.record(path: path);

//       // Reset duration and start timer
//       recordingDuration.value = Duration.zero;

//       // Ensure no existing timer before creating new one
//       _stopAndCleanupTimer();

//       timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
//         if (isRecording.value) {
//           recordingDuration.value += const Duration(milliseconds: 100);
//           // Optional: Add maximum recording duration
//           if (recordingDuration.value.inMinutes >= 10) {
//             // 10 minute limit
//             log("⏰ Maximum recording duration reached");
//             stopRecording();
//           }
//         } else {
//           // Safety: Stop timer if recording state is false
//           log("⚠️ Timer running but not recording - stopping timer");
//           _stopAndCleanupTimer();
//         }
//       });

//       isRecording.value = true;
//       log("✅ Recording started successfully");
//     } catch (e) {
//       log("❌ Error starting recording: $e");
//       _resetRecordingState();
//       Fluttertoast.showToast(
//         msg: "Failed to start recording: $e",
//         fontSize: 16,
//       );
//     }
//   }

//   Future<void> stopRecording() async {
//     log("🛑 Stopping recording...");

//     if (!isRecording.value) {
//       log("⚠️ Not currently recording");
//       _resetRecordingState(); // Clean up anyway
//       return;
//     }

//     try {
//       // Stop the recorder first
//       await recorderController.stop();
//       log("✅ Recorder stopped");

//       // Clean up timer and reset state
//       _resetRecordingState();

//       // Load updated recordings
//       await loadRecordings();

//       log("✅ Recording stopped successfully");
//     } catch (e) {
//       log("❌ Error stopping recording: $e");
//       // Even if stopping fails, clean up the timer and state
//       _resetRecordingState();
//       Fluttertoast.showToast(msg: "Error stopping recording: $e", fontSize: 16);
//     }
//   }

//   Future<void> loadRecordings() async {
//     try {
//       log("📂 Loading recordings...");
//       recordings.clear();

//       final directory = await getApplicationDocumentsDirectory();
//       final subdir = Directory('${directory.path}/medicare');

//       if (await subdir.exists()) {
//         final files = subdir
//             .listSync()
//             .where((file) => file.path.endsWith('.m4a'))
//             .toList();

//         // Sort by modification date (newest first)
//         files.sort(
//           (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
//         );

//         recordings.value = files;
//         log("✅ Loaded ${files.length} recordings");
//       } else {
//         log("⚠️ Medicare directory doesn't exist yet");
//       }
//     } catch (e) {
//       log("❌ Error loading recordings: $e");
//     }
//   }

//   // Helper method to get formatted duration
//   String get formattedDuration {
//     final minutes = recordingDuration.value.inMinutes;
//     final seconds = recordingDuration.value.inSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }

//   // Method to delete a recording
//   Future<void> deleteRecording(FileSystemEntity file) async {
//     try {
//       log("🗑️ Deleting recording: ${file.path}");
//       await file.delete();
//       await loadRecordings(); // Refresh list
//       log("✅ Recording deleted");
//     } catch (e) {
//       log("❌ Error deleting recording: $e");
//       Fluttertoast.showToast(msg: "Failed to delete recording", fontSize: 16);
//     }
//   }

//   Future<void> playRecording(FileSystemEntity file, int index) async {
//     try {
//       if (file is! File) {
//         log("❌ Not a file: ${file.path}");
//         Fluttertoast.showToast(
//           msg: "Selected item is not a file",
//           fontSize: 16,
//         );
//         return;
//       }

//       if (!await file.exists()) {
//         log("❌ File does not exist: ${file.path}");
//         Fluttertoast.showToast(msg: "Audio file not found", fontSize: 16);
//         return;
//       }

//       // Stop any current playback
//       if (isPlaying.value) {
//         await audioPlayer.stop();
//         isPlaying.value = false;
//         currentPlayingPath.value = '';
//       }

//       currentPlayingPath.value = file.path;

//       await audioPlayer.play(DeviceFileSource(file.path));
//       currentplayingIndex.value = index;
//       isPlaying.value = true;

//       log("▶️ Playing: ${file.path}");

//       audioPlayer.onPlayerComplete.listen((event) {
//         isPlaying.value = false;
//         currentPlayingPath.value = '';
//         log("✅ Playback completed");
//       });
//     } catch (e) {
//       isPlaying.value = false;
//       log("❌ Error playing file: $e");
//       Fluttertoast.showToast(msg: "Error playing recording", fontSize: 16);
//     }
//   }
// }
