import 'package:flutter/material.dart';

class CurrentSituation extends StatefulWidget {
  const CurrentSituation({super.key});

  @override
  State<CurrentSituation> createState() => _CurrentSituationState();
}

class _CurrentSituationState extends State<CurrentSituation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABCD 마켓',
          style: TextStyle(
            backgroundColor: Colors.black,
          ),),
      ),
    );
  }
}