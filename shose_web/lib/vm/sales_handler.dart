import 'package:shose_web/model/sales.dart';
import 'package:shose_web/model/sales_all_data.dart';
import 'package:shose_web/model/sales_by_type.dart';
import 'package:shose_web/vm/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class SalesHandler {
  Future<List<SalesByType>> queryPurchasesalesByDate(
      String start, String end) async {
    if (start == '' && end == '') {
      DateTime now = DateTime.now();
      DateTime before7Day = now.subtract(const Duration(days: 7));
      start =
          '${before7Day.year}-${before7Day.month.toString().padLeft(2, '0')}-${before7Day.day.toString().padLeft(2, '0')}';
      end =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select purchasedate as type, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase
          where purchasedate BETWEEN ? and ? AND
          purchase.status = '미수령'		  
          group by purchasedate;
          ''', [start, end]);
    return queryResult.map((e) => SalesByType.fromMap(e)).toList();
  }

  Future<List<SalesByType>> queryPurchasesalesByBrand(
      String start, String end) async {
    if (start == '' && end == '') {
      DateTime now = DateTime.now();
      DateTime before7Day = now.subtract(const Duration(days: 7));
      start =
          '${before7Day.year}-${before7Day.month.toString().padLeft(2, '0')}-${before7Day.day.toString().padLeft(2, '0')}';
      end =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select product.brand as type, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase, product
          where purchase.product_id = product.id AND purchase.product_size = product.size 
          AND purchasedate BETWEEN ? and ? AND
          purchase.status = '미수령'
          group by product.brand;
          ''', [start, end]);
    return queryResult.map((e) => SalesByType.fromMap(e)).toList();
  }

  Future<List<SalesAllData>> queryPurchasesalesByDateAll(
      String start, String end) async {
    if (start == '' && end == '') {
      DateTime now = DateTime.now();
      DateTime before7Day = now.subtract(const Duration(days: 30));
      start =
          '${before7Day.year}-${before7Day.month.toString().padLeft(2, '0')}-${before7Day.day.toString().padLeft(2, '0')}';
      end =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select purchasedate, sum(quantity) as 개수, sum(purchaseprice * quantity) as 매출
          FROM purchase
          WHERE purchasedate BETWEEN ? and ? AND
          status = '미수령'
          GROUP BY purchasedate
          ''', [start, end]);
    return queryResult.map((e) => SalesAllData.fromMap(e)).toList();
  }

  Future<List<Sales>> queryPurchasesalesByShop(
      String start, String end) async {
    if (start == '' && end == '') {
      DateTime now = DateTime.now();
      DateTime before7Day = now.subtract(const Duration(days: 30));
      start =
          '${before7Day.year}-${before7Day.month.toString().padLeft(2, '0')}-${before7Day.day.toString().padLeft(2, '0')}';
      end =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select shop.name as 지점, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase, shop
          where shop.id = purchase.shop_id and
          purchase.status = '미수령' AND
          purchasedate BETWEEN ? AND ?
          group by shop.id;
          ''',[start, end]);
    return queryResult.map((e) => Sales.fromMap(e)).toList();
  }
}
