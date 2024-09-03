import 'package:flutter/material.dart';
import 'package:shoes_market_app/view/mypage.dart';
import 'package:shoes_market_app/view/shoeslist.dart';
import 'package:shoes_market_app/view/shoessearch.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // 메모리에서 제거
    controller.dispose(); //순서에 주의
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.yellow[700],
        title: const SizedBox(
          height: 70,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ABC',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'D',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MART',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: TabBarView(
        
        controller: controller,
        children: const [Shoeslist(), Shoessearch(), Mypage()],
      ),
      bottomNavigationBar: Container(
        color: Colors.amberAccent,
        height: 80,
        child: TabBar(
          isScrollable: false,
          controller: controller,
          labelPadding: EdgeInsets.zero,
          indicatorColor: Colors.red,
          indicatorWeight: 3,
          overlayColor: const WidgetStatePropertyAll(Colors.red),
          splashBorderRadius: BorderRadius.circular(20),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: RectangularIndicator(
            verticalPadding: 18,
            color: Colors.red,
            bottomLeftRadius: 20,
            bottomRightRadius: 20,
            topLeftRadius: 20,
            topRightRadius: 20,
          ),
          tabs: const [
            Tab(
              icon: SizedBox(width: 70, child: Icon(Icons.home)),
            ),
            Tab(
              height: 30,
              icon: SizedBox(width: 70, child: Icon(Icons.search_outlined)),
            ),
            Tab(
              icon: SizedBox(width: 70, child: Icon(Icons.person_2_outlined)),
            ),
          ],
        ),
      ),
    );
  }
}
