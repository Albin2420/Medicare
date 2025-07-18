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

    return Scaffold(
      extendBody: true,
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
      body: Obx(
        () => FlutterMap(
          options: MapOptions(
            initialCenter: lat.LatLng(ctrl.lat.value, ctrl.long.value),
            initialZoom: 17.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: NetworkTileProvider(),
              userAgentPackageName: 'com.yourcompany.yourapp', // required
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: lat.LatLng(ctrl.lat.value, ctrl.long.value),
                  width: 40,
                  height: 40,
                  child: Image.asset("assets/icons/Iam.png"),
                ),
                if (ctrl.routePoints.isNotEmpty)
                  Marker(
                    point: lat.LatLng(
                      ctrl.driverLat.value,
                      ctrl.driverLong.value,
                    ),
                    width: 40,
                    height: 40,
                    child: Image.asset("assets/icons/destination.png"),
                  ),
              ],
            ),
            if (ctrl.routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: ctrl.routePoints.value,
                    strokeWidth: 4.0,
                    color: const Color.fromARGB(255, 0, 3, 6),
                  ),
                ],
              ),
          ],
        ),
      ),

      bottomNavigationBar: Obx(() {
        return GestureDetector(
          onTap: () {
            ctrl.toggleExpanded();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // light shadow
                  blurRadius: 20, // softness of the shadow
                  spreadRadius: 5, // how wide the shadow spreads
                  offset: Offset(0, -6), // x: 0, y: -5 (upward shadow)
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ctrl.isexpanded.value == false
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Obx(() {
                            return Text(
                              ctrl.ambulancestatus.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          SizedBox(height: 20),
                          Obx(() {
                            if (ctrl.eta?.value != '') {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                          SizedBox(height: 20),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Obx(() {
                            return Text(
                              ctrl.ambulancestatus.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 34, right: 34),
                            child: Obx(() {
                              if (ctrl.eta?.value != '') {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: 20),

                          Divider(),

                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Container(
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
                                    child: Image.asset(
                                      "assets/icons/phone.png",
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Alternate Phone Number"),
                                ],
                              ),
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
                                      if (ctrl.mediaId.value != "") {
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
                                                color: Color(
                                                  0xff27264D,
                                                ).withOpacity(0.3),
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
                                      if (ctrl.mediaId.value != "") {
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
                                                color: Color(
                                                  0xff27264D,
                                                ).withOpacity(0.3),
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
                                                  Color.fromARGB(
                                                    150,
                                                    239,
                                                    29,
                                                    29,
                                                  ),
                                                  Color(0xff8D0808),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color(
                                                  0xff27264D,
                                                ).withOpacity(0.3),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Obx(() {
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
                                        colors: [
                                          Color(0xffE75757),
                                          Color(0xff8C0707),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.asset(
                                            "assets/icons/phonewhite.png",
                                          ),
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
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
              ],
            ),
          ),
        );
      }),
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
                            if (ctrl.mediaId.value != "") {
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
                            if (ctrl.mediaId.value != "") {
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
              ],
            ),
          ),
        );
      },
    );
  }
}
