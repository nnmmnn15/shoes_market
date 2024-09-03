import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoes_market_app/view/register.dart';
import 'package:shoes_market_app/view/tabbar.dart';

import '../vm/database_handler.dart';

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
        title: const Text('로그인'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    SizedBox(width: 270, child: Image.asset('images/abcd.png')),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: '아이디를 입력하세요'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호를 입력하세요',
                  ),
                ),
              ),
              Column(
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
                          _showDialogPasswordOk();
                          idController.text = '';
                          passwordController.text = '';
                        } else {
                          errorSnackBar();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black),
                      child: const Text('로 그 인'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('아이디가 없다면?    '),
                          ElevatedButton(
                            onPressed: () => Get.to(const Register()),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('회원가입'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialogPasswordOk() async {
    //가입ok 환영창
    String name = await getName();
    Get.defaultDialog(
      title: '${name}고객님',
      middleText: '환영합니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.off(
              () => const Tabbar(),
            );
          },
          child: const Text('확인'),
        ),
      ],
    );
  }

  Future<String> getName() async {
    String customerName = await handler.getCustomerName(
        idController.text, // 사용자가 입력한 ID
        passwordController.text // 사용자가 입력한 비밀번호
        );
    return customerName; // 로그인 성공 시, 고객 이름을 표시
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
