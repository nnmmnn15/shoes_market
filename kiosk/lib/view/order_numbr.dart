import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk/view/receive.dart';
import 'package:kiosk/vm/database_handler.dart';

class OrderNumbr extends StatefulWidget {
  const OrderNumbr({super.key});

  @override
  State<OrderNumbr> createState() => _OrderNumbrState();
}

class _OrderNumbrState extends State<OrderNumbr> {
  // Property
  late TextEditingController numController;
  late DatabaseHandler handler;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    numController = TextEditingController();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'images/abcd.png',
              width: 300,
            ),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  TextField(
                    controller: numController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: '주문번호',
                    ),
                  ),
                ],
              ),
            ),
            // 키보드
            keyboard(),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      numController.text = '';
                      box.remove('abcd_user_seq');
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('로그아웃'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 주문번호, 유저 seq 확인
                      int result = await handler.checkRecive(
                          box.read('abcd_user_seq'), numController.text);
                      if (result == 1) {
                        Get.to(
                          () => const Receive(),
                          arguments: numController.text,
                        );
                      } else {
                        errorSnackBar();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('주문확인'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---Functions---
  keyboard() {
    return Column(
      children: [
        buildButtonRow(['1', '2', '3']),
        buildButtonRow(['4', '5', '6']),
        buildButtonRow(['7', '8', '9']),
        buildButtonRow(['모두\n지우기', '0', '지우기']),
      ],
    );
  }

  buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons.map(
        (e) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ElevatedButton(
              onPressed: () => buttonPressed(e),
              style: ElevatedButton.styleFrom(fixedSize: const Size(100, 80)),
              child: Text(
                e,
                style:
                    TextStyle(fontSize: e.length >= 2 && e != '10' ? 15 : 20),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  buttonPressed(String button) {
    if (button == '모두\n지우기') {
      numController.text = '';
    } else if (button == '지우기') {
      if (numController.text.isNotEmpty) {
        numController.text =
            numController.text.substring(0, numController.text.length - 1);
      }
    } else {
      numController.text += button;
    }
  }

  errorSnackBar() {
    Get.snackbar(
      '주문 확인 실패',
      '주문번호가 일치하지 않습니다',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2), // 애니메이션 시간
      backgroundColor: Theme.of(context).colorScheme.error,
      colorText: Theme.of(context).colorScheme.onError,
    );
  }
}
