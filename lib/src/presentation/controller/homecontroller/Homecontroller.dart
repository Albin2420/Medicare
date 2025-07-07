// controllers are use in this folder

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/semantics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlng;
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
  RxString bookingId = RxString("");
  RxString mobNo = RxString("");
  RxString? eta = RxString("");
  RxString name = RxString("");
  RxDouble driverLat = RxDouble(0);
  RxDouble driverLong = RxDouble(0);

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

  @override
  void onInit() async {
    super.onInit();
    log("Home controller initialized");
    startListeningToLocation();
    accessToken.value = (await ctrlr.getAccessToken())!;
    connect(id: 2);
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
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          log("denied forever");
          deniedforver.value = true;
          return;
        }
      }

      // Start listening to the position stream
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20, // meters (minimum distance before update)
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
    }
  }

  void connect({required int id}) {
    try {
      final uri = Uri.parse('ws://13.203.89.173:8001/ws/user/$id');

      channel = WebSocketChannel.connect(uri);
      log('🔌 Connecting to $uri');

      channel!.stream.listen(
        (data) async {
          try {
            log("from server:$data");
            final decoded = jsonDecode(data);
            driverLat.value = decoded['latitude'];
            driverLong.value = decoded['longitude'];

            checkAndRemoveReachedPoint(
              decoded['latitude'],
              decoded['longitude'],
            );
          } catch (e) {
            log("inside data:$e");
          }
        },
        onDone: () {
          log('❌ Connection closed.');
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

  void checkAndRemoveReachedPoint(double currentLat, double currentLng) {
    if (routePoints.isNotEmpty) {
      final driverPosition = latlng.LatLng(currentLat, currentLng);
      final nextPoint = routePoints.first;

      log("on Target ======>>>>>> $nextPoint");

      final distance = const latlng.Distance().as(
        latlng.LengthUnit.Meter,
        driverPosition,
        nextPoint,
      );

      log("dis:$distance");

      if (distance < 20) {
        log(
          "🚗 Reached waypoint: ${nextPoint.latitude}, ${nextPoint.longitude} (Dist: ${distance.toStringAsFixed(2)}m)",
        );
        routePoints.removeAt(0);
      } else {
        log("too far");
      }
    } else {
      log("points empty");
    }
  }

  void registerEmergency() async {
    if (accessToken.value != "initial" &&
        accessToken.value != "" &&
        location.value != "initial") {
      try {
        EasyLoading.show();
        final res = await lcrepo.location(
          longitude: long.value,
          latitude: lat.value,
          landmark: location.value,
          accesstoken: accessToken.value,
        );
        res.fold(
          (l) {
            EasyLoading.dismiss();
            log("failed");
          },
          (R) {
            EasyLoading.dismiss();
            ambulanceRegNumber.value = R["ambulance_number"];
            bookingId.value = R["id"];
            mobNo.value = R["mobileNo"];
            eta?.value = R["eta_minutes"];
            driverLat.value = R['latitude'];
            driverLong.value = R['longitude'];

            ambulancestatus.value = "Ambulance is on the way!";

            getDistanceAndRouteFromOSRM(
              startLat: lat.value,
              startLon: long.value,
              endLat: R['latitude'],
              endLon: R['longitude'],
            );
          },
        );
        Get.to(() => Home());
      } catch (e) {
        EasyLoading.dismiss();
        log("Error in registerEmergency() :$e");
        Fluttertoast.showToast(msg: "error in registerEmergency():$e");
      }
    } else {
      log("location :$location");
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
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

      final response = await http.get(url);

      log("response :${response.body}");

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
        throw Exception(
          '❌ Failed to get route from OSRM: ${response.statusCode}',
        );
      }
    } catch (e) {
      log("❌ Error in getDistanceAndRouteFromOSRM(): $e");
    }
  }

  bool _isValidCoordinate(double value) {
    return value.isFinite && !value.isNaN;
  }
}
