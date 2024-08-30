class Purchase{
  String id;
  String status;
  int shopId;
  int customerSeq;
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
    required this.productId,
    required this.productSize,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.quantity
  });

  Purchase.fromMap(Map<String, dynamic> res):
    id = res['id'],
    status = res['status'],
    shopId = res['shop_id'],
    customerSeq = res['customer_seq'],
    productId = res['product_id'],
    productSize = res['product_size'],
    purchaseDate = res['purchasedate'],
    purchasePrice = res['purchaseprice'],
    quantity = res['quantity'];
}