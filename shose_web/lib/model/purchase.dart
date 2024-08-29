class Purchase{
  String id;
  String status;
  int shopId;
  int customerSeq;
  String customerId;
  String productId;
  int productSize;
  String purchaseDate;
  int purchasePrice;
  int quantity;

  Purchase({
    required this.id,
    required this.status,
    required this.shopId,
    required this.customerSeq,
    required this.customerId,
    required this.productId,
    required this.productSize,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.quantity
  });

  Purchase.fromMap(Map<String, dynamic> res):
    id = res['id'],
    status = res['status'],
    shopId = res['shopId'],
    customerSeq = res['customerSeq'],
    customerId = res['customerId'],
    productId = res['productId'],
    productSize = res['productSize'],
    purchaseDate = res['purchaseDate'],
    purchasePrice = res['purchasePrice'],
    quantity = res['quantity'];
}