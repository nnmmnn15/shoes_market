import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_market_app/view/orderstatus.dart';
import 'package:shoes_market_app/vm/database_handler.dart';

import '../model/purchase.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late DatabaseHandler handler;
  late List<String> state_purchase;
  late String dropdownValue;
  String customerName = '___';

  @override
  void initState() {
    super.initState();
    state_purchase = ['전체', '수령', '미수령'];
    dropdownValue = state_purchase[0];
    handler = DatabaseHandler();
    _loadCustomerName();
  }

Future<void> _loadCustomerName() async {
    final box = GetStorage();
    final dynamic userSeqDynamic = box.read('abcd_user_seq');  // GetStorage에서 고객 번호 읽기('abcd_user_seq'라는 키로 저장된 값)

    if (userSeqDynamic != null) {
      final int userSeq = userSeqDynamic is int ? userSeqDynamic : int.tryParse(userSeqDynamic.toString()) ?? 0;
      String? name = await handler.getCustomerNameBySeq(userSeq);
      setState(() {
        customerName = name ?? '___';
      });
    } else {
      setState(() {
        customerName = '___';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.yellow[700],
        title: const SizedBox(
          height: 70,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '$customerName의 구매내역',  //로그인 이름 들어가게
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButton<String>(
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    iconEnabledColor: Theme.of(context).colorScheme.secondary,
                    value: dropdownValue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: state_purchase.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(
                          state,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Purchase>>(
                future: _getPurchaseList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => Orderstatus(), arguments: [
                              snapshot.data![index].id,
                              snapshot.data![index].status,
                              snapshot.data![index].shopId,
                              snapshot.data![index].customerSeq,
                              snapshot.data![index].productId,
                              snapshot.data![index].productSize,
                              snapshot.data![index].purchaseDate,
                              snapshot.data![index].purchasePrice,
                              snapshot.data![index].quantity,
                            ])!.then((value) => reloadData());
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].productId, // 상품명
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${snapshot.data![index].productSize}', // 사이즈
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '색상: ${snapshot.data![index].productSize}', // 색상
                                      // //?????? DB product에서 가져와야함!!!!
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '수량: ${snapshot.data![index].quantity}', // 주문수량
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${snapshot.data![index].purchasePrice}', // 가격
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '구매: ${snapshot.data![index].purchaseDate}', // 구매일
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Purchase>> _getPurchaseList() {
    if (dropdownValue == '수령') {
      return handler.getReceivedPurchases();
    } else if (dropdownValue == '미수령') {
      return handler.getNotReceivedPurchases();
    } else {
      return handler.purchase_list(); // 전체 목록을 불러오는 메서드
    }
  }

  void reloadData() {
    setState(() {});
  }
}