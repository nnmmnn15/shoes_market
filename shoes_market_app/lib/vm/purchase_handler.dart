import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:shoes_market_app/model/purchase.dart';
import 'package:shoes_market_app/model/purchase_order.dart';
import 'package:shoes_market_app/model/purchase_order_detail.dart';
import 'package:shoes_market_app/model/transport.dart';
import 'package:sqflite/sqflite.dart';

class PurchaseHandler{
  final box = GetStorage();

  Future<Database> initializeDB() async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'abcd.db'),
      onCreate: (db, version) async{
        await db.execute(
        """
            create table shop
            (
              id integer primary key autoincrement,
              name text,
              location text,
              phone text
            )
        """
        );
        await db.execute(
        """
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
        """
        );
        await db.execute(
        """
            create table transport
            (
              id integer,
              status text,
              shop_id integer,
              product_id text,
              date text,
              primary key(id, status)
            )
        """
        );
        await db.execute(
        """
            create table customer
            (
              seq integer primary key autoincrement,
              id text,
              name text,
              phone text,
              password text
            )
        """
        );
        await db.execute(
        """
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
        """
        );
      },
      version: 1,
    );
  }

  Future<int> insertPurchase((String, String, int, String, int, int) temp) async {
    // temp(product_id, shopname, size, purchasedate, purchaseprice, quantity
    DateTime now = DateTime.now();
    int result = 0;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryshopResult = await db.rawQuery(
      '''
          select *
          from shop
          where name = ?
      ''', [
        temp.$2
        ]);

    Purchase purchaseData = Purchase(
      id: queryshopResult[0]['id'].toString() + box.read('abcd_user_seq').toString()+ now.year.toString()+ now.month.toString()
          + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString(), 
      status: '미수령', 
      shopId: int.parse(queryshopResult[0]['id'].toString()), 
      customerSeq: box.read('abcd_user_seq'),  // 임시
      productId: temp.$1, 
      productSize: temp.$3, 
      purchaseDate: temp.$4, 
      purchasePrice: temp.$5, 
      quantity: temp.$6
    );
    result = await db.rawInsert(
      """
        insert into purchase
        values (?, ?, ?, ?, ?, ?, ?, ?, ?)
      """,
      [
        purchaseData.id,
        purchaseData.status,
        purchaseData.shopId,
        purchaseData.customerSeq,
        purchaseData.productId,
        purchaseData.productSize,
        purchaseData.purchaseDate,
        purchaseData.purchasePrice,
        purchaseData.quantity,
      ]
    );
    return result;
  }

  Future<List<PurchaseOrder>> queryPurchase() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          SELECT product.name as pname, purchase.product_size as size, 
          product.color as color, purchase.quantity as quantity, 
          purchase.purchaseprice as price, purchase.purchasedate as purchasedate, 
          shop.name sname, purchase.id as id, MAX(purchase.status) as status
          FROM purchase, customer, product, shop
          WHERE purchase.customer_seq = ?
          AND purchase.customer_seq = customer.seq
          AND purchase.product_id = product.id
          AND shop.id = purchase.shop_id
          GROUP BY purchase.id
          ''',[box.read('abcd_user_seq')]);

    return queryResult
        .map(
          (e) => PurchaseOrder.fromMap(e),
        )
        .toList();
  }

  Future<List<PurchaseOrderDetail>> queryPurchasedetail(var purchaseId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          select s.name, pur.id, pro.image, pro.name, pro.size, pro.color
          from purchase pur, product pro, shop s
          where pur.product_id = pro.id AND pur.product_size = pro.size AND
          pur.shop_id = s.id
          AND pur.id = ?
          GROUP By pur.id;
          ''', [purchaseId]);
    return queryResult
        .map(
          (e) => PurchaseOrderDetail.fromMap(e),
        )
        .toList();
  }

  Future<List<Transport>> queryTransport() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(
          '''
          select date
          from transport
          where purchaseid;
          ''');
    return queryResult
        .map(
          (e) => Transport.fromMap(e),
        )
        .toList();
  }

}