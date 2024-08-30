import 'package:shose_web/model/sales_all_data.dart';
import 'package:shose_web/model/sales_by_type.dart';
import 'package:shose_web/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class SalesHandler {
  Future<List<SalesByType>> queryPurchasesalesByDate()async{
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          select purchasedate as type, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase
          where purchase.status = '수령'
          group by purchasedate;
          '''
          );
    return queryResult.map((e) => SalesByType.fromMap(e)).toList();
  }

  Future<List<SalesByType>> queryPurchasesalesByBrand()async{
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          select product.brand as type, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase, product
          where purchase.product_id = product.id AND purchase.product_size = product.size AND
          purchase.status = '수령'
          group by product.brand;
          '''
          );
    return queryResult.map((e) => SalesByType.fromMap(e)).toList();
  }

  Future<List<SalesAllData>> queryPurchasesalesByDateAll()async{
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          select purchasedate, sum(quantity) as 개수, sum(purchaseprice) as 매출
          FROM purchase
          GROUP BY purchasedate
          '''
          );
    return queryResult.map((e) => SalesAllData.fromMap(e)).toList();
  }
}