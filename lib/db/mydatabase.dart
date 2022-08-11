
import 'package:possystem/models/customer.dart';
import 'package:possystem/models/ordertype.dart';
import 'package:possystem/models/payment_mode.dart';
import 'package:possystem/models/pos_sales_detail.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:possystem/models/pos_sales_payment.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/models/product_adon.dart';
import 'package:possystem/models/product_adon_mapping_info.dart';
import 'package:possystem/models/productscategory.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as d;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MyDatabase {
  static final MyDatabase instance = MyDatabase._init();
  MyDatabase._init();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB('productcategory.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    //final dbPath = await getDatabasesPath();
    // final path = d.join(dbPath, filepath);
    // return await openDatabase(path, version: 1, onCreate: _createDB,);
    sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  var db= await databaseFactory.openDatabase(inMemoryDatabasePath,options: OpenDatabaseOptions(version: 1,onCreate: _createDB));

  print("4546454654654654654");
  return db;
  
  }
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
}

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType='INTEGER NOT NULL';
    const boolType='BOOLEAN NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''CREATE TABLE $tableProductsCategory (
    ${ProductsCategoryField.productCategoryID} $idType,
    ${ProductsCategoryField.categoryName} $textType,
    ${ProductsCategoryField.categoryCode} $textType
   )''');
    await db.execute('''CREATE TABLE $tableProductAdon (
    ${ProductAdonField.productAdonID} $idType,
    ${ProductAdonField.adonName} $textType,
    ${ProductAdonField.adonCode} $textType,
    ${ProductAdonField.localAdonName} $textType,
    ${ProductAdonField.rate} $realType
  )''');
   print("no way how is this possible");
    await db.execute('''CREATE TABLE $tableProduct (
    ${ProductField.productID} $idType,
    ${ProductField.productName} $textType,
    ${ProductField.productCode} $textType,
    ${ProductField.unitPrice} $realType,
    ${ProductField.image} $textType,
    ${ProductField.localName} $textType,
    ${ProductField.productCategoryID} $integerType,
    ${ProductField.productStatus} $integerType,
    ${ProductField.productCategoryName} $textType,
    ${ProductField.productAdons} $textType,
    ${ProductField.nonProductAdons} $textType,
    ${ProductField.productAdonIds} $textType,
    ${ProductField.productAdonNames} $textType,
    FOREIGN KEY(${ProductField.productCategoryID}) REFERENCES $tableProductsCategory (${ProductsCategoryField.productCategoryID})

  )''');
   await db.execute('''CREATE TABLE $tableProductAdonMappingInfo (
    ${ProductAdonMappingInfoField.productAdonMappingID} $idType,  
    ${ProductAdonMappingInfoField.productAdonID} $integerType,
    ${ProductAdonMappingInfoField.productID} $integerType,
    FOREIGN KEY(${ProductAdonMappingInfoField.productAdonID}) REFERENCES $tableProductAdon (${ProductAdonField.productAdonID}),
    FOREIGN KEY(${ProductAdonMappingInfoField.productID}) REFERENCES $tableProduct (${ProductField.productID})
  
   )''');
    await db.execute('''CREATE TABLE $tableOrderType (
    ${OrderTypeField.orderTypeID} $idType,
    ${OrderTypeField.orderTypeName} $textType,
    ${OrderTypeField.orderTypeCode} $textType
  )''');
   await db.execute('''CREATE TABLE $tablePaymentMode (
    ${PaymentModeField.paymentModeID} $idType,
    ${PaymentModeField.name} $textType,
    ${PaymentModeField.code} $textType
  )''');
    await db.execute('''CREATE TABLE $tablePOSSalesMaster (
    ${POSSalesMasterField.pOSSalesMasterID} $idType,
    ${POSSalesMasterField.salesNo} $textType,
    ${POSSalesMasterField.customerID} $integerType,
    ${POSSalesMasterField.orderTypeID} $integerType,
    ${POSSalesMasterField.isVoid} $boolType,
    ${POSSalesMasterField.voidReason} $textType,
    ${POSSalesMasterField.voidBy} $textType,
    ${POSSalesMasterField.voidDate} $textType,
    ${POSSalesMasterField.netAmount} $realType,
    ${POSSalesMasterField.taxPercentage} $realType,
    ${POSSalesMasterField.grandTotal} $realType,
    ${POSSalesMasterField.remarks} $textType,
    ${POSSalesMasterField.status} $integerType,
    ${POSSalesMasterField.createdBy} $textType,
    ${POSSalesMasterField.createdDate} $textType,
    ${POSSalesMasterField.discountType} $textType,
    ${POSSalesMasterField.discount} $realType,
    ${POSSalesMasterField.salesStatus} $integerType,
    FOREIGN KEY(${POSSalesMasterField.customerID}) REFERENCES $tableCustomer (${CustomerField.customerID})
  )''');
    await db.execute('''CREATE TABLE $tablePosSalesDetails (
    ${POSSalesDetailField.pOSSalesDetailID} $idType,
    ${POSSalesDetailField.pOSSalesMasterID} $integerType,
    ${POSSalesDetailField.productID} $integerType,
    ${POSSalesDetailField.quantity} $integerType,
    ${POSSalesDetailField.rate} $textType,
    ${POSSalesDetailField.notes} $textType,
    ${POSSalesDetailField.adonIDs} $textType,
    ${POSSalesDetailField.extraAdonIDs} $textType,   
    FOREIGN KEY(${POSSalesDetailField.pOSSalesMasterID}) REFERENCES $tablePOSSalesMaster (${POSSalesMasterField.pOSSalesMasterID}),
    FOREIGN KEY(${POSSalesDetailField.productID}) REFERENCES $tableProduct (${ProductField.productID})
   )''');
    await db.execute('''CREATE TABLE $tablePOSSalesPayment (
    ${POSSalesPaymentField.pOSSalesPaymentID} $idType,
    ${POSSalesPaymentField.pOSSalesMasterID} $integerType,
    ${POSSalesPaymentField.paymentModeID} $integerType,
    ${POSSalesPaymentField.amount} $realType,
    ${POSSalesPaymentField.status} $integerType,
    ${POSSalesPaymentField.createdBy} $textType,
    ${POSSalesPaymentField.createdDate} $textType,   
    FOREIGN KEY(${POSSalesPaymentField.pOSSalesMasterID}) REFERENCES $tablePOSSalesMaster (${POSSalesMasterField.pOSSalesMasterID}),
    FOREIGN KEY(${POSSalesPaymentField.paymentModeID}) REFERENCES $tablePaymentMode (${PaymentModeField.paymentModeID})
    )''');

     await db.execute('''CREATE TABLE $tableCustomer (
    ${CustomerField.customerID} $idType,
    ${CustomerField.fullName} $textType,
    ${CustomerField.address} $textType,
    ${CustomerField.email} $textType,
    ${CustomerField.phoneNo} $textType,
    ${CustomerField.status} $integerType,
    ${CustomerField.createdBy} $textType,
    ${CustomerField.createdDate} $textType, 
    ${CustomerField.modifiedBy} $textType, 
    ${CustomerField.modifiedDate} $textType
    )''');
  final maps = await db.rawQuery('SELECT * FROM $tablePOSSalesMaster');
   
     if (maps.isNotEmpty) {
     print("mao wala vayo");
      return maps.map((element) =>POSSalesMaster.fromJson(element)).toList();
    } else {
      print("vayena");
      return [];
    }
    
  
  }


///!!!!!!!!!!!!!!!!!!!!!????? CREATE ???????////////////////////////////
  Future<ProductsCategory?> createprocat(ProductsCategory procat) async {
    final db = await instance.database;
    final id = await db!.insert(tableProductsCategory, procat.toJson());
    print("hehehehe vayoooo");
    return procat.copy(id: id);
  }

  Future<ProductAdon?> createadon(ProductAdon procat) async {
    final db = await instance.database;
    final id = await db!.insert(tableProductAdon, procat.toJson());
    return procat.copy(id: id);
  }

  Future<Product?> createproduct(Product product) async {
    final db = await instance.database;
    final id = await db!.insert(tableProduct, product.toJson());
    return product.copy(id: id);
  }

  Future<ProductAdonMappingInfo?> createproductAdonMAppingInfo(ProductAdonMappingInfo productAdonMappingInfo) async {
    final db = await instance.database;
    final id = await db!.insert(tableProductAdonMappingInfo, productAdonMappingInfo.toJson());
    return productAdonMappingInfo.copy(id: id);
  }

   Future<OrderType?> createordertype(OrderType orderType) async {
    final db = await instance.database;
    final id = await db!.insert(tableOrderType, orderType.toJson());
    return orderType.copy(id: id);
  }
   Future<PaymentMode?> createpaymentmode(PaymentMode paymentMode) async {
    final db = await instance.database;
    final id = await db!.insert(tablePaymentMode, paymentMode.toJson());
    return paymentMode.copy(id: id);
  }
   Future<POSSalesMaster?> createpossalesmaster(POSSalesMaster posSalesMaster) async {
    final db = await instance.database;
    final id = await db!.insert(tablePOSSalesMaster, posSalesMaster.toJson());
    return posSalesMaster.copy(id: id);
   }
    Future<POSSalesDetail?> createpossalesdetail(POSSalesDetail posSalesDetail) async {
    final db = await instance.database;
    final id = await db!.insert(tablePosSalesDetails, posSalesDetail.toJson());
    return posSalesDetail.copy(id: id);
    }
     Future<POSSalesPayment?> createpossalespayment(POSSalesPayment posSalesPayment) async {
    final db = await instance.database;
    final id = await db!.insert(tablePOSSalesPayment, posSalesPayment.toJson());
    return posSalesPayment.copy(id: id);
     }
      Future<Customer?> createcustomer(Customer customer) async {
    final db = await instance.database;
    final id = await db!.insert(tableCustomer, customer.toJson());
    return customer.copy(id: id);
     }
//!!!!!!!!!!!!!!!!!!!!!????? READ ???????////////////////////////////!!!!!!!!!!!!!!!!!!!!!!
  Future<ProductAdon?> readadon(String name) async {
    final db = await instance.database;
    final maps = await db!.query(tableProductAdon,
        columns: ProductAdonField.values,
        where: '${ProductAdonField.adonName} = ?',
        whereArgs: [name]);
    if (maps.isNotEmpty) {
      print(maps);
      return ProductAdon.fromJson(maps.first);
    } else {
      throw Exception('ID $name not found');
    }
  }
 
  Future<List<Product>> readproduct(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tableProduct WHERE productCategoryID=?', [id]);
    if (maps.isNotEmpty) {
      return maps.map((element) =>Product.fromJson(element)).toList();
    } else {
      throw Exception('ID $id not found');
    }
    
  }
   Future<Product> readoneproduct(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tableProduct WHERE _productID=?', [id]);
    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first); 
    } else {
      throw Exception('ID $id not found');
    }
    
  }
    Future<ProductAdon> readoneadon(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tableProductAdon WHERE _productAdonID=?', [id]);
    if (maps.isNotEmpty) {
      return ProductAdon.fromJson(maps.first); 
    } else {
      throw Exception('ID $id not found');
    }
    
  }
  Future<List<POSSalesDetail>> readpossalesdetails(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tablePosSalesDetails WHERE pOSSalesMasterID=?', [id]);
    if (maps.isNotEmpty) {
      return maps.map((element) =>POSSalesDetail.fromJson(element)).toList();
    } else {
      throw Exception('ID $id not found');
    }
  }
  Future<String> readpossalesmasterid(String salesno) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tablePOSSalesMaster WHERE salesNo=?', [salesno]);
    if (maps.isNotEmpty) {
      return POSSalesMaster.fromJson(maps.first).pOSSalesMasterID.toString();
    } else {
      throw Exception('ID $salesno not found');
    }
  }
  Future<List<POSSalesPayment>> readpossalespayments(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tablePOSSalesPayment WHERE pOSSalesMasterID=?', [id]);
    if (maps.isNotEmpty) {
      return maps.map((element) =>POSSalesPayment.fromJson(element)).toList();
    } else {
      throw Exception('ID $id not found');
    }
  }
   Future<PaymentMode> readpaymentmode(String name) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tablePaymentMode WHERE name=?', [name]);
    if (maps.isNotEmpty) {
      return PaymentMode.fromJson(maps.first);
    } else {
      throw Exception('ID $name not found');
    }
    
  }
   Future<List<ProductAdon>> readproductadonasmap(int ad) async {
    final db = await instance.database;
     final maps = await db!.query(tableProductAdon,
        columns: ProductAdonField.values,
        where: '${ProductAdonField.productAdonID} = ?',
        whereArgs: [ad]);
    if (maps.isNotEmpty) {
      return maps.map((element) =>ProductAdon.fromJson(element)).toList();
    } else {
      
      return [];
    }
    
  }
  Future<List<ProductAdonMappingInfo>> readproductadonid(int id) async {
    final db = await instance.database;
    final maps = await db!.rawQuery('SELECT * FROM $tableProductAdonMappingInfo WHERE productID=?', [id]);
    
    if (maps.isNotEmpty) {
    
      return maps.map((element) =>ProductAdonMappingInfo.fromJson(element)).toList();
    } else {
      return [];
    }
  }



  Future<List<Product>> readAllproducts() async {
    final db = await instance.database;
    final result = await db!.query(tableProduct);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<ProductsCategory>> readAllprocat() async {
    final db = await instance.database;
    final result = await db!.query(tableProductsCategory);
    return result.map((json) => ProductsCategory.fromJson(json)).toList();
  }

  Future<List<ProductAdon>> readAlladon() async {
    final db = await instance.database;
    final result = await db!.query(tableProductAdon);
    return result.map((json) => ProductAdon.fromJson(json)).toList();
  }
   Future<List<ProductAdonMappingInfo>> readAllProductAdonMappingInfo(Product? product) async {
    final db = await instance.database;
    final result = await db!.query(tableProductAdonMappingInfo);
    return result.map((json) => ProductAdonMappingInfo.fromJson(json)).toList();
  }
  Future<List<OrderType>> readAllordertype() async {
    final db = await instance.database;
    final result = await db!.query(tableOrderType);
    return result.map((json) => OrderType.fromJson(json)).toList();

  }Future<List<PaymentMode>> readAllpaymentmode() async {
    final db = await instance.database;
    final result = await db!.query(tablePaymentMode);
    return result.map((json) => PaymentMode.fromJson(json)).toList();
  }
  Future<List<POSSalesMaster>> readAllpossalesmaster(int id) async {
    final db = await instance.database;
     final maps = await db!.rawQuery('SELECT * FROM $tablePOSSalesMaster WHERE salesStatus=? AND isVoid = 0 ORDER BY createdDate DESC', [id] );
   
     if (maps.isNotEmpty) {
     
      return maps.map((element) =>POSSalesMaster.fromJson(element)).toList();
    } else {
      return [];
    }
  }
  

  Future<int> updateprocat(ProductsCategory procat) async {
    final db = await instance.database;
    return db!.update(tableProductsCategory, procat.toJson(),
        where: '${ProductsCategoryField.productCategoryID} = ?',
        whereArgs: [procat.productCategoryID]);
  }
  Future<int> updatepossalesmater(int id,String remarks)async{
    final db = await instance.database;
    return db!.update(tablePOSSalesMaster, {'remarks':remarks},
        where: '${POSSalesMasterField.pOSSalesMasterID} = ?',
        whereArgs: [id]);
  }
   Future<int> updateposmaster(int isvoid,String voidreason,String voidby,int id) async {
    final db = await instance.database;
    return db!.update(tablePOSSalesMaster, {'isVoid':isvoid,'voidReason':voidreason,'voidBy':voidby,'voidDate':DateTime.now().toIso8601String()},
        where: '${POSSalesMasterField.pOSSalesMasterID} = ?',
        whereArgs: [id]);
        
  }

  Future<int> updateposmasterpayment(int status,int id) async {
    final db = await instance.database;
    return db!.update(tablePOSSalesPayment, {'status':status},
        where: '${POSSalesDetailField.pOSSalesMasterID} = ?',
        whereArgs: [id]);
        
  }
//!!!!!!!!!!!!!!!!!!!!!????? DELETE ???????////////////////////////////!!!!!!!!!!!!!!!!!!!!!!
  Future<int> deleteprocat(int id) async {
    final db = await instance.database;
    return await db!.delete(tableProductsCategory,
        where: '${ProductsCategoryField.productCategoryID} = ?',
        whereArgs: [id]);
  }
   Future deleteAllprocat() async {
    final db = await instance.database;
   return await db!.delete(tableProductsCategory);
   
  }
   Future deleteAlladon() async {
    final db = await instance.database;
   return await db!.delete(tableProductAdon);
   
  }
  Future deleteAllproduct() async {
    final db = await instance.database;
   return await db!.delete(tableProduct);
   
  }
  Future deleteAllproductAdonMappingInfo() async {
    final db = await instance.database;
   return await db!.delete(tableProductAdonMappingInfo);
   
  }
  Future deleteAllordertype() async {
    final db = await instance.database;
   return await db!.delete(tableOrderType);
   
  }
  Future deleteAllpaymentmode() async {
    final db = await instance.database;
   return await db!.delete(tablePaymentMode);
   
  }
   Future deleteAllcustomer() async {
    final db = await instance.database;
   return await db!.delete(tableCustomer);
   
  }
  Future deleteposSalesdetailperid(id)async{
     final db = await instance.database;
   return await db!.delete(tablePosSalesDetails,
    where: 'pOSSalesMasterID= ?',
        whereArgs: [id] 
   );
  }
  

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
