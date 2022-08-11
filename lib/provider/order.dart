

import 'package:flutter/cupertino.dart';

import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/customer.dart';

import 'package:possystem/provider/payadd.dart';
import 'package:possystem/models/pos_sales_detail.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:possystem/models/pos_sales_payment.dart';

import 'cart.dart';

class OrderItems {
  final String possalesmasterid;
  final String customerid;
  final String sales_number;
  final List<CartItem> cartitems;
  final double netamount;
  final double grandtotal;
  final double tax;
  final String remarks;
  final String createdby;
  final String discountType;
  final double discount;
  final DateTime createddate;
  final bool isvoid;
  final String? voidby;
  final String? voidreason;

  final DateTime? voiddate;
  final List<PayAdd> paymentss;

  OrderItems(
      {required this.possalesmasterid,
      required this.customerid,
      required this.sales_number,
      required this.cartitems,
      required this.netamount,
      required this.grandtotal,
      required this.tax,
      required this.remarks,
      required this.createdby,
      required this.discountType,
      required this.discount,
      required this.createddate,
      required this.isvoid,
      required this.voidby,
      required this.voidreason,
      required this.voiddate,
      required this.paymentss});
}

class Order with ChangeNotifier {
  List<OrderItems> _items = [];
  List<OrderItems> get items {
    return [..._items];
  }
  int? pOSSalesMasterID;

   Qr? _qrdata;
Qr? get qrdata {
    return _qrdata;
  }
   addqrdata(int customerid, String? name,String? fullname,String? address,String? email,String? phoneno) {
     
    _qrdata= Qr(cusid: customerid,name: name,
    fullname: fullname,
    address: address,
    email: email,
    phoneno:phoneno 
    );
    
    notifyListeners();
   }

  int index = 1;
  additems(
      List<CartItem> cartItem,
      double netamount,
      double grandtotal,
      double tax,
      String remarks,
      String createdby,
      String discounttype,
      double discount,
      bool isvoid,
      String? voidby,
      String? voidreason,
      DateTime? voiddate,
      List<PayAdd> paymentss) {
    _items.add(OrderItems(
        possalesmasterid: UniqueKey().toString(),
        sales_number: "Sales No.$index",
        cartitems: cartItem,
        createddate: DateTime.now(),
        customerid: UniqueKey().toString(),
        netamount: netamount,
        grandtotal: grandtotal,
        tax: tax,
        remarks: remarks,
        createdby: createdby,
        discountType: discounttype,
        discount: discount,
        isvoid: isvoid,
        voidby: voidby,
        voidreason: voidreason,
        voiddate: voiddate,
        paymentss: paymentss));
    index = index + 1;

    notifyListeners();
  }

  removeItem(String id) {
    _items.removeWhere((element) => element.possalesmasterid == id);
    notifyListeners();
  }
  addcustomertoDatabase(String? fullname,String? address,String? email,String? phoneno,String createdBy)async{
    final cusdata=Customer(fullName: fullname, address: address, status: 1, email: email, phoneNo: phoneno, createdBy: createdBy, createdDate: DateTime.now(), modifiedBy: createdBy ,modifiedDate:DateTime.now());
    await MyDatabase.instance.createcustomer(cusdata);

  }
  edittodb(String remarks,  List<CartItem> cartItem,)async{
    if(pOSSalesMasterID!=null){
      await MyDatabase.instance.deleteposSalesdetailperid(pOSSalesMasterID);
     await MyDatabase.instance.updatepossalesmater(pOSSalesMasterID!,remarks );
 for (int i = 0; i < cartItem.length; i++) {
      
      List adonidss = [];
      String idquan = "";
      if(cartItem.isNotEmpty){
      cartItem[i].selectedadonlist!.forEach((key, value) {
        adonidss.add(value.adonid);
        idquan =
            idquan + value.adonid + ":" + value.adonquantity.toString() + ',';
      });
      }
      
      
      final data2 = POSSalesDetail(
          pOSSalesDetailID: null,
          pOSSalesMasterID: pOSSalesMasterID!,
          productID: int.parse(cartItem[i].productid),
          quantity: cartItem[i].quantity,
          rate: cartItem[i].unitprice.toString(),
          notes: cartItem[i].message.toString(),
          adonIDs: adonidss.join(','),
          extraAdonIDs: idquan);
      await MyDatabase.instance.createpossalesdetail(data2);
 
     
    }
  }
  pOSSalesMasterID=null;
  }
  addtodb(
    int customerid,
      List<CartItem> cartItem,
      double netamount,
      double grandtotal,
      double tax,
      String remarks,
      String createdby,
      String discounttype,
      double discount,
      bool isvoid,
      String? voidby,
      String? voidreason,
      DateTime? voiddate,
      List<PayAdd> paymentss,
      int status,
      int salesstatus) async {
    
        String salesid=UniqueKey().toString();
    final data1 = POSSalesMaster(
        pOSSalesMasterID:null,
        salesNo: salesid,
        customerID: customerid,
        orderTypeID: 1,
        isVoid: isvoid,
        voidReason: voidreason.toString(),
        voidBy: voidby.toString(),
        voidDate: voiddate==null?voiddate.toString() :voiddate.toIso8601String(),
        netAmount: netamount,
        taxPercentage: 15,
        grandTotal: grandtotal,
        remarks: remarks,
        status: status,
        createdBy: createdby,
        discountType: discounttype,
        discount: discount,
        salesStatus: salesstatus,
        createdDate: DateTime.now());
    await MyDatabase.instance.createpossalesmaster(data1);
   
    String posid=await MyDatabase.instance.readpossalesmasterid(salesid);
    for (int i = 0; i < cartItem.length; i++) {
      
      List adonidss = [];
      String idquan = "";
      if(cartItem.isNotEmpty){
      cartItem[i].selectedadonlist!.forEach((key, value) {
        adonidss.add(value.adonid);
        idquan =
            idquan + value.adonid + ":" + value.adonquantity.toString() + ',';
      });
      }
      
      final data2 = POSSalesDetail(
          pOSSalesDetailID: null,
          pOSSalesMasterID:int.parse( posid),
          productID: int.parse(cartItem[i].productid),
          quantity: cartItem[i].quantity,
          rate: cartItem[i].unitprice.toString(),
          notes: cartItem[i].message.toString(),
          adonIDs: adonidss.join(','),
          extraAdonIDs: idquan);
      await MyDatabase.instance.createpossalesdetail(data2);
 
     
    }

    for (int j = 0; j < paymentss.length; j++) {
        int index3=DateTime.now().millisecondsSinceEpoch;
  final data3=POSSalesPayment(
    pOSSalesPaymentID: null,
     pOSSalesMasterID: int.parse( posid),
      paymentModeID: paymentss[j].paymentid,
      amount: paymentss[j].amount, 
      status:status , 
      createdBy: createdby,
       createdDate: DateTime.now());
await MyDatabase.instance.createpossalespayment(data3);


    }
   index=index+1;
  }
}
class Qr{
int cusid;
String? name;
String? fullname;
String? address;
String? email;
String? phoneno;
Qr({required this.cusid,required this.name ,required this.fullname,required this.address,required this.email,required this.phoneno});
}