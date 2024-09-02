import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/view/login.dart';
import 'package:shoes_market_app/view/order.dart';
import 'package:shoes_market_app/vm/customer_handler.dart';
import 'package:get_storage/get_storage.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  late CustomerHandler handler;
  late List<dynamic> myInformation;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = CustomerHandler();
    myInformation = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                future: handler.queryCustomer(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          height: 130,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '이름: ${snapshot.data![0].name}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        '전화번호: ${snapshot.data![0].phone}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: SizedBox(
                            height: 200,
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    height: 70,
                                    width: 300,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.to(const Order(), arguments: 
                                          snapshot.data![0].name
                                        );
                                        //짜신 핸들러에 mySeq담아 보내서 쿼리하기
                                      },
                                      child: Text(
                                        '${snapshot.data![0].name}님의 구매내역',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border.symmetric(
                                            horizontal: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      height: 70,
                                      width: 300,
                                      child: TextButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: '로그아웃',
                                            middleText: '로그아웃 하시겠습니까?.',
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            barrierDismissible: false,
                                            actions: [
                                              // 취소버튼
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  Get.off(
                                                    () => const Login(),
                                                    // 스토리지 시퀀스 지우기
                                                  );
                                                },
                                                child: const Text('확인'),
                                              ),
                                            ],
                                          );
                                        },
                                        child: const Text(
                                          '로그아웃',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
