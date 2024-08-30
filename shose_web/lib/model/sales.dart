class Sales{
  final String name;
  final int sale;

  Sales(
    {
      required this.name,
      required this.sale
    }
  );

  Sales.fromMap(Map<String, dynamic> res)
  : name = res['지점'],
    sale = res['매출'];
}