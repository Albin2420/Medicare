// br_model2.dart

class BRModel2 {
  final int bloodRequestId;
  final String patientName;
  final String hospital;
  final String mobile;
  final DateTime requiredDate;
  final int noOfUnits;
  final String bloodType;
  final bool critical;

  BRModel2({
    required this.bloodRequestId,
    required this.patientName,
    required this.hospital,
    required this.mobile,
    required this.requiredDate,
    required this.noOfUnits,
    required this.bloodType,
    required this.critical,
  });

  // Convert JSON to BRModel2 object
  factory BRModel2.fromJson(Map<String, dynamic> json) {
    return BRModel2(
      bloodRequestId: json['blood_request_id'],
      patientName: json['patient_name'],
      hospital: json['hospital'],
      mobile: json['mobile'],
      requiredDate: DateTime.parse(json['required_date']),
      noOfUnits: json['no_of_units'],
      bloodType: json['blood_type'],
      critical: json['critical'],
    );
  }

  // Convert a list of JSON to list of BRModel2
  static List<BRModel2> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BRModel2.fromJson(json)).toList();
  }
}
