import 'package:get_storage/get_storage.dart';
import 'package:shoes_market_app/model/purchase.dart';
import 'package:shoes_market_app/model/transport.dart';
import 'package:shoes_market_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class TransportHandler{
  final box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  Future<int> insertTransport(Purchase purchaseData) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    DateTime now = DateTime.now();
    Transport transport =  Transport(
          id: int.parse(purchaseData.shopId.toString() + now.year.toString().padLeft(4,'0')+ now.month.toString().padLeft(2,'0')+now.day.toString().padLeft(2,'0')+now.hour.toString().padLeft(2,'0')+now.minute.toString().padLeft(2,'0')+now.second.toString().padLeft(2,'0')),
          status: '접수', 
          shopId: purchaseData.shopId,
          productId: purchaseData.productId,
          date: purchaseData.purchaseDate, 
          purchaseid: purchaseData.id
        );
      result = await db.rawInsert(
        """
          insert into transport(id, status, shop_id, product_id, date, purchaseid)
          values (?, ?, ?, ?, ?, ?)
        """,
        [
          transport.id,
          transport.status,
          transport.shopId,
          transport.productId,
          transport.date,
          transport.purchaseid
        ]
      );
      return result;
  }
}