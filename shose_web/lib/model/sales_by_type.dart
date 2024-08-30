class SalesByType{
  final String type;
  final int sale;

  SalesByType({
    required this.type,
    required this.sale,
  });

  SalesByType.fromMap(Map<String, dynamic> res)
  : type = res['type'],
    sale = res['매출'];
}