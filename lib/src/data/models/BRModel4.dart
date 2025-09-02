class BRModel4 {
  final int id;
  final String patientName;
  final String bloodType;
  final int noOfUnits;
  final String hospital;
  final DateTime requiredDate;

  BRModel4({
    required this.id,
    required this.patientName,
    required this.bloodType,
    required this.noOfUnits,
    required this.hospital,
    required this.requiredDate,
  });

  factory BRModel4.fromJson(Map<String, dynamic> json) {
    return BRModel4(
      id: json['id'],
      patientName: json['patient_name'],
      bloodType: json['blood_type'],
      noOfUnits: json['no_of_units'],
      hospital: json['hospital'],
      requiredDate: DateTime.parse(json['required_date']),
    );
  }

  static List<BRModel4> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BRModel4.fromJson(json)).toList();
  }
}
