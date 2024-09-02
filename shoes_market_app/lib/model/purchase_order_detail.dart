import 'dart:typed_data';

class PurchaseOrderDetail{
  String shopname;
  String id;
  Uint8List image;
  String productname;
  int size;
  String color;

  PurchaseOrderDetail(
    {
      required this.shopname,
      required this.id,
      required this.image,
      required this.productname,
      required this.size,
      required this.color
    }
  );

  PurchaseOrderDetail.fromMap(Map<String, dynamic> res):
    shopname = res['name'],
    id = res['id'],
    image = res['image'],
    productname = res['name'],
    size = res['size'],
    color = res['color'];
}