// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import '../models/room_model.dart';
import '../models/student_model.dart';
import '../services/firebase/room_controller.dart';

class RoomView extends StatefulWidget {
  final String roomId;
  const RoomView({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  late RoomModel roomData;
  late List<StudentModel> students;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder2(
        streams: Tuple2(
          RoomController().getRoomDataAsStream(widget.roomId),
          RoomController().getStudentsAsStream(widget.roomId),
        ),
        builder: (context, snapshots) {
          if (!snapshots.item1.hasData || !snapshots.item2.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.item1.hasData && snapshots.item2.hasData) {
            var data1 = snapshots.item1.data as DocumentSnapshot<RoomModel>;
            var data2 = snapshots.item2.data as QuerySnapshot<StudentModel>;
            roomData = data1.data()!;
            students = data2.docs.map((student) => student.data()).toList();
          }
          if (roomData.isActive == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Room Closed'),
                  );
                },
              ).then((value) => context.beamToReplacementNamed('/'));
            });
          }
          return Column(
            children: [
              ListTile(
                title: const Text('Mentor name :'),
                subtitle: Text(roomData.mentorName),
              ),
              ListTile(
                title: const Text('Subject :'),
                subtitle: Text(roomData.subject),
              ),
              const Text(
                'List of students ',
                style: TextStyle(fontSize: 26),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://avatars.dicebear.com/api/human/:$index.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      title: Text("${students[index].name}"),
                      subtitle: Text("Roll No. ${students[index].rollNo}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
