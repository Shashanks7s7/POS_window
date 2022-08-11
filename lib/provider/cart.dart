import 'package:flutter/material.dart';

class CartItem {
  final String productid;
  final String productname;
  final int quantity;
  final double unitprice;

  final List<AdonItem> adonlist;
  String? message;
  Map<String, AdonItem>? selectedadonlist;
  CartItem(
      {required this.productid,
      required this.productname,
      required this.quantity,
      required this.unitprice,
      required this.adonlist,
      this.message,
      this.selectedadonlist});
}

class Cart with ChangeNotifier {
  // ignore: prefer_final_fieldsca

  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }
TextEditingController remarkscontroller=TextEditingController();
  double get totalamount {
//  double adsum = 0;
    double sum = 0.0;
    double ads = 0.0;
    _items.forEach((key, cartItem) {
      sum += cartItem.unitprice * cartItem.quantity;
      if (cartItem.selectedadonlist != null) {
        cartItem.selectedadonlist!.forEach((key, value) {
          ads += value.unitprice * value.adonquantity;
        });
      }
    });

    sum = ads + sum;

    return sum;
  }

  double netamount = 0;
  String discount = "0";
  double disData=0.0;
  double adsumddf = 0;
  List<AdonItem> selectedadon = [];

  double adonit(String productid) {
    List<AdonItem> selectedad = [];
    double adsum = 0;
    List<CartItem> cartu = _items.values.toList();
    List<AdonItem> aduwa = [];
    

    for (int i = 0; i < cartu.length; i++) {
      aduwa.addAll(cartu[i].adonlist);
    }

    List<AdonItem> selectedadonss =
        aduwa.where((element) => element.selected == true).toList();

    selectedad = selectedadonss;

    selectedadonss.forEach((element) {
      adsum += element.unitprice * element.adonquantity;
    });
    adsumddf = adsum;

    notifyListeners();

    return adsum;
  }

  indquantity(String id) {
    int da = 0;
    var quan =
        _items.values.toList().where((element) => element.productid == id);
    quan.forEach((element) {
      da += element.quantity;
    });
    return da;
  }

  adnquantity(String productid, String adonid) {
    int q = 0;
    var quan = _items.values
        .toList()
        .where((element) => element.productid == productid);
    quan.forEach((element) {
      element.adonlist
          .where((element) => element.adonid == adonid)
          .forEach((element) {
        q = element.adonquantity;
      });
    });
    return q;
  }

  int get itemcount {
    return _items.length;
  }

//   Future checkvalue() async {
//      List<ProductAdon> adondb = [];
//  List<AdonItem> myadon = [];
//     adondb = await MyDatabase.instance.readAlladon();
//     myadon = List<AdonItem>.generate(
//         adondb.length,
//         (index) => AdonItem(
//             adonid: adondb[index].productAdonID.toString(),
//             adonname: adondb[index].localAdonName,
//             unitprice: adondb[index].rate,
//             selected: false));
//             print(myadon);
//             return myadon;

//     //  adon.forEach((adons)=>cbvalue[adons.adonName.toString()]=false);
//   }

  additems(String productid, double unitprice, String productname, String image,
      List<AdonItem> adonitems,String notes) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (value) => CartItem(
              productid: value.productid,
              productname: value.productname,
              adonlist: value.adonlist,
              unitprice: value.unitprice,
              quantity: value.quantity + 1,
              selectedadonlist: value.selectedadonlist,
              message: value.message,
              
              ));
    } else {
      _items.putIfAbsent(
          productid,
          () => CartItem(
              productid: productid,
              productname: productname,
              unitprice: unitprice,
              adonlist: adonitems,
              quantity: 1,
              selectedadonlist: {},
              message:notes
              ));
    }
    notifyListeners();
  }

  getsingleitem(String productID) {}

  void removesingleitem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (value) => CartItem(
              productid: value.productid,
              productname: value.productname,
              quantity: value.quantity - 1,
              unitprice: value.unitprice,
              adonlist: value.adonlist,
              selectedadonlist: value.selectedadonlist));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeallitems(String productId) {
    _items.remove(productId);

    notifyListeners();
  }

  void addsingleitem(String productId) {
    _items.update(
        productId,
        (value) => CartItem(
            productid: value.productid,
            productname: value.productname,
            quantity: value.quantity + 1,
            unitprice: value.unitprice,
            adonlist: value.adonlist));

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    adsumddf = 0;
    notifyListeners();
  }

  ////////////////////////////////////////////////
  // ProductAdon? adonItem;
  // Map<String, AdonItem> _adonitems = {};
  // Map<String, AdonItem> get adonitems {
  //   return {..._adonitems};
  // }
  addadonitems(String productid, String adonid, List<AdonItem> selectedadons) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (value) => CartItem(
              productid: value.productid,
              productname: value.productname,
              unitprice: value.unitprice,
              quantity: value.quantity,
              adonlist: value.adonlist,
              selectedadonlist: value.selectedadonlist));
    }

    notifyListeners();
  }

  void removeadonItem(String adonname) {
    _items.remove(adonname);

    notifyListeners();
  }
}

class AdonItem {
  late final String adonid;
  final String adonname;
  final double unitprice;
  int adonquantity;
  bool selected;

  AdonItem({
    required this.adonid,
    required this.adonname,
    required this.unitprice,
    this.adonquantity = 0,
    required this.selected,
  });
}
/*class AdonCart with ChangeNotifier {
  // ignore: prefer_final_fieldsca

  Map<String, AdonItem> _items = {};
  Map<String, AdonItem> get items {
    return {..._items};
  }
  add(String productid,String adonid,String adonname,double unitprice){
    if (_items.containsKey(productid)) {
      _items.update(
          adonid,
          (value) => AdonItem(
                productid: value.productid,
                adonid: value.adonid,
                adonname: value.adonname,
               adonquantity: value.adonquantity + 1,
                unitprice: value.unitprice,
              
               
                selected: true
              ));
    } else {
      _items.putIfAbsent(
           adonid,
          () => AdonItem(
                productid: productid,
                adonid: adonid,
                adonname: adonname,
               adonquantity:1 ,
                unitprice: unitprice,
              
               
                selected: true
              ));
    }

}}*/
