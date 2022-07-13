import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';

import 'package:get_ip_address/get_ip_address.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl_arm/screens/home/widgets.dart';
import '../../services/device/location_controller.dart';
import '../../services/device/preferences_controller.dart';
import '../../services/firebase/room_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _name = TextEditingController();
  final _rollNo = TextEditingController();
  final _roomCode = TextEditingController();
  final _ipAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    var ipAddress = IpAddress(type: RequestType.text);
    final name = await PrefsController().getName();
    final rollNo = await PrefsController().getRollNo();
    final ip = await ipAddress.getIpAddress();
    if (name != null) _name.text = name;
    if (rollNo != null) _rollNo.text = rollNo;
    _ipAddress.text = ip ?? "Something went wrong";
  }

  @override
  Widget build(BuildContext context) {
    roomAction() async {
      try {
        if (_formKey.currentState!.validate()) {
          await PrefsController().setName(_name.text);
          await PrefsController().setRollNo(_rollNo.text);
          await PrefsController().setRegNo(_ipAddress.text);
          var roomData = await RoomController().getRoomData(_roomCode.text);
          var userLocation = await GetLocation().getUserLocation();
          if (userLocation == null) {
            showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialogue(
                  title: 'Oops!',
                  errorMessage: 'There was some error fetching your location.',
                );
              },
            );
            return;
          }
          if (roomData == null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/lottie/notfound.gif",
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Room not Found!'),
                      ),
                    ],
                  ),
                );
              },
            );
            return;
          }

          var distance = GetLocation().distance(
            userLocation["latitude"],
            userLocation["longitude"],
            roomData.roomLat,
            roomData.roomLong,
          );

          if (distance! < roomData.radius) {
            if (roomData.isActive) {
              await RoomController().addUserToRoom(
                _name.text,
                _rollNo.text,
                _ipAddress.text,
                _roomCode.text,
              );
              context.beamToReplacementNamed('/room/${roomData.roomId}');
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/lottie/closed.gif",
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Looks like the room is closed'),
                        ),
                      ],
                    ),
                  );
                },
              );
              return;
            }
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    "Looks like you are outside the classroom ",
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/lottie/distance.gif",
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Distance = $distance \n Latitude =${userLocation["latitude"]} \n Longitude =${userLocation["longitude"]}',
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/lottie/notfound.gif",
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Oops unknown error occured'),
                  ),
                ],
              ),
            );
          },
        );
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            "PICT ATTENDANCE",
            style: TextStyle(
              fontFamily: 'Sofia',
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                NameField(name: _name),
                RollNoField(rollNo: _rollNo),
                IPAddressField(ipaddress: _ipAddress),
                const SizedBox(height: 30),
                RoomCodeField(roomCode: _roomCode),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: roomAction,
                  child: const Text('Enter room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
