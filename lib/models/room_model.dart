import 'dart:convert';

class RoomModel {
  dynamic roomId;
  dynamic mentorName;
  dynamic mentorId;
  dynamic roomLat;
  dynamic roomLong;
  dynamic participants;

  RoomModel({
    required this.roomId,
    required this.mentorName,
    required this.mentorId,
    required this.roomLat,
    required this.roomLong,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'mentorName': mentorName,
      'mentorId': mentorId,
      'roomLat': roomLat,
      'roomLong': roomLong,
      'participants': participants,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'],
      mentorName: map['mentorName'],
      mentorId: map['mentorId'],
      roomLat: map['roomLat'],
      roomLong: map['roomLong'],
      participants: map['participants'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
