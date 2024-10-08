import 'dart:typed_data';

class PurchaseOrderDetail{
  String shopname;
  String id;
  Uint8List image;
  String productname;
  int size;
  String color;
  String location;

  PurchaseOrderDetail(
    {
      required this.shopname,
      required this.id,
      required this.image,
      required this.productname,
      required this.size,
      required this.color,
      required this.location,
    }
  );

  PurchaseOrderDetail.fromMap(Map<String, dynamic> res):
    shopname = res['shopname'],
    id = res['id'],
    image = res['image'],
    productname = res['productname'],
    size = res['size'],
    color = res['color'],
    location = res['loc'];
}