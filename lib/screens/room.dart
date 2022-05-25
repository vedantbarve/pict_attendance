import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pict_attendance/models/room_model.dart';
import 'package:pict_attendance/models/student_model.dart';
import 'package:pict_attendance/services/firebase/room_controller.dart';
import 'package:beamer/beamer.dart';

class RoomView extends StatefulWidget {
  final String roomId;
  const RoomView({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
    RoomController().removeUser(widget.roomId);
    context.beamToReplacementNamed('/');
  }

  @override
  void deactivate() {
    super.deactivate();
    RoomController().removeUser(widget.roomId);
    context.beamToReplacementNamed('/');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("Changed");
    switch (state) {
      case AppLifecycleState.detached:
        debugPrint("Detached");
        RoomController().removeUser(widget.roomId);
        context.beamToReplacementNamed('/');
        break;
      case AppLifecycleState.resumed:
        debugPrint("Resumed");
        break;
      case AppLifecycleState.inactive:
        debugPrint("Inactive");
        RoomController().removeUser(widget.roomId);
        context.beamToReplacementNamed('/');
        break;
      case AppLifecycleState.paused:
        debugPrint("Paused");
        RoomController().removeUser(widget.roomId);
        context.beamToReplacementNamed('/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RoomController().getRoomData(widget.roomId),
      builder: (context, AsyncSnapshot<RoomModel?> room) {
        if (room.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Room"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Are you sure you want to exit Room ${widget.roomId}?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              RoomController().removeUser(widget.roomId);
                              context.beamToReplacementNamed('/');
                            },
                            child: const Text("Confirm"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            body: StreamBuilder(
              stream: RoomController().readParticipants(room.data!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data as QuerySnapshot<StudentModel>;
                  return Column(
                    children: [
                      Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "Mentor Name :",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(room.data!.mentorName),
                          ),
                          ListTile(
                            title: const Text(
                              "Room Id :",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(room.data!.roomId),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.docs.length,
                          itemBuilder: (context, index) {
                            var participant = data.docs[index].data();
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
                              title: Text("${participant.name}"),
                              subtitle: Text("Roll No. ${participant.rollNo}"),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("Total Participants : ${data.docs.length}"),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
