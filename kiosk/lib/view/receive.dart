import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk/vm/database_handler.dart';

class Receive extends StatefulWidget {
  const Receive({super.key});

  @override
  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  // Property
  final box = GetStorage();

  late DatabaseHandler handler;
  var receive = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: handler.getRecive(receive),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.memory(
                        snapshot.data![0].image,
                        width: 400,
                        height: 400,
                      ),
                      SizedBox(
                        width: 400,
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '주문번호',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              snapshot.data![0].id,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              '상품명',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              snapshot.data![0].name,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              '수량',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              snapshot.data![0].quantity.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              '사이즈',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              snapshot.data![0].size.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              '주문일자',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              snapshot.data![0].date,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      handler.insertReceiveStatus(receive);
                      Get.back();
                      Get.back();
                      box.remove('abcd_user_seq');
                    },
                    child: const Text('수령확인'),
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
    );
  }
}
