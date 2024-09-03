import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/model/transport.dart';
import 'package:shoes_market_app/vm/purchase_handler.dart';
import 'package:shoes_market_app/vm/transport_handler.dart';

class Orderstatus extends StatefulWidget {
  const Orderstatus({super.key});

  @override
  State<Orderstatus> createState() => _OrderstatusState();
}

class _OrderstatusState extends State<Orderstatus> {
  late PurchaseHandler purchaseHandler;
  var purchaseId = Get.arguments ?? "__";
  // late List<String> productStatus;

  @override
  void initState() {
    super.initState();
    purchaseHandler = PurchaseHandler();
    //   productStatus = [];
    //   addstatus();
  }

  // addstatus()async{
  //   List<Transport> temp = await purchaseHandler.queryTransport(purchaseId);
  //   if(temp.length == 1){
  //     return temp;
  //   }else if(temp.length == 2){
  //     return temp;
  //   }else{
  //     return
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.yellow[700],
        title: const SizedBox(
          height: 70,
          child: Padding(
            padding: EdgeInsets.fromLTRB(109, 0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'ABC',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'D',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'MART',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('주문 상태'),
            FutureBuilder(
              future: purchaseHandler.queryPurchasedetail(purchaseId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    child: Column(
                      children: [
                        Text('[${snapshot.data![0].shopname}]'), //지점이름
                        Text('주문번호 ${snapshot.data![0].id}'), //주문번호
                        Row(
                          children: [
                            Image.memory(
                              snapshot.data![0].image,
                              width: 200,
                            ), //상품이미지
                            Column(
                              children: [
                                Text(snapshot.data![0].productname), //상품명
                                Text('사이즈 : ${snapshot.data![0].size}'), //사이즈
                                Text('색상 : ${snapshot.data![0].color}') //색상
                              ],
                            ) //상품명
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Text('상품 주문 상태'),
            FutureBuilder(
              future: purchaseHandler.queryTransport(purchaseId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('접수    '),
                            snapshot.data!.length >= 1
                                ? Text(snapshot
                                    .data![snapshot.data!.length - 1].date)
                                : Text('')
                          ],
                        ),
                        Row(
                          children: [
                            Text('운송출발    '),
                            snapshot.data!.length >= 2
                                ? Text(snapshot
                                    .data![snapshot.data!.length - 1].date)
                                : Text(''),
                          ],
                        ),
                        Row(
                          children: [
                            Text('매장입고    '),
                            snapshot.data!.length >= 3
                                ? Text(snapshot
                                    .data![snapshot.data!.length - 1].date)
                                : Text('')
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
