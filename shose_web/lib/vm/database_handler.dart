import 'package:path/path.dart';
import 'package:shose_web/model/purchase.dart';
import 'package:shose_web/model/sales.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'abcd.db'),
      onCreate: (db, version) async {
        await db.execute("""
            create table shop
            (
              id integer primary key autoincrement,
              name text,
              location text,
              phone text
            )
        """);
        await db.execute("""
            create table product
            (
              id text,
              size integer,
              name text,
              color text,
              price integer,
              image blob,
              brand text,
              primary key(id, size)
            )
        """);
        await db.execute("""
            create table transport
            (
              id integer,
              status text,
              shop_id integer,
              product_id text,
              date text,
              primary key(id, status)
            )
        """);
        await db.execute("""
            create table customer
            (
              seq integer primary key autoincrement,
              id text,
              name text,
              phone text,
              password text
            )
        """);
        await db.execute("""
            create table purchase
            (
              id text,
              status text,
              shop_id integer,
              customer_seq integer,
              product_id text,
              product_size integer,
              purchasedate text,
              purchaseprice integer,
              quantity integer,
              primary key(id, status)
            )
        """);
      },
      version: 1,
    );
  }

  Future<List<Purchase>> queryPurchase() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from purchase');
    print(queryResult);
    return queryResult
        .map(
          (e) => Purchase.fromMap(e),
        )
        .toList();
  }

  Future<List<Sales>> queryPurchasesales() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''select shop.name as 지점, sum(purchase.purchaseprice * purchase.quantity) as 매출
          from purchase, shop
          where shop.id = purchase.shop_id and
          purchase.status = '수령'
          group by shop.id;
          '''
          );
    print(queryResult);
    
    return queryResult.map((e) => Sales.fromMap(e)).toList();
  }
}