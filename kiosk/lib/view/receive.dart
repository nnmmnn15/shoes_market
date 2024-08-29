import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Receive extends StatefulWidget {
  const Receive({super.key});

  @override
  State<Receive> createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  // Property
  final box = GetStorage();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/abcd.png'),
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
                        '12345',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '제품명',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '갯수',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '사이즈',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '구매일자',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
                box.remove('abcd_user_seq');
                // 디비 추가 수령으로
              },
              child: const Text('수령확인'),
            ),
          ],
        ),
      ),
    );
  }
}
