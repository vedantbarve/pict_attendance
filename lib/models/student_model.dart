import 'dart:convert';

class StudentModel {
  dynamic name;
  dynamic regNo;
  dynamic rollNo;
  dynamic latitude;
  dynamic longitude;
  dynamic altitude;

  StudentModel({
    required this.name,
    required this.regNo,
    required this.rollNo,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regNo': regNo,
      'rollNo': rollNo,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'],
      regNo: map['regNo'],
      rollNo: map['rollNo'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      altitude: map['altitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source));
}
