import 'package:flutter/material.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/product_adon.dart';



class AdonItem{
final String adonid;
final String adonname;
final double unitprice;
 Map<String,bool>? cb;


  AdonItem({required this.adonid, required this.adonname, required this.unitprice,this.cb});





}

class Ad with ChangeNotifier {
  // ignore: prefer_final_fields
  ProductAdon? adonItem;
  Map<String, AdonItem> _items = {};
  Map<String, AdonItem> get items {
    return {..._items};
  }
 
  additems(String adonname, Map<String,bool>? bol
) async{
  
      adonItem = await MyDatabase.instance.readadon(adonname);
    

   _items.putIfAbsent(
          adonname,
          () => AdonItem(
              adonid: adonItem!.productAdonID.toString(),
              adonname:adonname,
              unitprice: adonItem!.rate,
              cb: bol
             ));
            
           notifyListeners();
    }

    void removeItem(String adonname) {
      _items.remove(adonname);
    notifyListeners();
  }
  
  
  }