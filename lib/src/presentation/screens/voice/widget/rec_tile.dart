// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:medicare/src/presentation/controller/audioscontroller/audiocontroller.dart';

// class RecTile extends StatelessWidget {
//   final int index;
//   final VoidCallback play;
//   final VoidCallback delete;

//   const RecTile({
//     super.key,
//     required this.index,
//     required this.play,
//     required this.delete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 34),
//           child: Row(
//             children: [
//               Text(
//                 "voicenote $index",
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xff3534594d)),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               height: 37,
//               width: 260,
//               child: Row(
//                 children: [
//                   SizedBox(width: 12),
//                   GestureDetector(
//                     onTap: play,
//                     child: SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: Obx(() {
//                         return Icon(
//                           audioController.currentplayingIndex.value == index &&
//                                   audioController.isPlaying.value
//                               ? Icons.pause
//                               : Icons.play_arrow,
//                           color: Colors.black,
//                         );
//                       }),
//                     ),
//                   ),
//                   Expanded(
//                     child: SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         activeTrackColor: Color(
//                           0xff353459,
//                         ), // Color of the track to the left of the thumb
//                         inactiveTrackColor: Colors
//                             .grey[300], // Color of the track to the right of the thumb
//                         thumbColor: Color(
//                           0xff353459,
//                         ), // Color of the thumb (controller)
//                         overlayColor: Color(
//                           0xff353459,
//                         ), // Ripple effect around the thumb
//                         thumbShape: RoundSliderThumbShape(
//                           enabledThumbRadius: 6,
//                         ), // Smaller thumb
//                         overlayShape: RoundSliderOverlayShape(
//                           overlayRadius: 12,
//                         ),
//                       ),
//                       child: Slider(
//                         value: 150,
//                         min: 0,
//                         max: 200,
//                         onChanged: (value) {},
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 18),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: delete,
//               child: SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: Image.asset("assets/icons/delete.png"),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 26),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/audioscontroller/audiocontroller.dart';

class RecTile extends StatelessWidget {
  final int index;
  final VoidCallback play;
  final VoidCallback delete;

  const RecTile({
    super.key,
    required this.index,
    required this.play,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<AudioController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Row(
            children: [
              Text(
                "voicenote $index",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff3534594d)),
                borderRadius: BorderRadius.circular(50),
              ),
              height: 37,
              width: 260,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: play,
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Obx(() {
                        final isThisPlaying =
                            audioController.currentplayingIndex.value ==
                                index &&
                            audioController.isPlaying.value;
                        return Icon(
                          isThisPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final isThisPlaying =
                          audioController.currentplayingIndex.value == index;
                      final current = isThisPlaying
                          ? audioController.currentPosition.value.inSeconds
                                .toDouble()
                          : 0;
                      final total = isThisPlaying
                          ? audioController.totalDuration.value.inSeconds
                                .toDouble()
                          : 1;

                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xff353459),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: const Color(0xff353459),
                          overlayColor: const Color(0xff353459),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                        ),
                        child: Slider(
                          value: current.clamp(0, total).toDouble(),
                          min: 0,
                          max: total == 0 ? 1 : total.toDouble(),
                          onChanged: (value) {
                            audioController.seekTo(value);
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 18),
                ],
              ),
            ),
            GestureDetector(
              onTap: delete,
              child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset("assets/icons/delete.png"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
      ],
    );
  }
}
