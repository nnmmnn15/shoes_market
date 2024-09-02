class Transport {
  int? id;
  String status;
  int shopId;
  String productId;
  String date;
  String purchaseid;

  Transport({
    this.id,
    required this.status,
    required this.shopId,
    required this.productId,
    required this.date,
    required this.purchaseid,
  });

  Transport.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        status = res['status'],
        shopId = res['shop_id'],
        productId = res['product_id'],
        date = res['date'],
        purchaseid = res['purchaseid'];
}
