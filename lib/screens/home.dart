import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';

import 'package:get_ip_address/get_ip_address.dart';

import '../global/dialogues.dart';
import '../services/device/location_controller.dart';
import '../services/device/preferences_controller.dart';
import '../services/firebase/room_controller.dart';

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
      if (_formKey.currentState!.validate()) {
        await PrefsController().setName(_name.text);
        await PrefsController().setRollNo(_rollNo.text);
        await PrefsController().setRegNo(_ipAddress.text);
        var roomData = await RoomController().getRoomData(_roomCode.text);
        var userLocation = await GetLocation().getUserLocation();
        if (roomData == null) {
          debugPrint("Null room data guard clause");
          return;
        }
        if (userLocation == null) {
          debugPrint("Null user location guard clause");
          return;
        }
        var distance = GetLocation().distance(
          userLocation["latitude"],
          userLocation["longitude"],
          roomData.roomLat,
          roomData.roomLong,
        );
        if (distance! < 2000) {
          if (roomData.isActive) {
            RoomController().addUserToRoom(
              _name.text,
              _rollNo.text,
              _ipAddress.text,
              _roomCode.text,
            );
            context.beamToReplacementNamed('/room/${roomData.roomId}');
          } else {
            debugPrint("Closed room guard clause");
            return;
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const CustomDialogue(content: "User not in class");
            },
          );
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              NameField(name: _name),
              RollNoField(rollNo: _rollNo),
              IPAddressField(ipaddress: _ipAddress),
              const SizedBox(height: 50),
              RoomCodeField(roomCode: _roomCode),
              ElevatedButton(
                onPressed: roomAction,
                child: const Text('Enter room'),
              ),
            ],
          ),
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

class IPAddressField extends StatelessWidget {
  const IPAddressField({Key? key, required this.ipaddress}) : super(key: key);

  final TextEditingController ipaddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        enabled: false,
        controller: ipaddress,
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
