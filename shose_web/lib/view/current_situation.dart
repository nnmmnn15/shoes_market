import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shose_web/model/sales.dart';
import 'package:shose_web/view/sales_chart.dart';
import 'package:shose_web/view/sales_grape.dart';
import 'package:shose_web/vm/database_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentSituation extends StatefulWidget {
  const CurrentSituation({super.key});

  @override
  State<CurrentSituation> createState() => _CurrentSituationState();
}

class _CurrentSituationState extends State<CurrentSituation> {
  //Property
  late DatabaseHandler handler;
  late List<Sales> data;
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    data = [];
    tooltipBehavior = TooltipBehavior();
    addData();
  }

  addData() async {
    data = await handler.queryPurchasesales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'ABCD Market',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 750,
                height: 155,
                child: FutureBuilder(
                  future: handler.queryPurchaseall(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              '매출 현황',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  '판매수량',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '${snapshot.data![0].quantityall.toString()}켤례',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '이번 달 매출',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${snapshot.data![0].sale.toString()}원',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 500,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '전체 판매량 보기',
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.to(() => const SalesGrape());
                                },
                                icon: Icon(Icons.arrow_forward)),
                          ],
                        ),
                        Text(
                          '베스트 브랜드',
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1000,
                    height: 300,
                    child: FutureBuilder(
                      future: handler.queryPurchasebest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Card(
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${snapshot.data![0].name} (${snapshot.data![0].color})',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${snapshot.data![0].price.toString()}원',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Image.memory(
                                  snapshot.data![0].image,
                                  width: 200,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 500,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '전체 매출 보기',
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.to(() => SalesChart()); //차트
                                },
                                icon: Icon(Icons.arrow_forward)),
                          ],
                        ),
                        Text(
                          '매장 별 판매수량',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1000,
                    height: 300,
                    child: FutureBuilder(
                      future: handler.queryPurchasesales(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Card(
                            child: SfCartesianChart(
                              title: const ChartTitle(),
                              tooltipBehavior: tooltipBehavior,
                              series: [
                                ColumnSeries<Sales, String>(
                                  color: Theme.of(context).colorScheme.primary,
                                  name: 'Developers',
                                  dataSource: data,
                                  xValueMapper: (Sales pur, _) => pur.name,
                                  yValueMapper: (Sales pur, _) => pur.sale,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true), //chart위에 숫자표시 신뢰도 상승
                                  enableTooltip: true,
                                  width: 0.05,
                                ),
                              ],
                              primaryXAxis: const CategoryAxis(
                                title: AxisTitle(text: '점포'),
                              ),
                              //y축 타이틀 (ylabel)
                              primaryYAxis: const NumericAxis(
                                title: AxisTitle(text: '매출'),
                              ),
                            ),
                          ); //그래프
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
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
}
