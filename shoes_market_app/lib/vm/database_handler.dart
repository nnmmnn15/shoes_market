import 'package:path/path.dart';
import 'package:shoes_market_app/model/customer.dart';
import 'package:shoes_market_app/model/product.dart';
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

  Future<List<Product>> queryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        select * from product 
        """);
    return queryResult
        .map(
          (e) => Product.fromMap(e),
        )
        .toList();
  }

  Future<List<Product>> searchProduct(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
            select * from product where name like '%$query%'
        """);
    return queryResult
        .map(
          (e) => Product.fromMap(e),
        )
        .toList();
  }

//-------------회원가입 정보 DB에 저장--------------
  Future<int> joinCustomer(Customer customer) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert("""
      insert into customer(id, password, name, phone)
      values (?,?,?,?)
      """, [
      customer.id,
      customer.password,
      customer.name,
      customer.phone,
    ]);
    return result;
  }



//-------------회원가입시 아이디체크--------------
  Future<List<dynamic>> idCheck(String checkId) async {
    final Database db = await initializeDB();
    int idCheck = 0;
    dynamic id = '';
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
    select count(*) id from customer where id = '$checkId'
    """);
    idCheck = int.parse(queryResult[0]['id'].toString());
    // queryResult[0]['id'];
    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        // idCheck = res['id'];
        id = res['id'];
      },
    ).toList();
    return [idCheck, id];
  }

//-------------로그인--------------
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
    return [idCheck, idSeq];
  }

//-------------로그인자 이름불러오기-------------
  Future<String> getCustomerName(String id, String pw) async {
    // 로그인: 주어진 ID와 비밀번호로 고객 이름을 확인
    final Database db = await initializeDB(); // 데이터베이스 연결 초기화.
    // SQL 쿼리를 실행하여 주어진 ID와 비밀번호로 이름 가져옴
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'SELECT name FROM customer WHERE id = ? AND password = ?', [id, pw]);
    if (queryResult.isNotEmpty) {
      // 쿼리 결과가 비어 있지 않으면 이름 반환
      final Map<String, dynamic> row = queryResult.first;
      return row['name'] as String;
    } else {
      return 'empty'; // 고객을 찾을 수 없으면 null 반환
    }
  }
}
