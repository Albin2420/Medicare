import 'package:hive/hive.dart';

part 'ambulance_data.g.dart';

@HiveType(typeId: 0)
class AmbulanceData extends HiveObject {
  @HiveField(0)
  String ambulanceNumber;

  @HiveField(1)
  String mediaId;

  @HiveField(2)
  String mobileNo;

  @HiveField(3)
  String etaMinutes;

  @HiveField(4)
  double driverLat;

  @HiveField(5)
  double driverLong;

  @HiveField(6)
  int rideId;

  @HiveField(7)
  String ambulanceStatus;

  AmbulanceData({
    required this.ambulanceNumber,
    required this.mediaId,
    required this.mobileNo,
    required this.etaMinutes,
    required this.driverLat,
    required this.driverLong,
    required this.rideId,
    required this.ambulanceStatus,
  });
}
