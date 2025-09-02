class BRModel3 {
  final String bloodType;
  final int count;
  final String location;

  BRModel3({
    required this.bloodType,
    required this.count,
    required this.location,
  });

  // Factory method to create an instance from JSON/map
  factory BRModel3.fromJson(Map<String, dynamic> json) {
    return BRModel3(
      bloodType: json['blood_type'],
      count: json['count'],
      location: json['location'],
    );
  }

  // Method to parse a list of JSON objects into a list of BRModel3
  static List<BRModel3> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BRModel3.fromJson(json)).toList();
  }
}
