import 'dart:convert';

class RoomModel {
  dynamic roomId;
  dynamic mentorName;
  dynamic mentorId;
  dynamic roomLat;
  dynamic roomLong;
  dynamic roomLimit;
  dynamic subject;
  dynamic isActive;

  RoomModel({
    required this.roomId,
    required this.mentorName,
    required this.mentorId,
    required this.roomLat,
    required this.roomLong,
    this.roomLimit,
    this.subject,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'mentorName': mentorName,
      'mentorId': mentorId,
      'roomLat': roomLat,
      'roomLong': roomLong,
      'roomLimit': roomLimit,
      'isActive': isActive,
      'subject': subject,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'],
      mentorName: map['mentorName'],
      mentorId: map['mentorId'],
      roomLat: map['roomLat'],
      roomLong: map['roomLong'],
      roomLimit: map['roomLimit'],
      isActive: map['isActive'] as bool,
      subject: map['subject'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
