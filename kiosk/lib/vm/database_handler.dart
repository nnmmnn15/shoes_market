import 'package:kiosk/model/purchase.dart';
import 'package:kiosk/model/receive_data.dart';
import 'package:path/path.dart';
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
              purchaseid text,
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

  // 로그인
  Future<List<dynamic>> checkCustomer(String id, String pw) async {
    final Database db = await initializeDB();
    int idCheck = 0;
    dynamic idSeq = 0;
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select seq, count(id) as id from customer where id = ? and password = ?',
        [id, pw]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        idCheck = res['id'];
        idSeq = res['seq'];
      },
    ).toList();
    // [0, 1] 에러, [1, 1] 정상
    return [idCheck, idSeq];
  }

  // 주문확인
  Future<int> checkRecive(int seq, String receive) async {
    int receiveCheck = 0; // 여부 확인
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        '''
        select count(*) as checkreceive
        from transport, purchase
        where  transport.purchaseid = purchase.id
        AND purchase.customer_seq = ?
        AND purchaseid = ?
        AND transport.status = '매장입고'
        ''',
        [seq, receive]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        receiveCheck = res['checkreceive'];
      },
    ).toList();
    return receiveCheck;
  }

  // 주문화면
  Future<List<ReceiveData>> getRecive(String receive) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select pur.id id, pro.name name, pur.quantity quantity, 
          pur.product_size size, pur.purchasedate purdate, pro.image image
          from purchase pur, product pro
          where pro.id = pur.product_id and pur.id = ?
        ''', [receive]);
    return queryResult
        .map(
          (e) => ReceiveData.fromMap(e),
        )
        .toList();
  }

  // 수령 데이터 입력
  Future<void> insertReceiveStatus(String receive) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
          select *
          from purchase
          where id = ?
        ''', [receive]);
    List<Purchase> purchase = queryResult
        .map(
          (e) => Purchase.fromMap(e),
        )
        .toList();

    await db.rawInsert('''
          INSERT INTO purchase
          VALUES 
          (?, '수령', ?, ?, ?, ?, ?, ?, ?);
        ''', [
      purchase[0].id,
      purchase[0].shopId,
      purchase[0].customerSeq,
      purchase[0].productId,
      purchase[0].productSize,
      purchase[0].purchaseDate,
      purchase[0].purchasePrice,
      purchase[0].quantity
    ]);
  }
}
