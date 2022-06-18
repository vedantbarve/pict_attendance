import 'package:flutter/material.dart';

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
            borderSide: const BorderSide(color: Colors.grey),
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

class ErrorDialogue extends StatelessWidget {
  final String title;
  final String errorMessage;
  const ErrorDialogue({
    Key? key,
    required this.title,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      content: Text(errorMessage),
    );
  }
}
