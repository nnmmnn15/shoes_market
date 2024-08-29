import 'dart:ffi';
import 'dart:typed_data';

class Product{
  final Int id;
  final String color;
  final String price;
  final Uint8List image;
  final String brand;

  Product(
    {
      required this.id,
      required this.color,
      required this.price,
      required this.image,
      required this.brand,
    }
  )
  Product.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  color = res['color'],
  price = res['price'],
  image = res['image'],
  brand = res['brand'];
}