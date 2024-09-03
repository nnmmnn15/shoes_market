import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/model/customer.dart';
import '../vm/database_handler.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late DatabaseHandler handler;
  late TextEditingController idController;
  late TextEditingController passwordController1;
  late TextEditingController passwordController2;
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    idController = TextEditingController();
    passwordController1 = TextEditingController();
    passwordController2 = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: TextField(
                          controller: idController,
                          decoration: const InputDecoration(labelText: '아이디'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () => idSameCheck(idController.text.trim()),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white),
                        child: const Text('중복확인'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: passwordController1,
                      decoration: const InputDecoration(labelText: '비밀번호'),
                      obscureText: true //비번 ****
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: passwordController2,
                      decoration: const InputDecoration(labelText: '비밀번호 확인'),
                      obscureText: true //비번 ****
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: '이름'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: '연락처'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => joinClick(idController.text.trim()), //
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black),
                    child: const Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//---function---

  idSameCheck(String checkId) async {
    if (checkId.isEmpty) {
      _showDialogCheck('아이디 확인', '아이디를 입력해주세요.');
    } else {
      //a.아이디 중복 체크
      List<dynamic> checkList = await handler.idCheck(checkId);
      // print(checkList[0].runtimeType);
      if (checkList[0] == 1) {
        _showDialogCheck('아이디 확인', '사용 불가한 아이디입니다.');
      } else {
        _showDialogCheck('아이디 확인', '사용 가능한 아이디입니다.');
      }
    }
  }

  // String 으로 체크
  _showDialogCheck(String title, String middleText) {
    //a-1 이미사용중인아이디
    Get.defaultDialog(
        title: title,
        middleText: middleText, //'사용 불가한 아이디입니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('확인'),
          )
        ]);
  }

  // _showDialogIdOk(bool check) {
  //   //a-2 사용가능한아이디
  //   Get.defaultDialog(
  //       title: '아이디 확인.',
  //       middleText: check ? '사용 불가한 아이디입니다.' : '사용 가능한 아이디입니다.',
  //       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  //       barrierDismissible: false,
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Get.back();
  //           },
  //           child: const Text('확인'),
  //         )
  //       ]);
  // }

  joinClick(String checkId) async {
    //b. 회원가입 버튼 클릭
    if (idController.text.trim().isEmpty ||
        passwordController1.text.trim().isEmpty ||
        passwordController2.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      _showDialogCheck('경고', '빈칸을 채워주세요');
    } else {
      List<dynamic> checkList = await handler.idCheck(checkId);
      if (checkList[0] == 0) {
        if (passwordController1.text.trim() ==
            passwordController2.text.trim()) {
          insertCustomer();
          _showDialogPasswordOk();
        } else {
          _showDialogPasswordNo();
        }
      } else {
        _showDialogCheck('아이디 확인', '사용 불가한 아이디입니다.');
      }
    }
  }

  Future insertCustomer() async {
    //b-1 가입정보 DB에 전송
    var insert = Customer(
      id: idController.text.trim(),
      password: passwordController1.text.trim(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    int result = await handler.joinCustomer(insert);
    if (result != 0) {}
  }

  _showDialogPasswordOk() {
    //가입ok 환영창
    Get.defaultDialog(
      title: '환영합니다.',
      middleText: '회원가입이 완료되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
            Get.back();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }

  _showDialogPasswordNo() {
    //가입불가 확인창
    Get.defaultDialog(
        title: '경고.',
        middleText: '비밀번호를 확인해주세요.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('확인'),
          ),
        ]);
  }
}
