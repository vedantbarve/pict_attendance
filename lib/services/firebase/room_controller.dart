import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';

import '../../models/room_model.dart';
import '../../models/student_model.dart';

class RoomController {
  Stream<QuerySnapshot<StudentModel>> getStudentsAsStream(String roomId) {
    final _firestore = FirebaseFirestore.instance;
    var data = _firestore
        .collection("rooms/$roomId/participants")
        .withConverter<StudentModel>(
          fromFirestore: (snapshot, _) {
            return StudentModel.fromMap(snapshot.data()!);
          },
          toFirestore: (model, _) {
            return model.toMap();
          },
        )
        .orderBy("rollNo")
        .snapshots();
    return data;
  }

  Future removeUser(String roomId) async {
    try {
      var ipAddress = IpAddress(type: RequestType.text);
      final ip = await ipAddress.getIpAddress();
      final _firestore = FirebaseFirestore.instance;
      await _firestore.doc("rooms/$roomId/participants/$ip").delete();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future addUserToRoom(
    String name,
    String rollNo,
    String ipAddress,
    String roomId,
  ) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore.doc("rooms/$roomId/participants/$ipAddress").set(
        {
          "name": name,
          "rollNo": rollNo,
        },
      );
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Stream<DocumentSnapshot<RoomModel>> getRoomDataAsStream(String roomId) {
    final _firestore = FirebaseFirestore.instance;
    var data = _firestore.doc("rooms/$roomId").withConverter<RoomModel>(
      fromFirestore: (snapshot, _) {
        return RoomModel.fromMap(snapshot.data()!);
      },
      toFirestore: (model, _) {
        return model.toMap();
      },
    ).snapshots();
    return data;
  }

  Future<RoomModel?> getRoomData(String roomId) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      var roomData = await _firestore.doc("rooms/$roomId").get();
      if (roomData.exists) {
        final data = roomData.data();
        return RoomModel.fromMap(data!);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
    return null;
  }
}
