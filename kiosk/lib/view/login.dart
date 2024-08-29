import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kiosk/view/order_numbr.dart';
import 'package:kiosk/vm/database_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  late TextEditingController idController;
  late TextEditingController pwController;
  late FocusNode idFocus;
  late FocusNode pwFocus;

  late int controllerNum;
  late bool upperLower; // 대문자 true
  late bool specialChar; // 특수문자 키보드 = true,

  late DatabaseHandler handler;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
    idFocus = FocusNode();
    pwFocus = FocusNode();
    controllerNum = 0;
    upperLower = false;
    specialChar = false;
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controllerNum = 0;
        setState(() {});
      },
      child: Scaffold(
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
                    Stack(
                      children: [
                        TextField(
                          controller: idController,
                          focusNode: idFocus,
                          decoration: const InputDecoration(
                            labelText: '아이디',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(idFocus);
                            controllerNum = 1;
                            setState(() {});
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            width: 300,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        TextField(
                          controller: pwController,
                          focusNode: pwFocus,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: '비밀번호',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(pwFocus);
                            controllerNum = 2;
                            setState(() {});
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            width: 300,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              List<dynamic> checkList = await handler.checkCustomer(
                                  idController.text, pwController.text);
                              if (checkList[0] == 1) {
                                box.write('abcd_user_seq', checkList[1]);
                                Get.to(
                                  () => const OrderNumbr(),
                                );
                                idController.text = '';
                                pwController.text = '';
                              } else {
                                errorSnackBar();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(90, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSecondary),
                            child: const Text('로그인'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 키보드
              keyboard(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  keyboard() {
    return Column(
      children: [
        buildButtonRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']),
        specialChar
            ? buildButtonRow(
                ['-', '/', ':', ';', '(', ')', '/', '&', '@', '"', "'"])
            : upperLower
                ? buildButtonRow(
                    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'])
                : buildButtonRow(
                    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),
        specialChar
            ? buildButtonRow([
                '[',
                ']',
                '{',
                '}',
                '#',
                '%',
                '^',
                '*',
                '+',
                '=',
                '!'
              ]) // 특수 문자 일때
            : upperLower
                ? buildButtonRow([
                    '대/소',
                    'A',
                    'S',
                    'D',
                    'F',
                    'G',
                    'H',
                    'J',
                    'K',
                    'L'
                  ]) // 대문자 일때
                : buildButtonRow([
                    '대/소',
                    'a',
                    's',
                    'd',
                    'f',
                    'g',
                    'h',
                    'j',
                    'k',
                    'l'
                  ]), // 소문자 일때
        specialChar
            ? buildButtonRow([
                '문자',
                '_',
                '\\',
                '~',
                '<',
                '>',
                '\$',
                '.',
                ',',
                '?',
                'del'
              ]) // 특수 문자 일때
            : upperLower
                ? buildButtonRow(
                    ['특수', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'del']) // 대문자 일때
                : buildButtonRow(
                    ['특수', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'del']), // 소문자 일때
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
              style: ElevatedButton.styleFrom(fixedSize: const Size(80, 60)),
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
    if (controllerNum == 1) {
      if (button == 'del') {
        if (idController.text.isNotEmpty) {
          idController.text =
              idController.text.substring(0, idController.text.length - 1);
        }
      } else if (button == '대/소') {
        upperLower = !upperLower;
        setState(() {});
      } else if (button == '특수') {
        specialChar = !specialChar;
        setState(() {});
      } else if (button == '문자') {
        specialChar = !specialChar;
        upperLower = false;
        setState(() {});
      } else {
        idController.text += button;
      }
    } else if (controllerNum == 2) {
      if (button == 'del') {
        if (pwController.text.isNotEmpty) {
          pwController.text =
              pwController.text.substring(0, pwController.text.length - 1);
        }
      } else if (button == '대/소') {
        upperLower = !upperLower;
        setState(() {});
      } else if (button == '특수') {
        specialChar = !specialChar;
        setState(() {});
      } else if (button == '문자') {
        specialChar = !specialChar;
        upperLower = false;
        setState(() {});
      } else {
        pwController.text += button;
      }
    } else {
      if (button == '대/소') {
        upperLower = !upperLower;
        setState(() {});
      } else if (button == '특수') {
        specialChar = !specialChar;
        setState(() {});
      } else if (button == '문자') {
        specialChar = !specialChar;
        upperLower = false;
        setState(() {});
      }
      setState(() {});
    }
  }

  errorSnackBar() {
    Get.snackbar(
      '로그인 실패',
      '회원정보가 일치하지 않습니다',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2), // 애니메이션 시간
      backgroundColor: Theme.of(context).colorScheme.error,
      colorText: Theme.of(context).colorScheme.onError,
    );
  }
}
