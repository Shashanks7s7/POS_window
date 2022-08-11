import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:possystem/provider/cart.dart';
import 'package:possystem/provider/order.dart';
import 'package:possystem/widgets/card.dart';

import 'package:possystem/widgets/paymentscreen.dart';
import 'package:provider/provider.dart';

class SidePosScreen extends StatefulWidget {
  const SidePosScreen({Key? key}) : super(key: key);

  @override
  _SidePosScreenState createState() => _SidePosScreenState();
}

class _SidePosScreenState extends State<SidePosScreen>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  late AnimationController animationController;
  String? _buttonselecteddval;
  static const orderitems = ['Add Customer', 'Scan QR'];

  final List<DropdownMenuItem<String>> _dropdownorderitems = orderitems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..forward();

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    loggedinuser = jsonDecode(prefs.getString('loggedinuserinfo').toString());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Map loggedinuser = {};
  
  final GlobalKey<FormState> key = GlobalKey();
 
  static const discountitems = ['FLAT', 'IN %'];
  final List<DropdownMenuItem<String>> _dropdowndiscountitems = discountitems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    var qrdata = Provider.of<Order>(context).qrdata;
      var cart = Provider.of<Cart>(context,listen: true);
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
              height: 60.h,
              width: 70.w,
              child: Image.asset(
                'assets/images/aem.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    height: 30.h,
                    width: 80.w,
                    child: FittedBox(
                      child: InkWell(
                        child: Text("Customer Type"),
                      ),
                    )),
                Container(
                  height: 30.h,
                  width: 40.w,
                  child: FittedBox(
                    child: Text(qrdata == null
                        ? "Not Selected"
                        : qrdata.name == null
                            ? qrdata.fullname.toString()
                            : qrdata.name.toString()),
                  ),
                ),
                Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    height: 60.h,
                    width: 100.w,
                    child: FittedBox(
                      child: SizedBox(
                        child: DropdownButton<String>(
                          hint: Text("SELECT"),
                          value: _buttonselecteddval,
                          onChanged: (String? newvalue) {
                            if (newvalue != null) {
                              setState(() {
                                _buttonselecteddval = newvalue;
                                if (_buttonselecteddval == 'Add Customer') {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return customerfield(
                                            loggedinuser['UserId'].toString());
                                      });
                                }
                                if (_buttonselecteddval == "Scan QR") {
                                  Navigator.of(context).pushNamed("qrscanner");
                                }
                              });
                            }
                          },
                          items: _dropdownorderitems,
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
                width: 350.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          " Item",
                          style: titleStyle,
                        ),
                        Text("Quantity", style: titleStyle),
                        Text("Rate", style: titleStyle),
                        Text("Total", style: titleStyle)
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: ispotriat ? 235.h : null,
                      child: Consumer<Cart>(
                        builder: (_, carrt, _1) => ListView.builder(
                          itemCount: carrt.itemcount,
                          shrinkWrap: true,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return buildCartItemList(carrt,
                                carrt.items.values.toList()[index], index);
                          },
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<Cart>(
                            builder: (_, carrt, _1) => SizedBox(
                                  width: 100.w,
                                  height: 18.h,
                                  child: FittedBox(
                                    child: Text(
                                        'Sub Total: ' +
                                            carrt.totalamount
                                                .toStringAsFixed(2),
                                        textAlign: TextAlign.start,
                                        style: subtitleStyle),
                                  ),
                                )),
                      ],
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 420.w,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Column(children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        " Discount Type",
                        style: titleStyle,
                      ),
                      Text("Discount", style: titleStyle),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: DropdownButton<String>(
                          value: cart.buttonselectedddiscount,
                          onChanged: (String? newvalue) {
                            if (newvalue != null) {
                              setState(() {
                                cart.buttonselectedddiscount = newvalue;
                                cart.discountcontroller.clear();
                                cart.disData=0;
                               
                              });
                            }
                          },
                          items: _dropdowndiscountitems,
                        ),
                      ),
                      Consumer<Cart>(
                          builder: (_, carrt, _1) => Container(
                                margin: EdgeInsets.only(top: 5.h),
                                height: 34.h,
                                width: 80.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 5.h),
                                child: Form(
                                  key: key,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: cart.discountcontroller,
                                    onChanged: (value) {
                                     if(value==""){
                                       carrt.disData = 0;
                                        carrt.discount = "0";
                                        print("dfjkljdlkfjlkdsfjlkdfjldskfjlskd");
                                     }
                                     else  if (cart.buttonselectedddiscount == 'FLAT') {
                                        print("djflkjlk"+value);
                                        carrt.disData = double.parse(value);
                                        carrt.discount = value;
                                     
                                        carrt.netamount =
                                            (carrt.totalamount - carrt.disData);
                                      }
                                  else if (cart.buttonselectedddiscount == "IN %") {
                                        carrt.disData = (carrt.totalamount *
                                                double.parse(value)) /
                                            100;
                                        carrt.netamount =
                                            (carrt.totalamount - carrt.disData);
   print(carrt.disData.toString()+" df "+carrt.totalamount.toString());
                                        carrt.discount = "${value}%";
                                      }
                                     
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ))
                    ],
                  )
                ])),
            Consumer<Cart>(
                builder: (_, carrt, _1) => PaymentScreen(
                    loggedinuser['UserId'].toString(),
                    carrt.totalamount,
                    cart.buttonselectedddiscount,
                    
                   ))
          ],
        )),
      ),
    );
  }

  Widget buildCartItemList(Cart cart, CartItem cartModel, int id) {
    return Card(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 16.h,
                  width: 90.w,
                  padding: EdgeInsets.only(left: 1.w),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return showbox(cart, cartModel, id);
                            });
                      },
                      child: Text(
                        cartModel.productname,
                        style: billStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                  width: 28.w,
                  child: FittedBox(
                    child: Text('${cart.indquantity(cartModel.productid)}',
                        style: titleStyle),
                  ),
                ),
                SizedBox(
                    width: 45.w,
                    height: 16.h,
                    child: FittedBox(
                      child: Text(
                        cartModel.unitprice.toStringAsFixed(2),
                        style: titleStyle,
                      ),
                    )),
                SizedBox(
                  width: 45.w,
                  height: 16.h,
                  child: FittedBox(
                    child: Text(
                      (cartModel.unitprice * cartModel.quantity)
                          .toStringAsFixed(2),
                      style: titleStyle,
                    ),
                  ),
                ),
              ],
            ),
            Cardlist(cartModel),
            Container(
              width: 300.w,
              padding: EdgeInsets.only(left: 10.w, right: 5.w),
              child: Text(
                cartModel.message ?? "",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 11.sp, color: Colors.blueGrey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showbox(Cart cart, CartItem cartModel, int id) {
    return Dialog(
      child: SizedBox(
        height: 300.h,
        width: 348.w,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: const TabBar(
                            labelColor: Colors.green,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(text: 'Adon List'),
                              Tab(text: 'Add Note'),
                            ],
                          ),
                        ),
                        Container(
                            height: 200.h, //height of TabBarView
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: TabBarView(children: <Widget>[
                              Container(
                                child: ListView.builder(
                                    itemCount: cartModel.adonlist.length,
                                    itemBuilder: (context, index) =>
                                        adons(cartModel, index, id)),
                              ),
                              addnote(cart, cartModel)
                            ]))
                      ])),
            ]),
      ),
    );
  }

  Widget addnote(Cart cart, CartItem cartModel) {
    final GlobalKey<FormState> key = GlobalKey();
    Map<String, String> authData = {
      'note': '',
    };

    return SizedBox(
      height: 160.h,
      child: Form(
          key: key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Enter Your message.'),
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    authData['note'] = value.toString();
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                onPressed: () {
                  if (!key.currentState!.validate()) {
                    return;
                  }
                  key.currentState!.save();
                  setState(() {
                    cartModel.message = authData['note'].toString();
                  });
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: maind,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black),
              ),
            ],
          )),
    );
  }

  Widget adons(CartItem cartModel, int index, int id) {
    return Card(
        child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 35.h,
                    width: 120.w,
                    child: Text(
                      cartModel.adonlist[index].adonname,
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          if (!cartModel.selectedadonlist!
                              .containsKey(cartModel.adonlist[index].adonid)) {
                            return;
                          }
                          setState(() {
                            if (cartModel.adonlist[index].adonquantity >= 2) {
                              cartModel.adonlist[index].adonquantity =
                                  cartModel.adonlist[index].adonquantity - 1;

                              cartModel.selectedadonlist!.update(
                                  cartModel.adonlist[index].adonid,
                                  (value) => AdonItem(
                                      adonid: value.adonid,
                                      adonname: value.adonname,
                                      unitprice: value.unitprice,
                                      selected: value.selected,
                                      adonquantity: value.adonquantity - 1));
                            } else {
                              cartModel.adonlist[index].adonquantity =
                                  cartModel.adonlist[index].adonquantity - 1;
                              cartModel.selectedadonlist!
                                  .remove(cartModel.adonlist[index].adonid);
                            }
                            Provider.of<Cart>(context, listen: false)
                                .adonit(cartModel.productid);
                          });
                          //  cart.removesingleitem(cartModel.productid);
                          animationController.reset();
                          animationController.forward();
                        },
                        child: const Icon(Icons.remove_circle),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 2.h),
                        child: Consumer<Cart>(
                          builder: (_, carttt, _1) => Text(
                              carttt
                                  .adnquantity(cartModel.productid,
                                      cartModel.adonlist[index].adonid)
                                  .toString(),
                              style: titleStyle),
                        ),
                      ),
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          //    cart.addsingleitem(cartModel.productid);
                          setState(() {
                            if (cartModel.selectedadonlist!.containsKey(
                                cartModel.adonlist[index].adonid)) {
                              cartModel.selectedadonlist!.update(
                                  cartModel.adonlist[index].adonid,
                                  (value) => AdonItem(
                                      adonid: value.adonid,
                                      adonname: value.adonname,
                                      unitprice: value.unitprice,
                                      selected: value.selected,
                                      adonquantity: value.adonquantity + 1));
                              cartModel.adonlist[index].adonquantity =
                                  cartModel.adonlist[index].adonquantity + 1;
                            } else {
                              cartModel.adonlist[index].adonquantity =
                                  cartModel.adonlist[index].adonquantity + 1;
                              cartModel.selectedadonlist!.putIfAbsent(
                                  cartModel.adonlist[index].adonid,
                                  () => cartModel.adonlist[index]);
                            }
                            Provider.of<Cart>(context, listen: false)
                                .adonit(cartModel.productid);
                          });

                          animationController.reset();
                          animationController.forward();
                        },
                        child: const Icon(Icons.add_circle),
                      ),
                    ],
                  )
                ])));
  }

  Widget customerfield(String uid) {
    final GlobalKey<FormState> key = GlobalKey();
    final order = Provider.of<Order>(context, listen: false);
 Map cusData= Provider.of<Cart>(context, listen: false).cusData;

    onsave() {
      if (!key.currentState!.validate()) {
        return;
      }
      key.currentState!.save();
      order.addqrdata(
          DateTime.now().millisecondsSinceEpoch,
          null,
          cusData['fullname'],
          cusData['address'],
          cusData['email'],
          cusData['phoneno']);
      order.addcustomertoDatabase(cusData['fullname'], cusData['address'],
          cusData['email'], cusData['phoneno'], uid);
      Navigator.of(context).pop();
    }

    return SimpleDialog(
      title: Center(child: Text("Customer Add")),
      children: [
        AutofillGroup(
            child: Form(
                key: key,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      keyboardType: TextInputType.name,
                      autofillHints: {"hari", "ram", "shyam"},
                      onSaved: (value) {
                        cusData['fullname'] = value.toString();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Address'),
                      keyboardType: TextInputType.text,
                      autofillHints: [AutofillHints.addressCity],
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onSaved: (value) {
                        cusData['address'] = value.toString();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      onSaved: (value) {
                        cusData['email'] = value.toString();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'PhoneNo'),
                      keyboardType: TextInputType.number,
                      autofillHints: [AutofillHints.telephoneNumber],
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'PhoneNo is missing';
                        }
                      },
                      onSaved: (value) {
                        cusData['phoneno'] = value.toString();
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(onPressed: onsave, child: Text("Save")),
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancel"))
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ]),
                ))),
      ],
    );
  }
}
