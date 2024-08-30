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
        title: Text('회원가입'),
      ),
      body: Center(
        child: Container(
          width: 350,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 250,
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(labelText: '아이디'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => idSameCheck(idController.text.trim()),
                    child: Text('중복확인'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
              TextField(
                controller: passwordController1,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              TextField(
                controller: passwordController2,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: '연락처'),
              ),
              ElevatedButton(
                onPressed: () => joinClick(idController.text.trim()), //
                child: Text('회원가입'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

//---function---

  idSameCheck(String checkId) async {
    //a.아이디 중복 체크
    List<dynamic> checkList = await handler.idCheck(checkId);
    // print(checkList[0].runtimeType);
    print(checkList[0]);
    if (checkList[0] == 1) {
      _showDialogIdNo();
    } else {
      _showDialogIdOk();
    }
  }

  _showDialogIdNo() {
    //a-1 이미사용중인아이디
    Get.defaultDialog(
        title: '아이디 확인',
        middleText: '사용 불가한 아이디입니다.',
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

  _showDialogIdOk() {
    //a-2 사용가능한아이디
    Get.defaultDialog(
        title: '아이디 확인.',
        middleText: '사용 가능한 아이디입니다.',
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

  joinClick(String checkId) async {
    //b. 회원가입 버튼 클릭
    List<dynamic> checkList = await handler.idCheck(checkId);
    if (checkList[0] == 0) {
      _showDialogIdOk();
      if (passwordController1.text.trim() == passwordController2.text.trim()) {
        insertCustomer();
        _showDialogPasswordOk();
      } else {
        _showDialogPasswordNo();
      }
    } else {
      _showDialogIdNo();
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
              Get.back();
            },
            child: const Text('확인'),
          ),
        ]);
  }
}
