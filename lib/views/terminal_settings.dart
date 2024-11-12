import 'package:flutter/material.dart';

class TerminalSettings extends StatelessWidget {
  const TerminalSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Scaffold(
        appBar: AppBar(),
      ),
    );
  }
}
