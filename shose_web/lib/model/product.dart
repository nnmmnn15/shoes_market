import 'dart:typed_data';

class Product{
  int? id;
  int size;
  String name;
  String color;
  int price;
  Uint8List image;
  String brand;

  Product(
    {
      this.id,
      required this.size,
      required this.name,
      required this.color,
      required this.price,
      required this.image,
      required this.brand
    }
  );
  Product.fromMap(Map<String, dynamic> res):
    id = res['id'],
    size = res['size'],
    name = res['name'],
    color = res['color'],
    price = res['price'],
    image = res['image'],
    brand = res['brand'];
}