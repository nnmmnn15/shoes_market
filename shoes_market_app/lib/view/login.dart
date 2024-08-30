import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_market_app/model/purchase.dart';
import 'package:shoes_market_app/view/register.dart';
import 'package:shoes_market_app/view/shoeslist.dart';

import '../vm/database_handler.dart';
import 'order.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late DatabaseHandler handler;
  late TextEditingController idController;
  late TextEditingController passwordController;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Container(child: Image.asset('images/abcd.png'), width: 270),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(labelText: '아이디를 입력하세요'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: '비밀번호를 입력하세요'),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        List<dynamic> checkList = await handler.checkCustomer(
                            idController.text, passwordController.text);
                        if (checkList[0] == 1) {
                          box.write('abcd_user_seq', checkList[1]);
                        print(checkList);
                        _showDialogPasswordOk();
                        // name();
                          // Get.to(
                          //   () => Shoeslist(),
                          // );
                          idController.text = '';
                          passwordController.text = '';
                        } else {
                          errorSnackBar();
                        }
                      },
                      child: Text('로 그 인'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('아이디가 없다면?    '),
                          ElevatedButton(
                            onPressed: () => Get.to(Register()),
                            child: Text('회원가입'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialogPasswordOk() async{
    //가입ok 환영창
    String name = await getName();
    print(name);
    Get.defaultDialog(
        
        title: '${name}고객님',
        middleText: '환영합니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.to(
              () => Shoeslist(),
              );
            },
            child: const Text('확인'),
          ),
        ],
      );
  }

Future<String> getName() async{
  String customerName = await handler.getCustomerName(
      idController.text, // 사용자가 입력한 ID
      passwordController.text // 사용자가 입력한 비밀번호
    );
    if (customerName == null) {
      return 'empty';
    }
  return customerName;// 로그인 성공 시, 고객 이름을 표시
}

  errorSnackBar() {
    Get.snackbar(
      '로그인 실패',
      '회원정보가 일치하지 않습니다',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.error,
      colorText: Theme.of(context).colorScheme.onError,
    );
  }
}
