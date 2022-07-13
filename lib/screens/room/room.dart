// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../models/student_model.dart';
import '../../services/firebase/room_controller.dart';

class RoomView extends StatefulWidget {
  final String roomId;
  const RoomView({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  RoomModel? roomData;
  List<StudentModel>? students;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: RoomController().getRoomDataAsStream(widget.roomId),
        builder:
            (context, AsyncSnapshot<DocumentSnapshot<RoomModel>?> snapshot1) {
          return StreamBuilder(
            stream: RoomController().getStudentsAsStream(widget.roomId),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<StudentModel>?> snapshot2) {
              if (!snapshot1.hasData || !snapshot2.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot1.hasData && snapshot2.hasData) {
                roomData = snapshot1.data!.data()!;
                students = snapshot2.data!.docs
                    .map((student) => student.data())
                    .toList();
              }

              if (snapshot1.data!.data()!.isActive == false) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/lottie/success.gif",
                      height: 200,
                      width: 200,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.beamToReplacementNamed('/');
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      label: const Text("Go back home"),
                    ),
                  ],
                ));
              }

              return Column(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() => expanded = !expanded);
                    },
                    elevation: 0,
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: expanded,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: const Text('Room Code:'),
                            subtitle: Text(roomData!.roomId),
                          );
                        },
                        body: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: const [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text('Mentor name :'),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text('Subject :'),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(roomData!.mentorName),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(roomData!.subject),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: const [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text('Total students :'),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text('Division & Batch :'),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(students!.length.toString()),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "${roomData!.division} (Batch :${roomData!.batch})",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Text(
                    'List of students ',
                    style: TextStyle(fontSize: 26),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: students!.length,
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
                          title: Text("${students![index].name}"),
                          subtitle: Text("Roll No. ${students![index].rollNo}"),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
