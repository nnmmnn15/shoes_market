import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Orderstatus extends StatefulWidget {
  const Orderstatus({super.key});

  @override
  State<Orderstatus> createState() => _OrderstatusState();
}

class _OrderstatusState extends State<Orderstatus> {
  var purchaseId = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/abcd.png'),
        backgroundColor: Color.fromARGB(255, 242, 179, 6),
      ),
      
    );
  }
}