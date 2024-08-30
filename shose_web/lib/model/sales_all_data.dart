class SalesAllData {
  final String date;
  final int sale;
  final int quantity;

  SalesAllData({
    required this.date,
    required this.sale,
    required this.quantity,
  });

  SalesAllData.fromMap(Map<String, dynamic> res)
  : date = res['purchasedate'],
    sale = res['매출'],
    quantity = res['개수'];

}