import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/view/orderstatus.dart';
import 'package:shoes_market_app/vm/purchase_handler.dart';
import 'package:shoes_market_app/vm/shop_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get_storage/get_storage.dart';
import '../model/purchase_order.dart';


class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late ShopHandler shopHandler;
  late PurchaseHandler purchaseHandler;
  late TextEditingController quantityController;
  late List<String> items;
  late String dropdownValue;
  late String imageName;
  late List<int> buttonText;
  late int currentSize;
  var value = Get.arguments ?? '__';
  late List<dynamic> shopId;
  late List<dynamic> shops;

  @override
  void initState() {
    super.initState();
    purchaseHandler = PurchaseHandler();
    shopHandler = ShopHandler();
    shopId = [];
    shops = [];
    items = [
      '매장',
    ];
    getShop();
    dropdownValue = '매장';
  }

  getShop() async {
    shops = await shopHandler.queryShop();
    for (int i = 0; i < shops.length; i++) {
      items.add(shops[i]['name']);
      shopId.add(shops[i]['id']);
    }
    setState(() {});
  }

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
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('$value님의 구매내역')),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  iconEnabledColor: Theme.of(context).colorScheme.secondary,
                  value: dropdownValue,
                  items: items.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ));
                  }).toList(),
                  onChanged: (value) {
                    dropdownValue = value!;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            // width: 500,
            // height: 500,
            child: FutureBuilder(
              future: purchaseHandler.queryPurchase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const Orderstatus(),
                              arguments: snapshot.data![index].id
                            );
                          },
                          child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text('${snapshot.data![index].productname.toString()}'),
                                          Text('Size : ${snapshot.data![index].size.toString()}'),
                                          Text('색상 : ${snapshot.data![index].color}'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text('수량 : ${snapshot.data![index].quantity.toString()}'),
                                          Text('가격 : ${snapshot.data![index].price.toString()}'),
                                          Text('구매일자 : ${snapshot.data![index].date}')
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text(snapshot.data![index].shopname),
                                          Text(snapshot.data![index].status),
                                          const Text(''),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void reloadData() {
    setState(() {});
  }
}


