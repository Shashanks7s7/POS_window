/*import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:p_resturant/constants/fonts.dart';
import 'package:p_resturant/db/mydatabase.dart';
import 'package:p_resturant/models/product_adon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:p_resturant/provider/cart.dart';
import 'package:p_resturant/provider/order.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage>
    with SingleTickerProviderStateMixin {
  var now = DateTime.now();
  get weekDay => DateFormat('EEEE').format(now);
  get day => DateFormat('dd').format(now);
  get month => DateFormat('MMMM').format(now);
  double oldTotal = 0;
  double total = 0;
  late List<ProductAdon> adon;
  var addons = false;
  ScrollController scrollController = ScrollController();
  late AnimationController animationController;

  // onCheckOutClick(Cart cart) async {
  //   try {
  //     List<Map> data = List.generate(cart.cartItems.length, (index) {
  //       return {"id": cart.cartItems[index].food.id, "quantity": cart.cartItems[index].quantity};
  //     }).toList();

  //     var response = await Dio().post('$BASE_URL/api/order/food', queryParameters: {"token": token}, data: data);
  //     print(response.data);

  //     if (response.data['status'] == 1) {
  //       cart.clear();
  //       Navigator.of(context).pop();
  //     } else {
  //       Toast.show(response.data['message'], context);
  //     }
  //   } catch (ex) {
  //     print(ex.toString());
  //   }
  // }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..forward();
    super.initState();
    getadons();
  }

  Future getadons() async {
    setState(() {
      addons = true;
    });
    this.adon = await MyDatabase.instance.readAlladon();

    setState(() {
      addons = false;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: mainColor,
        title: Text('CheckOut'),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: addons
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...buildHeader(),
                    //cart items list
                    Consumer<Cart>(
                      builder: (_, carrt, _1) => ListView.builder(
                        itemCount: carrt.itemcount,
                        shrinkWrap: true,
                        controller: scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return buildCartItemList(
                              carrt, carrt.items.values.toList()[index], index);
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    buildPriceInfo(cart),
                    checkoutButton(cart, context),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text('Cart', style: headerStyle),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 0),
        child: Text('$weekDay, ${day}th of $month ', style: headerStyle),
      ),
      FlatButton(
        child: Text('+ Add to order'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }

  Widget buildPriceInfo(Cart cart) {
    //oldTotal = total;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total:', style: headerStyle),
        Consumer<Cart>(
          builder: (_, carrt, _1) => AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Text('\$ ${carrt.totalamount.toStringAsFixed(2)}',
                  style: headerStyle);
            },
          ),
        )
      ],
    );
  }

  Widget checkoutButton(Cart cart, context) {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 64),
      width: double.infinity,
      child: RaisedButton(
        child: Text('Checkout', style: titleStyle),
        onPressed: () {
          // onCheckOutClick(cart);
          Provider.of<Order>(context,listen: false).additems( cart.items.values.toList(), cart.totalamount);
           print( Provider.of<Order>(context,listen: false).items);
          print( Provider.of<Order>(context,listen: false).items[0].amount);
        
          
          Navigator.of(context).pushReplacementNamed('draftscreen');
            cart.clear();
        },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget buildCartItemList(Cart cart, CartItem cartModel, int id) {
    final GlobalKey<FormState> key = GlobalKey();
    Map<String, String> authData = {
      'note': '',
    };
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        height: 105,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: CachedNetworkImage(
                    imageUrl: '$BASE_URL${cartModel.image}',
                    fit: BoxFit.cover,
                    width: 65,
                    height: 65,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 16,
                  width: 15,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      '\$ ${cartModel.unitprice}',
                      style: titleStyle,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 45,
                    child: Text(
                      cartModel.productname,
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Consumer<Cart>(
                      builder: (_, cartt, _1) => Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                customBorder: roundedRectangle4,
                                onTap: () {
                                  cart.removesingleitem(cartModel.productid);
                                  animationController.reset();
                                  animationController.forward();
                                },
                                child: const Icon(Icons.remove_circle),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 2),
                                child: Text(
                                    '${cart.indquantity(cartModel.productid)}',
                                    style: titleStyle),
                              ),
                              InkWell(
                                customBorder: roundedRectangle4,
                                onTap: () {
                                  cart.addsingleitem(cartModel.productid);

                                  animationController.reset();
                                  animationController.forward();
                                },
                                child: Icon(Icons.add_circle),
                              ),
                            ],
                          ))
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Consumer<Cart>(
                      builder: (_, ad, _1) => PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          onSelected: (FilterOption value) {
                            if (value == FilterOption.adons) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) {
                                    return WillPopScope(
                                        onWillPop: () => Future.value(false),
                                        child: MyDialog(cartModel, id));
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return SimpleDialog(
                                      contentPadding: EdgeInsets.all(10),
                                      title: const Text("             Add a note"),
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 180,
                                          child: Form(
                                            key: key,
                                              child: Column(
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    hintText:
                                                        'Enter Your message.'),
                                                keyboardType:
                                                    TextInputType.name,
                                                onSaved: (value) {
                                                  authData['note'] =
                                                      value.toString();
                                                },
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                   if (!key.currentState!.validate()) {
                                                   return;
                                                     }
                                            key.currentState!.save();
                                                   setState(() {
                                  cartModel.message =authData['note'].toString();
                                  print(cartModel.message);
                                });
                                Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          )),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          itemBuilder: (_) => [
                                const PopupMenuItem(
                                    child: Text("Adons"),
                                    value: FilterOption.adons),
                                const PopupMenuItem(
                                    child: Text("Add Note"),
                                    value: FilterOption.notes),
                              ])),
                  InkWell(
                    onTap: () {
                      cart.removeItem(cartModel.productid);
                      animationController.reset();
                      animationController.forward();
                    },
                    customBorder: roundedRectangle12,
                    child: const Icon(Icons.delete_sweep, color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum FilterOption { adons, notes }

class MyDialog extends StatefulWidget {
//  final List<ProductAdon> adons;
// final Map<String,bool> cbvalue;
  final CartItem cartModel;
  final int id;
  MyDialog(this.cartModel, this.id);
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("    Select Adons"),
      children: [
        widget.cartModel.adonlist.isEmpty
            ? Container(
                height: 200,
                width: 600,
                child: Center(
                  child: Text("No Adons Avialable"),
                ))
            : Container(
                height: 400,
                width: 600,
                child: ListView.builder(
                    itemCount: widget.cartModel.adonlist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Consumer<Cart>(
                        builder: (_, ad, _1) => CheckboxListTile(
                              title: Text(
                                  widget.cartModel.adonlist[index].adonname),
                              value: widget.cartModel.adonlist[index].selected,
                              activeColor: Colors.deepPurple[400],
                              checkColor: Colors.white,
                              onChanged: (bool? valu) {
                                setState(() {
                                  widget.cartModel.adonlist[index].selected =
                                      valu!;
                                });
                              },
                            ))),
              ),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  Provider.of<Cart>(context, listen: false)
                      .adonit(widget.cartModel.productid);

                  Navigator.of(context).pop();
                },
                child: Text("Confirm"))),
      ],
    );
  }
}
*/