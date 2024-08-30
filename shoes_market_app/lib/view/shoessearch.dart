import 'package:flutter/material.dart';
import 'package:shoes_market_app/vm/database_handler.dart';

class Shoessearch extends StatefulWidget {
  const Shoessearch({super.key});

  @override
  State<Shoessearch> createState() => _ShoessearchState();
}

class _ShoessearchState extends State<Shoessearch> {
  late DatabaseHandler handler;
  late TextEditingController controller;
  late bool search;

  @override
  void initState() {
    super.initState();
    search = false;
    handler = DatabaseHandler();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 360,
                  child: SizedBox(
                    height: 55,
                    width: 360,
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(
                        color: Color(0xff020202),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xfff1f1f1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "검색할 제품 명을 입력하세요.",
                          hintStyle: const TextStyle(
                              color: Color(0xffb2b2b2),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                              decorationThickness: 6),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                search = true;
                                setState(() {});
                                print('tap');
                              },
                              child: const Icon(Icons.search_outlined))),
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: handler.searchProduct(controller.text.trim()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {    
                return !search
                ?const Expanded(child: Center(child: Text('제품 명 을 입력하세요.'),))
                :snapshot.data!.isEmpty
                ?const Expanded(child: Center(child: Text('제품 명 을 입력하세요.'),))
                :
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: SizedBox(
                    height: 500,
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 105,
                              color: Colors.grey[200],
                              child: GestureDetector(
                                onTap: () {},
                                child: Card(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 80,
                                          child: Image.memory(
                                              snapshot.data![index].image)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data![index].name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('₩ ${snapshot.data![index].price}'),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                );
              } else {
                if (search == true) {
                  return const Center(
                    child: Text('찾으시는 제품이 없습니다.'),
                  );
                } else {
                  return const Center(
                    child: Text('제품을 검색해주세요.'),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
