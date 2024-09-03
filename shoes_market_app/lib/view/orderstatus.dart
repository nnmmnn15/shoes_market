import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/vm/purchase_handler.dart';

class Orderstatus extends StatefulWidget {
  const Orderstatus({super.key});

  @override
  State<Orderstatus> createState() => _OrderstatusState();
}

class _OrderstatusState extends State<Orderstatus> {
  late PurchaseHandler purchaseHandler;
  var purchaseId = Get.arguments ?? "__";
  // late List<String> productStatus;
  late String myLocation;

  @override
  void initState() {
    super.initState();
    purchaseHandler = PurchaseHandler();
    myLocation = '';
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('주문 상태',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
              FutureBuilder(
                future: purchaseHandler.queryPurchasedetail(purchaseId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myLocation = snapshot.data![0].location;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,10,10,0),
                          child: Row(
                            children: [
                              Text('[${snapshot.data![0].shopname}]',
                              style: const TextStyle(
                                fontSize: 22,
                          
                              ),),
                            ],
                          ),
                        ), //지점이름s
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [   
                                  Text('주문번호 ${snapshot.data![0].id}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),), //주문번호
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SizedBox(
                                          height: 100,
                                          child: Image.memory(
                                            snapshot.data![0].image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ), //상품이미지
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data![0].productname,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                          ), //상품명
                                          Text('사이즈 : ${snapshot.data![0].size}', style: const TextStyle(
                                            fontSize: 16,
                                          ),), //사이즈
                                          Text('색상 : ${snapshot.data![0].color}', style: const TextStyle(
                                            fontSize: 16,
                                          ),) //색상
                                        ],
                                      ) //상품명
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20,0,0,0),
                child: Row(
                  children: [
                    Text('상품 주문 상태',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              FutureBuilder(
                future: purchaseHandler.queryTransport(purchaseId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('접수          ',  style: TextStyle(
                                              fontSize: 18,
                                            ),
                                            ),
                                      snapshot.data!.isNotEmpty
                                          ? Text(snapshot
                                              .data![snapshot.data!.length - 1].date)
                                          : const Text('')
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,10,0,10),
                                    child: Row(
                                      children: [
                                        const Text('운송출발    ', style: TextStyle(
                                              fontSize: 18,
                                            ),),
                                        snapshot.data!.length >= 2
                                            ? Text(snapshot
                                                .data![snapshot.data!.length - 2].date)
                                            : const Text(''),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text('매장입고    ', style: TextStyle(
                                              fontSize: 18,
                                            ),),
                                      snapshot.data!.length >= 3
                                          ? Text(snapshot
                                              .data![snapshot.data!.length - 3].date)
                                          : const Text('')
                                    ],
                                  ),
                                 
                                ],
                              ),
                            ),
                          ),
                          snapshot.data!.length == 3 ? const Padding(
                            padding:  EdgeInsets.all(10),
                            child: Text('입고 완료 되었습니다.',
                            style: TextStyle(
                              fontSize: 20,
                            ),),
                          ) : const Text(''),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(70,20,20,20),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on),
                                Text(' $myLocation',
                                  style: const TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
