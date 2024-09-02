import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_market_app/view/purchase_detail.dart';
import 'package:shoes_market_app/vm/database_handler.dart';

class Shoeslist extends StatefulWidget {
  const Shoeslist({super.key});

  @override
  State<Shoeslist> createState() => _ShoeslistState();
}

class _ShoeslistState extends State<Shoeslist> {
  late String keyword;
  late DatabaseHandler handler;
  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    keyword = '전체';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          children: [
            Flexible(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          keyword = '전체';
                          setState(() {});
                        },
                        child: const Text('전체')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            keyword = '나이키';
                            setState(() {});
                          },
                          child: const Text('나이키')),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 70,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          keyword = '아디다스';
                          setState(() {});
                        },
                        child: const Text('아디다스')),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            keyword = '뉴발란스';
                            setState(() {});
                          },
                          child: const Text('뉴발란스')),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 70,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          keyword = '아식스';
                          setState(() {});
                        },
                        child: const Text('아식스')),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,50,20,20),
              child: SingleChildScrollView(
                child: Center(
                  child: FutureBuilder(
                    future: keyword =='전체'?
                    handler.queryProduct()
                    :handler.searchProduct(keyword.trim()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.isEmpty
                        ? const Text('상품이 없습니다.')
                        :
                        SizedBox(
                          height: 550,
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
                                      onTap: () {
                                        Get.to(const PurchaseDetail(), 
                                          arguments: [
                                            snapshot.data![index].id,
                                            snapshot.data![index].name,
                                            snapshot.data![index].price,
                                            snapshot.data![index].image,
                                          ]
                                        );
                                      },
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
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text('₩ ${snapshot.data![index].price}'),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              Text('데이터 로딩중')
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
