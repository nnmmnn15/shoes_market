import 'package:flutter/material.dart';
import 'package:shose_web/vm/database_handler.dart';

class SalesGrape extends StatefulWidget {
  const SalesGrape({super.key});

  @override
  State<SalesGrape> createState() => _SalesGrapeState();
}

class _SalesGrapeState extends State<SalesGrape> {
  late DatabaseHandler handler;
  // late List<> data;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: handler.queryPurchase(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return SizedBox(
              width: 1500,
              height: 800,
              child: Column(
                children: [
                  Text('목록'),
                  Text('날짜별'),
                ],
              ),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}