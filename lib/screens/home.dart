import 'package:beamer/beamer.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:pict_attendance/global/dialogues.dart';
import 'package:pict_attendance/services/device/location_controller.dart';
import 'package:pict_attendance/services/device/preferences_controller.dart';
import 'package:pict_attendance/services/firebase/room_controller.dart';

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
    final name = await PrefsController().getName();
    final rollNo = await PrefsController().getRollNo();
    final ip = await Ipify.ipv4();
    if (name != null) _name.text = name;
    if (rollNo != null) _rollNo.text = rollNo;
    _ipAddress.text = ip;
  }

  @override
  Widget build(BuildContext context) {
    roomAction() async {
      if (_formKey.currentState!.validate()) {
        await PrefsController().setName(_name.text);
        await PrefsController().setRollNo(_rollNo.text);
        await PrefsController().setRegNo(_ipAddress.text);
        var roomData = await RoomController().getRoomData(_roomCode.text);
        if (roomData == null) {
          showDialog(
            context: context,
            builder: (context) {
              return CustomDialogue(
                content: "Room ${_roomCode.text} does not exist",
              );
            },
          );
          return;
        }
        var userLocation = await GetLocation().getUserLocation();
        print(userLocation);
        var distance = GetLocation().distance(
          userLocation!["latitude"],
          userLocation["longitude"],
          roomData.roomLat,
          roomData.roomLong,
        );
        if (distance! < 5000) {
          RoomController().addUserToRoom(
            _name.text,
            _rollNo.text,
            _ipAddress.text,
            _roomCode.text,
          );
          context.beamToNamed('/room/${roomData.roomId}');
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomDialogue(content: "User not in class");
            },
          );
        }
        print(distance);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PICT ATTENDANCE",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 200),
            NameField(name: _name),
            RollNoField(rollNo: _rollNo),
            IpAddressField(ipAddress: _ipAddress),
            const SizedBox(height: 50),
            RoomCodeField(roomCode: _roomCode),
            ElevatedButton(
              onPressed: roomAction,
              child: const Text('Enter room'),
            ),
          ],
        ),
      ),
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({
    Key? key,
    required TextEditingController name,
  })  : _name = name,
        super(key: key);

  final TextEditingController _name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: _name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is compulsory';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Name",
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class RollNoField extends StatelessWidget {
  const RollNoField({
    Key? key,
    required TextEditingController rollNo,
  })  : _rollNo = rollNo,
        super(key: key);

  final TextEditingController _rollNo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: _rollNo,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is compulsory';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Roll No.",
          hintText: "Roll No.",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class IpAddressField extends StatelessWidget {
  const IpAddressField({Key? key, required this.ipAddress}) : super(key: key);

  final TextEditingController ipAddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        enabled: false,
        controller: ipAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is compulsory';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Ip Address",
          hintText: "Ip Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class RoomCodeField extends StatelessWidget {
  const RoomCodeField({
    Key? key,
    required TextEditingController roomCode,
  })  : _roomCode = roomCode,
        super(key: key);

  final TextEditingController _roomCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: TextFormField(
        controller: _roomCode,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is compulsory';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Room Code",
          labelText: "Room Code",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
