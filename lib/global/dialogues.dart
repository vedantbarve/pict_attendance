import 'package:flutter/material.dart';

class CustomDialogue extends StatelessWidget {
  final String content;
  const CustomDialogue({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(content),
    );
  }
}
