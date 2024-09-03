import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/vm/purchase_handler.dart';
import 'package:shoes_market_app/vm/shop_handler.dart';
import 'package:shoes_market_app/vm/transport_handler.dart';

class PurchaseDetail extends StatefulWidget {
  const PurchaseDetail({super.key});

  @override
  State<PurchaseDetail> createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  late ShopHandler shopHandler;
  late PurchaseHandler purchaseHandler;
  late TransportHandler transportHandler;
  late TextEditingController quantityController;
  late List<String> items;
  late String dropdownValue;
  late String imageName;
  late List<double> buttonBorder;
  late List<int> buttonText;
  late int currentSize;
  var value = Get.arguments ?? '__';
  late List<dynamic> shopId;
  late List<dynamic> shops;
  @override
  void initState() {
    super.initState();
    currentSize = 0;
    quantityController = TextEditingController();
    buttonBorder = [
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
      0.5,
    ];
    buttonText = [240, 245, 250, 255, 260, 265, 270, 275, 280];
    transportHandler = TransportHandler();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                  iconEnabledColor: Theme.of(context).colorScheme.secondary,
                  value: dropdownValue,
                  items: items.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            items,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      height: 180,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.memory(value[3]),
                          ],
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          value[1],
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '가격: ₩ ${value[2]}',
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[0],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(0);
                      },
                      child: Text(
                        buttonText[0].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[1],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(1);
                      },
                      child: Text(
                        buttonText[1].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[2],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(2);
                      },
                      child: Text(
                        buttonText[2].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[3],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(3);
                      },
                      child: Text(
                        buttonText[3].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[4],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(4);
                      },
                      child: Text(
                        buttonText[4].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[5],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(5);
                      },
                      child: Text(
                        buttonText[5].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[6],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(6);
                      },
                      child: Text(
                        buttonText[6].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[7],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(7);
                      },
                      child: Text(
                        buttonText[7].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.black,
                            width: buttonBorder[8],
                          ),
                          foregroundColor: Colors.black,
                          fixedSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        changeBorder(8);
                      },
                      child: Text(
                        buttonText[8].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('수량 :'),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: quantityController,
                        decoration:
                            const InputDecoration(labelText: '구매 수량을 입력하세요.'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        makePurchase();
                      },
                      child: const Text('구매'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  changeBorder(int index) {
    for (int i = 0; i < buttonBorder.length; i++) {
      buttonBorder[i] = 0.5;
    }
    buttonBorder[index] = 2.5;
    currentSize = buttonText[index];
    setState(() {});
  }

  makePurchase() {
    if (dropdownValue == '매장') {
      Get.defaultDialog(
          barrierDismissible: true,
          middleText: '매장을 선택해 주세요.',
          title: '매장 미선택',
          confirm:
              TextButton(onPressed: () => Get.back(), child: const Text('확인')));
    } else {
      Get.defaultDialog(
        barrierDismissible: true,
        middleText: '상품 구매가 완료되었습니다.',
        title: '구매완료',
        confirm: TextButton(
            onPressed: () async{
              (String, String, int, String, int, int) temp =
                  // product_id, shopname, size, purchasedate, purchaseprice, quantity
                (
                value[0],
                dropdownValue,
                currentSize,
                DateTime.now().toString().substring(0, 10),
                value[2],
                int.parse(quantityController.text.trim())
              );
              final int result = await purchaseHandler.insertPurchase(temp);
              if(result == 0){
                errorSnackBar();
              }
              final int transportresult = await transportHandler.insertTransport(temp);
              if(transportresult == 0){
                errorSnackBar();
              }
              Get.back();
            },
            child: const Text('확인')),
      );
    }
  }
   errorSnackBar() {
    Get.snackbar(
      '구매 실패',
      '구매에 실패 하였습니다다',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.error,
      colorText: Theme.of(context).colorScheme.onError,
    );
  }
}
