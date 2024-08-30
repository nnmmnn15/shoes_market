import 'package:flutter/material.dart';

class Shoeslist extends StatefulWidget {
  const Shoeslist({super.key});

  @override
  State<Shoeslist> createState() => _ShoeslistState();
}

class _ShoeslistState extends State<Shoeslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shoes list'),
      ),
    );
  }
}