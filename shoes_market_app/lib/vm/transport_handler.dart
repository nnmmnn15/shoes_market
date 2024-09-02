import 'package:get_storage/get_storage.dart';
import 'package:shoes_market_app/model/transport.dart';
import 'package:shoes_market_app/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class TransportHandler{
  final box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  Future<int> insertTransport( (String, String, int, String, int, int) temp) async {
     // product_id, shopname, size, purchasedate, purchaseprice, quantity
    int result = 0;
    final Database db = await handler.initializeDB();
    // int seq = box.read('abcd_user_seq');
    final List<Map<String, Object?>> shopQueryResult =
      await db.rawQuery(
          '''
            select id from shop
            where name = '${temp.$2}'
          '''
      );
    final List<Map<String, Object?>> purchaseQueryResult =
      await db.rawQuery(
          '''
            select id 
            from purchase
            where  product_id = '${temp.$1}' 
            and product_size = '${temp.$3}'
            and shop_id = '${shopQueryResult[0]['id']}'
            and purchasedate = '${temp.$4}' 
            and purchaseprice = '${temp.$5}'
            and quantity = '${temp.$6}'
          '''
      );
    DateTime now = DateTime.now();
    Transport transport =  Transport(
          id: int.parse(shopQueryResult[0]['id'].toString() + now.year.toString().padLeft(4,'0')+ now.month.toString().padLeft(2,'0')+now.day.toString().padLeft(2,'0')+now.hour.toString().padLeft(2,'0')+now.minute.toString().padLeft(2,'0')+now.second.toString().padLeft(2,'0')),
          status: '접수', 
          shopId: int.parse(shopQueryResult[0]['id'].toString()),
          productId: temp.$1, 
          date: temp.$4, 
          purchaseid: purchaseQueryResult[0]['id'].toString()
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