// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmbulanceDataAdapter extends TypeAdapter<AmbulanceData> {
  @override
  final int typeId = 0;

  @override
  AmbulanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmbulanceData(
      ambulanceNumber: fields[0] as String,
      mediaId: fields[1] as String,
      mobileNo: fields[2] as String,
      etaMinutes: fields[3] as String,
      driverLat: fields[4] as double,
      driverLong: fields[5] as double,
      rideId: fields[6] as int,
      ambulanceStatus: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AmbulanceData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.ambulanceNumber)
      ..writeByte(1)
      ..write(obj.mediaId)
      ..writeByte(2)
      ..write(obj.mobileNo)
      ..writeByte(3)
      ..write(obj.etaMinutes)
      ..writeByte(4)
      ..write(obj.driverLat)
      ..writeByte(5)
      ..write(obj.driverLong)
      ..writeByte(6)
      ..write(obj.rideId)
      ..writeByte(7)
      ..write(obj.ambulanceStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmbulanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
