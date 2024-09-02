import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shose_web/model/sales_by_type.dart';
import 'package:shose_web/vm/sales_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesChart extends StatefulWidget {
  const SalesChart({super.key});

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  // Property
  late List<String> items;
  late String dropdownValue;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  late TooltipBehavior tooltipBehavior;

  late SalesHandler handler;

  late String checkDate;
  late String startDate;
  late String endDate;

  @override
  void initState() {
    super.initState();
    items = ['매출', '판매량'];
    dropdownValue = items[0];
    handler = SalesHandler();
    tooltipBehavior = TooltipBehavior();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    startDate = '';
    endDate = '';
    checkDate = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              dropdownBtn(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('날짜를 입력해주세요'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            //
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: startDateController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          decoration:
                              const InputDecoration(labelText: 'YYYYMMDD'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          '~',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: endDateController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          decoration:
                              const InputDecoration(labelText: 'YYYYMMDD'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (startDateController.text.length < 8 ||
                              endDateController.text.length < 8) {
                            checkDate = '올바른 값이 아닙니다';
                            setState(() {});
                          } else {
                            checkDate = '';
                            startDate =
                                startDateController.text.replaceAllMapped(
                              RegExp(r'(\d{4})(\d{2})(\d{2})'),
                              (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                            );
                            endDate = endDateController.text.replaceAllMapped(
                              RegExp(r'(\d{4})(\d{2})(\d{2})'),
                              (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                            );
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  Text(
                    checkDate,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          dropdownValue == items[0]
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    saleByDate(),
                    saleByBrand(),
                  ],
                )
              : Flexible(child: salesAllData())
        ],
      ),
    );
  }

  // --- Function ---
  dropdownBtn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black38),
      ),
      width: 150,
      child: DropdownButton(
        underline: const SizedBox(),
        focusColor: const Color.fromARGB(0, 255, 193, 7),
        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        iconEnabledColor: Theme.of(context).colorScheme.secondary,
        value: dropdownValue, // 현재 값
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                items,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          dropdownValue = value!;
          setState(() {});
        },
      ),
    );
  }

  saleByDate() {
    return SizedBox(
      width: 700,
      height: 500,
      child: FutureBuilder(
        future: handler.queryPurchasesalesByDate(startDate, endDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SalesByType> data = snapshot.data!;
            return SfCartesianChart(
              title: const ChartTitle(
                text: "날짜별",
              ),
              tooltipBehavior: tooltipBehavior, // 차트 선택시 상세 데이터 보여줌
              series: [
                LineSeries<SalesByType, String>(
                  // int 는 형식이므로 맞춰줘야함 (나중에 index로 대체)
                  color: Theme.of(context).colorScheme.primary,
                  name: 'date',
                  dataSource: data,
                  xValueMapper: (SalesByType sale, _) => sale.type,
                  yValueMapper: (SalesByType sale, _) => sale.sale,
                  dataLabelSettings:
                      const DataLabelSettings(isVisible: true), // 차트 상단의 수치 표기
                  enableTooltip: true,
                ),
              ],
              // x축 타이틀 (xlabel)
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: '일자'),
              ),
              // y축 타이틀 (ylabel)
              primaryYAxis: const NumericAxis(title: AxisTitle(text: '매출')),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  saleByBrand() {
    return SizedBox(
      width: 700,
      height: 500,
      child: FutureBuilder(
        future: handler.queryPurchasesalesByBrand(startDate, endDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SalesByType> data = snapshot.data!;
            return SfCartesianChart(
              title: const ChartTitle(
                text: "브랜드",
              ),
              tooltipBehavior: tooltipBehavior,
              series: [
                ColumnSeries<SalesByType, String>(
                  color: Theme.of(context).colorScheme.primary,
                  name: 'brand',
                  dataSource: data,
                  xValueMapper: (SalesByType sale, _) => sale.type,
                  yValueMapper: (SalesByType sale, _) => sale.sale,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                ),
              ],
              // x축 타이틀 (xlabel)
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: '브랜드'),
              ),
              // y축 타이틀 (ylabel)
              primaryYAxis: const NumericAxis(title: AxisTitle(text: '매출')),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  salesAllData() {
    return FutureBuilder(
      future: handler.queryPurchasesalesByDateAll(startDate, endDate),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 600,
                child: buildTableRow(['일자', '판매수량', '판매액']),
              ),
              SizedBox(
                width: 600,
                height: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return buildTableRow([
                      snapshot.data![index].date,
                      snapshot.data![index].quantity,
                      snapshot.data![index].sale
                    ]);
                  },
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
    );
  }

  buildTableRow(List data) {
    return Row(
        children: data.map(
      (e) {
        return Container(
          width: 200,
          decoration: BoxDecoration(border: Border.all()),
          child: Text(e.toString()),
        );
      },
    ).toList());
  }

} // End
