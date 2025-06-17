// showModalBottomSheet(
//             backgroundColor = Colors.white,
//             context = context,
//             isScrollControlled =
//                 true, // Allows the bottom sheet to take full height
//             shape = const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(32),
//                 topRight: Radius.circular(32),
//               ),
//             ),
//             builder = (BuildContext context) {
//               return DraggableScrollableSheet(
//                 expand: false,
//                 initialChildSize: 0.7, // Adjust as needed
//                 minChildSize: 0.5,
//                 maxChildSize: 0.95,
//                 builder: (_, scrollController) {
//                   return SingleChildScrollView(
//                     controller: scrollController,
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         top: 20,
//                         bottom: 32,
//                         left: 16,
//                         right: 16,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Ambulance requested",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 24,
//                               color: const Color(0xff353459),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "ETA: -PM ",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           const Divider(),
//                           const SizedBox(height: 24),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Add more details",
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 20,
//                                   color: const Color(0xff353459),
//                                 ),
//                               ),
//                               const SizedBox(width: 6),
//                               const Text("(optional)"),
//                             ],
//                           ),
//                           const SizedBox(height: 24),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 14,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xffEBEBEF),
//                               borderRadius: BorderRadius.circular(50),
//                               border: Border.all(
//                                 color: Color(0xff27264D).withOpacity(0.3),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   height: 24,
//                                   width: 24,
//                                   child: Image.asset("assets/icons/phone.png"),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 const Text("Alternate Phone Number"),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           SizedBox(
//                             height: 130,
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       log("upload photos");
//                                       Get.to(() => Photos());
//                                     },
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Color(0xffEBEBEF),
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: Color(
//                                                   0xff27264D,
//                                                 ).withOpacity(0.3),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Transform.scale(
//                                                 scale: 0.55,
//                                                 child: Image.asset(
//                                                   "assets/icons/cam.png",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         Text(
//                                           "Upload Photos",
//                                           style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       log("upload voice");
//                                       Get.to(() => Voice());
//                                     },
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Color(0xffEBEBEF),
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: Color(
//                                                   0xff27264D,
//                                                 ).withOpacity(0.3),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Transform.scale(
//                                                 scale: 0.55,
//                                                 child: Image.asset(
//                                                   "assets/icons/mic.png",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         Text(
//                                           "voicenote",
//                                           style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       log("first aid");
//                                     },
//                                     child: Column(
//                                       children: [
//                                         Expanded(
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                                 colors: [
//                                                   Color.fromARGB(
//                                                     150,
//                                                     239,
//                                                     29,
//                                                     29,
//                                                   ),
//                                                   Color(0xff8D0808),
//                                                 ],
//                                               ),
//                                               shape: BoxShape.circle,
//                                               border: Border.all(
//                                                 color: Color(
//                                                   0xff27264D,
//                                                 ).withOpacity(0.3),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Transform.scale(
//                                                 scale: 0.55,
//                                                 child: Image.asset(
//                                                   "assets/icons/bxs_first-aid.png",
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         Text(
//                                           "First Aid Tips",
//                                           style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           GestureDetector(
//                             onTap: () {
//                               ctrl.makePhoneCall("1234567890");
//                             },
//                             child: Container(
//                               padding: EdgeInsets.only(
//                                 top: 14,
//                                 bottom: 14,
//                                 left: 20,
//                                 right: 20,
//                               ),
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Color(0xffE75757),
//                                     Color(0xff8C0707),
//                                   ],
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   SizedBox(width: 10),
//                                   SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: Image.asset(
//                                       "assets/icons/phonewhite.png",
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     "call Ambulance",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Text(
//                             "First Aid Tips",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 28,
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.only(
//                                   top: 10,
//                                   bottom: 10,
//                                   left: 20,
//                                   right: 20,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xffEBEBEF),
//                                   borderRadius: BorderRadius.circular(50),
//                                   border: Border.all(
//                                     width: 0.42,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 width: 114,
//                                 child: Text("I was in an accident"),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.only(
//                                   top: 10,
//                                   bottom: 10,
//                                   left: 20,
//                                   right: 20,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xffEBEBEF),
//                                   borderRadius: BorderRadius.circular(50),
//                                 ),
//                                 width: 174,
//                                 child: Text("someone else was in an accident"),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 24),

//                           // controll the logic
//                           Text(
//                             "if you have been in an accident:",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Tailer(
//                             title: '1. Stay Calm and Assess Yourself',
//                             description:
//                                 'Take a deep breath. Check for bleeding, pain, or any immobility.',
//                           ),
//                           Tailer(
//                             title: '2. Get to Safety (If Possible)',
//                             description:
//                                 "If you're able to move, get out of harm’s way (e.g., get off the road or move away from a burning vehicle).",
//                           ),
//                           Tailer(
//                             title: '3. Control Bleeding',
//                             description:
//                                 'Use clean cloth, clothing, or hands to apply firm pressure to wounds.',
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
