import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicare/src/app.dart';
import 'package:medicare/src/data/services/hive_services/rideDetails/ambulance_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(AmbulanceDataAdapter());
  await Hive.openBox<AmbulanceData>('ambulanceBox');

  runApp(MyApp());
}
