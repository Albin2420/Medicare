// controllers are use in this folder

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlng;
import 'package:medicare/src/data/repositories/check-ride/check_rideRepoImpl.dart';
import 'package:medicare/src/data/services/hive_services/rideDetails/ambulance_data.dart';
import 'package:medicare/src/domain/repositories/check-ride/check_rideRepo.dart';
import 'package:medicare/src/presentation/screens/Home/landing.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/Homescreen.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/donateBlood.dart';
import 'package:medicare/src/presentation/screens/Home/widgets/requestBlood.dart';
import 'package:open_route_service/open_route_service.dart';

import 'package:medicare/src/data/repositories/location/locationrepoimpl.dart';
import 'package:medicare/src/domain/repositories/location/locationrepo.dart';
import 'package:medicare/src/presentation/controller/appstartupcontroller/appstartupcontroller.dart';
import 'package:medicare/src/presentation/screens/Home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as fs;
import 'package:web_socket_channel/web_socket_channel.dart';

class Homecontroller extends GetxController {
  RxBool hasShownSheet = RxBool(false);
  Stream<Position>? _positionStream;
  RxDouble lat = RxDouble(0.0);
  RxDouble long = RxDouble(0.0);
  RxString location = RxString("initial");
  static const epsilon = 0.00001;
  RxBool deniedforver = RxBool(false);

  Locationrepo lcrepo = Locationrepoimpl();
  WebSocketChannel? channel;

  RxString accessToken = RxString("initial");

  final ctrlr = Get.find<Appstartupcontroller>();

  //ambulance details
  RxString ambulancestatus = RxString("Ambulance requested...");
  RxString ambulanceRegNumber = RxString("");
  RxString mediaId = RxString("");
  RxString mobNo = RxString("");
  RxString? eta = RxString("");
  RxString name = RxString("");
  RxDouble driverLat = RxDouble(0);
  RxDouble driverLong = RxDouble(0);
  RxInt rideId = RxInt(-1);

  // final latlng.LatLng start = latlng.LatLng(10.1081324, 76.3585433);
  // final latlng.LatLng end = latlng.LatLng(10.120000, 76.360000);

  final RxList<latlng.LatLng> routePoints = RxList<latlng.LatLng>();

  final openrouteservice = OpenRouteService(
    apiKey: fs.dotenv.env['ORS_API_KEY'] ?? 'defaultApi',
    defaultProfile: ORSProfile.drivingCar,
  );

  RxBool isexpanded = RxBool(false);
  RxString distancetoLocation = RxString('');
  var dt = {}.obs;
  RxInt id = RxInt(-1);

  RxInt previousRideId = RxInt(-1);

  CheckRiderepo checkRidedetail = CheckRiderepoimpl();

  var decoded = {}.obs;

  RxBool isInrIDE = RxBool(false);

  final PageController pageController = PageController();
  var currentpageIndex = 0.obs;
  var isUiReady = false.obs;

  @override
  void onInit() async {
    super.onInit();

    id.value = await ctrlr.getId();
    previousRideId.value = await ctrlr.getRideId();
    connect(usId: id.value);
    _initializeController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isUiReady.value = true;
    });
  }

  void onPageChange({required int index}) {
    try {
      pageController.jumpToPage(index);
      currentpageIndex.value = index;
    } catch (e) {
      log("Error changing page: $e");
      Fluttertoast.showToast(
        msg: "Error changing page",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _initializeController() async {
    log("🏠 HomeController initialized");

    startListeningToLocation();

    final token = await ctrlr.getAccessToken();
    if (token == null) {
      log("❌ Failed to get access token");
      return;
    }
    accessToken.value = token;

    if (previousRideId.value != -1) {
      await _waitForValidLocation();
      checkRide(rideId: previousRideId.value);
    } else {
      log("ℹ️ No valid previous ride found");
    }
  }

  Future<void> _waitForValidLocation({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    const checkInterval = Duration(milliseconds: 300);
    final startTime = DateTime.now();

    while ((lat.value == 0.0 || long.value == 0.0) &&
        DateTime.now().difference(startTime) < timeout) {
      await Future.delayed(checkInterval);
    }

    if (lat.value != 0.0 && long.value != 0.0) {
      log("📍 Location received: (${lat.value}, ${long.value})");
    } else {
      log("⚠️ Timed out waiting for location.");
    }
  }

  void checkRide({required int rideId}) async {
    try {
      final res = await checkRidedetail.checkRidestatus(
        accesstoken: accessToken.value,
        rideId: previousRideId.value,
      );
      res.fold(
        (l) {
          log("failed in checking");
        },
        (R) {
          if (R['ongoing'] == true) {
            Fluttertoast.showToast(msg: "still in ride");
            isInrIDE.value = R['ongoing'];
            loadAmbulanceData();
            getDistanceAndRouteFromOSRM(
              startLat: lat.value,
              startLon: long.value,
              endLat: R['latitude'],
              endLon: R['longitude'],
            );
          } else {
            isInrIDE.value = R['ongoing'];
          }
        },
      );
    } catch (e) {
      log("error in checkRide():$e");
    }
  }

  void toggleExpanded() {
    if (isexpanded.value == true) {
      isexpanded.value = false;
    } else {
      isexpanded.value = true;
    }
  }

  Future<void> startListeningToLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log("requesting permission");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          log("Location permission denied");
          deniedforver.value = true;
          return;
        }
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      );

      _positionStream!.listen((Position position) {
        log("pos : ${position.latitude} ${position.longitude}");
        lat.value = position.latitude;
        long.value = position.longitude;

        getAddressFromLatLng(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      });
    } catch (e) {
      log("error:$e");
    }
  }

  Future<void> getAddressFromLatLng({
    required latitude,
    required longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        location.value =
            '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ,${place.postalCode}';

        log("final loc : $location");

        // getRoute(latitude: ,longitude: );
      }
    } catch (e) {
      log('Error in reverse geocoding: $e');
      getAddressFromLatLng(latitude: lat.value, longitude: long.value);
    }
  }

  void connect({required int usId}) {
    try {
      final uri = Uri.parse('ws://13.203.89.173:8001/ws/user/$id');

      channel = WebSocketChannel.connect(uri);
      log('🔌 Connecting to $uri');

      channel!.stream.listen(
        (data) async {
          try {
            log("in ws $id : $data");

            decoded.value = jsonDecode(data);

            if (decoded['type'] == "real_time_driver_location") {
              driverLat.value = decoded['latitude'];
              driverLong.value = decoded['longitude'];

              if (routePoints.isEmpty) {
                getDistanceAndRouteFromOSRM(
                  startLat: lat.value,
                  startLon: long.value,
                  endLat: decoded['latitude'],
                  endLon: decoded['longitude'],
                );
              } else {
                checkAndRemoveReachedPoint(
                  decoded['latitude'],
                  decoded['longitude'],
                );
              }
            }

            if (decoded['type'] == "ride_completed") {
              rideCompleted();
            }
          } catch (e) {
            log("error in connect():$e");
          }
        },
        onDone: () {
          log('❌ Connection closed.');
          connect(usId: id.value);
        },
        onError: (error) {
          log('🚨 Stream error: $error');
        },
        cancelOnError: true,
      );
    } catch (e, stack) {
      log("❗ Exception in connect(): $e\n$stack");
    }
  }

  void rideCompleted() {
    try {
      ctrlr.clearRideId();
      deleteAmbulanceData();
      clearRide();
      isInrIDE.value = false;
      Get.off(() => Landingscreen());
    } catch (e) {
      log("error in rideCompleted() :$e");
    }
  }

  Future<void> clearRide() async {
    try {
      routePoints.clear();
      ambulanceRegNumber.value = "";
      mediaId.value = "";
      mobNo.value = "";
      eta?.value = "";
      driverLat.value = 0;
      driverLong.value = 0;
      rideId.value = -1;
      ambulancestatus.value = "Ambulance requested...";
    } catch (e) {
      log("Error in clearRide():$e");
    }
  }

  void checkAndRemoveReachedPoint(double currentLat, double currentLng) {
    if (routePoints.isNotEmpty) {
      final driverPosition = latlng.LatLng(currentLat, currentLng);
      final nextPoint = routePoints[routePoints.length - 1];

      final distance = const latlng.Distance().as(
        latlng.LengthUnit.Meter,
        driverPosition,
        nextPoint,
      );

      if (distance < 20) {
        log(
          "🚗 Reached waypoint: ${nextPoint.latitude}, ${nextPoint.longitude} (Dist: ${distance.toStringAsFixed(2)}m)",
        );
        routePoints.removeAt(routePoints.length - 1);
      }
    }
  }

  void registerEmergency() async {
    if (accessToken.value != "initial" &&
        accessToken.value != "" &&
        location.value != "initial" &&
        isInrIDE.value != true) {
      try {
        EasyLoading.show();
        lcrepo
            .location(
              longitude: long.value,
              latitude: lat.value,
              landmark: location.value,
              accesstoken: accessToken.value,
            )
            .then((res) {
              res.fold(
                (l) {
                  log("failed in accept");
                  EasyLoading.dismiss();
                },
                (R) async {
                  try {
                    ambulanceRegNumber.value = R["ambulance_number"];
                    mediaId.value = R["id"];
                    mobNo.value = R["mobileNo"];
                    eta?.value = R["eta_minutes"];
                    driverLat.value = R['latitude'];
                    driverLong.value = R['longitude'];
                    rideId.value = R['rideId'];
                    ambulancestatus.value = "Ambulance is on the way!";

                    await ctrlr.saveRideId(rideId: R['rideId'].toString());
                    saveAmbulanceData(R);

                    EasyLoading.dismiss();

                    getDistanceAndRouteFromOSRM(
                      startLat: lat.value,
                      startLon: long.value,
                      endLat: R['latitude'],
                      endLon: R['longitude'],
                    );
                  } catch (e) {
                    log("Error in success():$e");
                    EasyLoading.dismiss();
                  }
                },
              );
            });

        Get.to(() => Home());
      } catch (e) {
        EasyLoading.dismiss();
        log("Error in registerEmergency() :$e");
        Fluttertoast.showToast(msg: "error in registerEmergency():$e");
      }
    } else {
      log("location :$location   isInrIDE:$isInrIDE");
    }
  }

  // Save
  Future<void> saveAmbulanceData(Map<String, dynamic> R) async {
    try {
      final box = Hive.box<AmbulanceData>('ambulanceBox');

      final data = AmbulanceData(
        ambulanceNumber: R['ambulance_number'] ?? '', //✅
        mediaId: R['id'] ?? '', //✅
        mobileNo: R['mobileNo'] ?? '', //✅
        etaMinutes: R['eta_minutes'], //✅
        driverLat: R['latitude'] ?? 0.0, //✅
        driverLong: R['longitude'] ?? 0.0, //✅
        rideId: R['rideId'] ?? '', //✅
        ambulanceStatus: 'Ambulance is on the way!', //✅
      );

      await box.put('current', data);
    } catch (e) {
      log('Error in saveAmbulanceData():$e');
    }
  }

  Future<void> loadAmbulanceData() async {
    try {
      log("loadAmbulanceData()");
      final box = Hive.box<AmbulanceData>('ambulanceBox');
      final data = box.get('current');

      log('box:${box.isOpen} data:$data');

      if (data != null) {
        ambulanceRegNumber.value = data.ambulanceNumber;
        mediaId.value = data.mediaId;
        mobNo.value = data.mobileNo;
        eta?.value = data.etaMinutes;
        rideId.value = data.rideId;
        ambulancestatus.value = data.ambulanceStatus;
        Get.to(() => Home());
      }
    } catch (e) {
      log("Error in loadAmbulanceData():$e");
    }
  }

  Future<void> deleteAmbulanceData() async {
    try {
      final box = Hive.box<AmbulanceData>('ambulanceBox');
      await box.delete('current');
      log("🚮 Deleted 'current' ambulance data from Hive");
    } catch (e) {
      log('Error in deleteAmbulanceData(): $e');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      log("error:$e");
    }
  }

  Future<void> getDistanceAndRouteFromOSRM({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
    String mode = 'driving', // or 'walking'
  }) async {
    try {
      // ✅ Validate coordinates
      if (!_isValidCoordinate(startLat) ||
          !_isValidCoordinate(startLon) ||
          !_isValidCoordinate(endLat) ||
          !_isValidCoordinate(endLon)) {
        log("❌ Invalid coordinates detected");
        throw Exception("Invalid coordinates provided.");
      }

      // ✅ Check if coordinates are the same
      if (startLat == endLat && startLon == endLon) {
        log("🟡 Start and end coordinates are the same. No route needed.");
        distancetoLocation.value = "0 m";
        eta?.value = "0 sec";
        routePoints.clear();
        return;
      }

      final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/$mode/'
        '$startLon,$startLat;$endLon,$endLat?overview=full&geometries=geojson',
      );

      log("OSRM url :$url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0];

        double distanceMeters = route['distance'].toDouble();
        double durationSeconds = route['duration'].toDouble();
        List coordinates = route['geometry']['coordinates'];

        routePoints.clear();
        for (var point in coordinates) {
          final lat = point[1] as double;
          final lon = point[0] as double;
          routePoints.add(latlng.LatLng(lat, lon));
        }

        log("✅ OSRM route updated: ${routePoints.length} points");

        // Distance formatting
        distancetoLocation.value = distanceMeters < 1000
            ? "${distanceMeters.toStringAsFixed(0)} m"
            : "${(distanceMeters / 1000).toStringAsFixed(2)} km";

        // Duration formatting
        String durationFormatted;
        if (durationSeconds < 60) {
          durationFormatted = "${durationSeconds.toStringAsFixed(0)} sec";
        } else if (durationSeconds < 3600) {
          durationFormatted =
              "${(durationSeconds / 60).toStringAsFixed(1)} min";
        } else {
          durationFormatted =
              "${(durationSeconds / 3600).toStringAsFixed(1)} hr";
        }

        eta?.value = durationFormatted;

        log(
          "Distance: ${distancetoLocation.value}, Duration: $durationFormatted",
        );
      } else {
        log("⚠️ OSRM failed with status: ${response.statusCode}");
        throw Exception("OSRM request failed");
      }
    } catch (e) {
      log("❌ Error in OSRM, trying GraphHopper: $e");

      // Fallback: GraphHopper
      try {
        final apiKey =
            fs.dotenv.env['graphHopperKey']; // Replace with your actual key
        final ghUrl = Uri.parse(
          'https://graphhopper.com/api/1/route?'
          'point=$startLat,$startLon&'
          'point=$endLat,$endLon&vehicle=car&locale=en&instructions=false&points_encoded=false&key=$apiKey',
        );

        log("graphHopperUrl:$ghUrl");

        final ghResponse = await http.get(ghUrl);

        if (ghResponse.statusCode == 200) {
          final data = json.decode(ghResponse.body);
          final path = data['paths'][0];

          double distanceMeters = path['distance'].toDouble();
          double durationSeconds = path['time'] / 1000.0;
          List coordinates = path['points']['coordinates'];

          routePoints.clear();
          for (var point in coordinates) {
            final lat = point[1] as double;
            final lon = point[0] as double;
            routePoints.add(latlng.LatLng(lat, lon));
          }

          distancetoLocation.value = distanceMeters < 1000
              ? "${distanceMeters.toStringAsFixed(0)} m"
              : "${(distanceMeters / 1000).toStringAsFixed(2)} km";

          String durationFormatted;
          if (durationSeconds < 60) {
            durationFormatted = "${durationSeconds.toStringAsFixed(0)} sec";
          } else if (durationSeconds < 3600) {
            durationFormatted =
                "${(durationSeconds / 60).toStringAsFixed(1)} min";
          } else {
            durationFormatted =
                "${(durationSeconds / 3600).toStringAsFixed(1)} hr";
          }

          eta?.value = durationFormatted;

          log("✅ GraphHopper fallback success: ${routePoints.length} points");
          log(
            "Distance: ${distancetoLocation.value}, Duration: $durationFormatted",
          );
        } else {
          throw Exception(
            "GraphHopper failed with status: ${ghResponse.statusCode}",
          );
        }
      } catch (ghError) {
        log("❌ GraphHopper fallback error: $ghError");
      }
    }
  }

  bool _isValidCoordinate(double value) {
    return value.isFinite && !value.isNaN;
  }
}
