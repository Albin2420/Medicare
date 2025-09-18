import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/src/presentation/controller/homecontroller/homecontroller.dart';
import 'package:medicare/src/presentation/screens/photos/photos.dart';
import 'package:medicare/src/presentation/screens/voice/voice.dart';
import 'package:latlong2/latlong.dart' as lat;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<Homecontroller>();

    return WillPopScope(
      onWillPop: () async {
        if (EasyLoading.isShow) {
          return false;
        }
        if (ctrl.isInrIDE.value) {
          return true;
        } else {
          ctrl.isRideEnd.value = "";
          return true;
        }
      },
      child: Scaffold(
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
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 20,
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
        ),
        body: Obx(() {
          if (ctrl.lat.value == 0.0 || ctrl.long.value == 0.0) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.7),
              ),
            );
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: lat.LatLng(ctrl.lat.value, ctrl.long.value),
              initialZoom: 17.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: NetworkTileProvider(),
                userAgentPackageName: 'com.yourcompany.yourapp',
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
                      points: ctrl.routePoints,
                      strokeWidth: 4.0,
                      color: const Color.fromARGB(255, 0, 3, 6),
                    ),
                  ],
                ),
            ],
          );
        }),
        bottomNavigationBar: Obx(() {
          return GestureDetector(
            onTap: () {
              ctrl.toggleExpanded();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ctrl.isRideEnd.value != ""
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            Obx(() {
                              return Text(
                                "${ctrl.isRideEnd}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                            const SizedBox(height: 20),
                          ],
                        )
                      : ctrl.isexpanded.value == false
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
                            Obx(() {
                              if (ctrl.eta?.value != '') {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "ETA: ${ctrl.eta}",
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
                                          color: const Color(0xff353459),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                            const SizedBox(height: 20),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 34,
                              ),
                              child: Obx(() {
                                if (ctrl.eta?.value != '') {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "ETA: ${ctrl.eta}",
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
                                          color: const Color(0xff353459),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEBEBEF),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: const Color(
                                      0xff27264D,
                                    ).withOpacity(0.3),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
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
                                                  color: const Color(
                                                    0xffEBEBEF,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(
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
                                            const SizedBox(height: 10),
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
                                                  color: const Color(
                                                    0xffEBEBEF,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(
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
                                            const SizedBox(height: 10),
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
                                                  gradient:
                                                      const LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
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
                                                    color: const Color(
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
                                            const SizedBox(height: 10),
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
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Obx(() {
                                if (ctrl.mobNo.value != '') {
                                  return GestureDetector(
                                    onTap: () {
                                      ctrl.makePhoneCall(ctrl.mobNo.value);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 14,
                                      ),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xffE75757),
                                            Color(0xff8C0707),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
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
                                  return const SizedBox();
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
      ),
    );
  }
}
