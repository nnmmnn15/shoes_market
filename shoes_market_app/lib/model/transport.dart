class Transport{
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
    required this.purchaseid
  });

  Transport.fromMap(Map<String, dynamic> res):
    id = res['id'],
    status = res['status'],
    shopId = res['shopId'],
    productId = res['productId'],
    date = res['date'],
    purchaseid = res['perchaseid'];
}