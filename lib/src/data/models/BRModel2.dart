class BRModel2 {
  final String userName;
  final String mobile;
  final DateTime requiredDate;
  final String location;
  final int noOfUnits;
  final String bloodType;
  final bool critical;

  BRModel2({
    required this.userName,
    required this.mobile,
    required this.requiredDate,
    required this.location,
    required this.noOfUnits,
    required this.bloodType,
    required this.critical,
  });

  factory BRModel2.fromJson(Map<String, dynamic> json) {
    return BRModel2(
      userName: json['user_name'] ?? '',
      mobile: json['mobile'] ?? '',
      requiredDate: DateTime.parse(json['required_date']),
      location: json['location'] ?? '',
      noOfUnits: json['no_of_units'] ?? 0,
      bloodType: json['blood_type'] ?? '',
      critical: json['critical'] ?? false,
    );
  }
}
