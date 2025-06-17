import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/homecontroller/Homecontroller.dart';
import 'package:medicare/src/presentation/screens/photos/photos.dart';
import 'package:medicare/src/presentation/screens/voice/voice.dart';
import 'package:latlong2/latlong.dart' as lat;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Homecontroller>();

    // METHOD 1: Show bottom sheet immediately when screen loads
    // Uncomment this to show the bottom sheet as soon as the screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ctrl.hasShownSheet.value) {
        ctrl.hasShownSheet.value = true;
        _showEmergencySheet(context);
      }
    });

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
        // METHOD 2: Add action button in AppBar to show bottom sheet
        // actions: [
        //   IconButton(
        //     onPressed: () => _showEmergencySheet(context),
        //     icon: Icon(Icons.emergency, color: Colors.red),
        //   ),
        // ],
      ),
      body: Obx(
        () => FlutterMap(
          options: MapOptions(
            initialCenter: lat.LatLng(ctrl.lat.value, ctrl.long.value),
            initialZoom: 17.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // no subdomains to avoid OSM warning
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: ctrl.start,
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/icons/accident.png"),
                ),
                Marker(
                  point: ctrl.end,
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/icons/loc.png"),
                ),
              ],
            ),
            if (ctrl.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: ctrl.routePoints.value,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          _showEmergencySheet(context);
        },
        child: Icon(Icons.emergency, color: Colors.red.withOpacity(0.9)),
      ),
    );
  }

  // Extract the bottom sheet logic into a separate method
  void _showEmergencySheet(BuildContext context) {
    final ctrl = Get.find<Homecontroller>();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 32, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      ctrl.ambulancestatus.value,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: const Color(0xff353459),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Obx(() {
                    if (ctrl.eta?.value != '') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ETA: ${ctrl.eta} mins",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            ctrl.ambulanceRegNumber.value,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xff353459),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
                ),
                Obx(() {
                  if (ctrl.eta?.value != '') {
                    return SizedBox(height: 16);
                  } else {
                    return SizedBox();
                  }
                }),
                const Divider(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add more details",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: const Color(0xff353459),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text("(optional)"),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffEBEBEF),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Color(0xff27264D).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.asset("assets/icons/phone.png"),
                      ),
                      const SizedBox(width: 10),
                      const Text("Alternate Phone Number"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 130,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            log("upload photos");
                            if (ctrl.bookingId.value != "") {
                              Get.to(() => Photos());
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEBEBEF),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xff27264D).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.55,
                                      child: Image.asset(
                                        "assets/icons/cam.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Upload Photos",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            log("upload voice");
                            if (ctrl.bookingId.value != "") {
                              Get.to(() => Voice());
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEBEBEF),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xff27264D).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.55,
                                      child: Image.asset(
                                        "assets/icons/mic.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "voicenote",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            log("first aid");
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(150, 239, 29, 29),
                                        Color(0xff8D0808),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xff27264D).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.55,
                                      child: Image.asset(
                                        "assets/icons/bxs_first-aid.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "First Aid Tips",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  if (ctrl.mobNo.value != '') {
                    return GestureDetector(
                      onTap: () {
                        final ctrl = Get.find<Homecontroller>();
                        ctrl.makePhoneCall(ctrl.mobNo.value);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 14,
                          bottom: 14,
                          left: 20,
                          right: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [Color(0xffE75757), Color(0xff8C0707)],
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset("assets/icons/phonewhite.png"),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "call Ambulance",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                // SizedBox(height: 24),
                // Text(
                //   "First Aid Tips",
                //   style: GoogleFonts.poppins(
                //     fontWeight: FontWeight.w700,
                //     fontSize: 28,
                //   ),
                // ),
                // SizedBox(height: 24),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       padding: EdgeInsets.only(
                //         top: 10,
                //         bottom: 10,
                //         left: 20,
                //         right: 20,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Color(0xffEBEBEF),
                //         borderRadius: BorderRadius.circular(50),
                //         border: Border.all(width: 0.42, color: Colors.grey),
                //       ),
                //       width: 114,
                //       child: Text("I was in an accident"),
                //     ),
                //     Container(
                //       padding: EdgeInsets.only(
                //         top: 10,
                //         bottom: 10,
                //         left: 20,
                //         right: 20,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Color(0xffEBEBEF),
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //       width: 174,
                //       child: Text("someone else was in an accident"),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 24),
                // Text(
                //   "if you have been in an accident:",
                //   style: GoogleFonts.poppins(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //   ),
                // ),
                // SizedBox(height: 24),
                // Tailer(
                //   title: '1. Stay Calm and Assess Yourself',
                //   description:
                //       'Take a deep breath. Check for bleeding, pain, or any immobility.',
                // ),
                // Tailer(
                //   title: '2. Get to Safety (If Possible)',
                //   description:
                //       "If you're able to move, get out of harm's way (e.g., get off the road or move away from a burning vehicle).",
                // ),
                // Tailer(
                //   title: '3. Control Bleeding',
                //   description:
                //       'Use clean cloth, clothing, or hands to apply firm pressure to wounds.',
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
