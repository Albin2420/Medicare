import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/audioscontroller/audiocontroller.dart';
import 'package:medicare/src/presentation/screens/voice/widget/rec_tile.dart';
import 'package:medicare/src/presentation/widgets/gradientbutton.dart';

class Voice extends StatelessWidget {
  const Voice({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            height: 50,
            width: 40,
            child: Image.asset("assets/icons/menu.png"),
          ),
        ),
        title: Text(
          "MediCare",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Text(
                "Upload voicenote",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 140,
              color: Color(0xff2c2b5133),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.transparent,
                      child: AudioWaveforms(
                        enableGesture: false,
                        size: Size(MediaQuery.of(context).size.width, 70),
                        recorderController: controller.recorderController,
                        waveStyle: WaveStyle(
                          waveColor: Colors.red,
                          showMiddleLine: false,
                          extendWaveform: true,
                          spacing: 3.0,
                          waveThickness: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              return Text(controller.formattedDuration);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (controller.recordings.isNotEmpty) {
                return SizedBox(height: 20);
              } else {
                return SizedBox(height: 60);
              }
            }),
            Column(
              children: [
                GestureDetector(
                  onLongPress: () {
                    log("start recording");
                    controller.startRecording();
                  },
                  onLongPressUp: () {
                    log("stop recording");
                    controller.stopRecording();
                  },
                  child: Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xff27264D), Color(0xff27264D)],
                        ),
                      ),
                      child: Center(
                        child: Transform.scale(
                          scale: 0.65,
                          child: Image.asset(
                            "assets/icons/mic.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Press & Hold\n \t to record.",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff353459),
                  ),
                ),
              ],
            ),
            SizedBox(height: 27),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemBuilder: (BuildContext context, index) {
                    return RecTile(
                      index: index,
                      play: () {
                        log("play :${controller.recordings[index]}");
                        controller.playRecording(
                          controller.recordings[index],
                          index,
                        );
                      },
                      delete: () {
                        controller.deleteRecording(
                          controller.recordings[index],
                        );
                      },
                    );
                  },
                  itemCount: controller.recordings.length,
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: GradientBorderContainer(
          name: 'Submit',
          onTap: () {
            controller.submitAudios();
          },
        ),
      ),
    );
  }
}
