import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:pict_attendance/models/room_model.dart';
import 'package:pict_attendance/models/student_model.dart';

class RoomController extends GetxController {
  String ipAddress = "";

  Stream readParticipants(RoomModel room) {
    final _firestore = FirebaseFirestore.instance;
    var data = _firestore
        .collection("rooms/${room.roomId}/participants")
        .withConverter<StudentModel>(
          fromFirestore: (snapshot, _) =>
              StudentModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        )
        .orderBy("rollNo")
        .snapshots();
    return data;
  }

  Future removeUser(String roomId) async {
    try {
      var ipAddress = IpAddress(type: RequestType.text);
      final ip = ipAddress.getIpAddress();
      final _firestore = FirebaseFirestore.instance;
      await _firestore.doc("rooms/$roomId/participants/$ip").delete();
    } catch (err) {
      print(err);
    }
  }

  Future addUserToRoom(
      String name, String rollNo, String regNo, String roomId) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore.collection("rooms/$roomId/participants").doc(regNo).set(
        {
          "name": name,
          "rollNo": rollNo,
        },
      );
    } catch (err) {
      print(err);
    }
  }

  Future<RoomModel?> getRoomData(String roomId) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      var roomData = await _firestore.collection("rooms").doc(roomId).get();
      if (roomData.exists) {
        final data = roomData.data();
        print(data);
        return RoomModel.fromMap(data!);
      }
    } catch (err) {
      print(err);
    }
    return null;
  }
}
