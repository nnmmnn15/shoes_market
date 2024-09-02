class PurchaseOrder{
  String productname;
  int size;
  String color;
  int quantity;
  int price;
  String date;

  PurchaseOrder(
    {
      required this.productname,
      required this.size,
      required this.color,
      required this.quantity,
      required this.price,
      required this.date
    }
  );

  PurchaseOrder.fromMap(Map<String, dynamic> res):
  productname = res['name'],
  size = res['size'],
  color = res['color'],
  quantity = res['quantity'],
  price = res['price'],
  date = res['purchasedate'];

}