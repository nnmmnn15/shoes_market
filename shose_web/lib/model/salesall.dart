class Salesall{
  final int quantityall;
  final int sale;

  Salesall(
    {
      required this.quantityall,
      required this.sale
    }
  );

  Salesall.fromMap(Map<String, dynamic> res):
  quantityall = res['판매켤례'],
  sale = res['sale'];
}