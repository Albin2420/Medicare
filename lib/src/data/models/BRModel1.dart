// use this section for models in the app
class BRModel1 {
  final int id;
  final String name;
  final String bloodType;
  final String mobile;
  final String landmark;
  final String address; // e.g., "Periyar Nagar, Aluva, Kerala, 683101"

  BRModel1({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.mobile,
    required this.landmark,
    required this.address,
  });

  factory BRModel1.fromJson(Map<String, dynamic> json) {
    return BRModel1(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      bloodType: json['blood_type'] ?? '',
      mobile: json['mobile'] ?? '',
      landmark: json['landmark'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'blood_type': bloodType,
      'mobile': mobile,
      'landmark': landmark,
      'address': address,
    };
  }

  /// Parse a list of donors from a JSON array
  static List<BRModel1> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BRModel1.fromJson(json)).toList();
  }

  /// Convert list of donors to JSON array
  static List<Map<String, dynamic>> listToJson(List<BRModel1> donors) {
    return donors.map((donor) => donor.toJson()).toList();
  }
}
