import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shose_web/model/sales.dart';
import 'package:shose_web/model/sales_by_type.dart';
import 'package:shose_web/vm/database_handler.dart';
import 'package:shose_web/vm/sales_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late DatabaseHandler dbHandler;

  late String checkDate;
  late String startDate;
  late String endDate;

  // Calendar
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    items = ['매출', '판매량'];
    dropdownValue = items[1];
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
                            popWindow(context, '날짜선택');
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
              : Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    salesAllData(),
                    salesByShop(),
                  ],
                ))
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
      width: 800,
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

  salesByShop() {
    return SizedBox(
      width: 1000,
      height: 300,
      child: FutureBuilder(
        future: handler.queryPurchasesalesByShop(startDate, endDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Sales> data = snapshot.data!;
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
                width: 550,
                child: buildTableRow(['일자', '판매수량', '판매액', '순이익']),
              ),
              SizedBox(
                width: 550,
                height: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return buildTableRow([
                      snapshot.data![index].date,
                      snapshot.data![index].quantity,
                      snapshot.data![index].sale,
                      (snapshot.data![index].sale * 0.4).toStringAsFixed(0)
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
          alignment: Alignment.center,
          width: data[0] == e
              ? 120
              : data[1] == e
                  ? 100
                  : 155,
          height: 30,
          decoration: BoxDecoration(border: Border.all()),
          child: Text(e.toString()),
        );
      },
    ).toList());
  }

  popWindow(BuildContext context, String title) {
    Get.dialog(Builder(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              titlePadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              title: SizedBox(
                  width: 560,
                  height: 50,
                  child: Stack(children: [
                    //제목
                    Positioned(
                        top: 15,
                        left: 0,
                        right: 0,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )),
                    //닫기 버튼
                    Positioned(
                        width: 45,
                        height: 45,
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            Get.back(); //창 닫기
                          },
                          child: const Icon(Icons.close),
                        ))
                  ])),
              //화면에 표시될 영역
              content: SizedBox(
                width: 300,
                height: 350,
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _rangeStart = null;
                      _rangeEnd = null;
                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      setStateDialog(() {});
                    }
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    _selectedDay = null;
                    _focusedDay = focusedDay;
                    _rangeStart = start;
                    _rangeEnd = end;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    setStateDialog(() {});
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      _calendarFormat = format;
                      setStateDialog(() {});
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_rangeStart != null && _rangeEnd != null) {
                      startDateController.text =
                          '${_rangeStart!.year}${_rangeStart!.month.toString().padLeft(2, '0')}${_rangeStart!.day.toString().padLeft(2, '0')}';
                      endDateController.text =
                          '${_rangeEnd!.year}${_rangeEnd!.month.toString().padLeft(2, '0')}${_rangeEnd!.day.toString().padLeft(2, '0')}';
                      startDate = startDateController.text.replaceAllMapped(
                        RegExp(r'(\d{4})(\d{2})(\d{2})'),
                        (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                      );
                      endDate = endDateController.text.replaceAllMapped(
                        RegExp(r'(\d{4})(\d{2})(\d{2})'),
                        (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                      );
                    } else if (_rangeEnd == null) {
                      startDateController.text =
                          '${_rangeStart!.year}${_rangeStart!.month.toString().padLeft(2, '0')}${_rangeStart!.day.toString().padLeft(2, '0')}';
                      endDateController.text =
                          '${_rangeStart!.year}${_rangeStart!.month.toString().padLeft(2, '0')}${_rangeStart!.day.toString().padLeft(2, '0')}';
                      startDate = startDateController.text.replaceAllMapped(
                        RegExp(r'(\d{4})(\d{2})(\d{2})'),
                        (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                      );
                      endDate = endDateController.text.replaceAllMapped(
                        RegExp(r'(\d{4})(\d{2})(\d{2})'),
                        (Match m) => "${m[1]}-${m[2]}-${m[3]}",
                      );
                    }
                    setState(() {});
                    Get.back();
                  },
                  child: const Text('적용'),
                ),
              ],
            );
          },
        );
      },
    ));
  }
} // End
