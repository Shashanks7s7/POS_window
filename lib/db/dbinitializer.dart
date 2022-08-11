import 'package:flutter/material.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/payment_mode.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/models/productscategory.dart';

class DbInitializer with ChangeNotifier{

 List<PaymentMode>paymentmodes=[];
 List<String> paymentnames=[];
 
 getpaymentmodes()async{
   paymentmodes=await MyDatabase.instance.readAllpaymentmode();
  if(paymentnames.isEmpty){
   paymentmodes.forEach((element) {
     paymentnames.add(element.name);
   });}
 
   notifyListeners();
 }
 List<ProductsCategory>procat=[];
 List<Product>products=[];
 Map<String,List<Product>> categorizedproducts={};
 getprocat()async{
   procat=await MyDatabase.instance.readAllprocat();
   products=await MyDatabase.instance.readAllproducts();
   for(int i=0;i<procat.length;i++){
     List<Product> pro=await MyDatabase.instance.readproduct(procat[i].productCategoryID!);
     categorizedproducts.putIfAbsent(i.toString(), () =>
     pro
     );
    
   }
 }

}