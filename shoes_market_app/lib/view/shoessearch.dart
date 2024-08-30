import 'package:flutter/material.dart';
import 'package:shoes_market_app/vm/database_handler.dart';

class Shoessearch extends StatefulWidget {
  const Shoessearch({super.key});

  @override
  State<Shoessearch> createState() => _ShoessearchState();
}

class _ShoessearchState extends State<Shoessearch> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: 
      // Center(
      //   child: FutureBuilder(
      //     future: handler.queryAddress(), 
      //     builder: (context, snapshot) {
      //       if(snapshot.hasData){
      //         return ListView.builder(
      //           itemCount: snapshot.data!.length,
      //           itemBuilder: (context, index) {
      //             return Card(
      //               child: Text(snapshot.data![index].name),
      //             );
      //           },
      //         );
      //       }else{
      //         return const Center(
      //           child:  CircularProgressIndicator(),
      //         );
      //       }
      //     },
      //   ),
        
      // ),
    );
  }
}