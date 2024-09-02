class PurchaseOrder{
  String productname;
  String shopname;
  int size;
  String color;
  int quantity;
  int price;
  String date;
  String status;
  String id;

  PurchaseOrder(
    {
      required this.productname,
      required this.shopname,
      required this.size,
      required this.color,
      required this.quantity,
      required this.price,
      required this.date,
      required this.status,
      required this.id,
    }
  );

  PurchaseOrder.fromMap(Map<String, dynamic> res):
    productname = res['pname'],
    shopname = res['sname'],
    size = res['size'],
    color = res['color'],
    quantity = res['quantity'],
    price = res['price'],
    date = res['purchasedate'],
    status = res['status'],
    id = res['id'];
}