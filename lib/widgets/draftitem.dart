import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/customer.dart';
import 'package:possystem/models/pos_sales_detail.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:possystem/models/pos_sales_payment.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/models/product_adon.dart';
import 'package:possystem/provider/ad.dart' as ad;
import 'package:possystem/provider/cart.dart';
import 'package:possystem/provider/order.dart';
import 'package:possystem/provider/payadd.dart';
import "package:provider/provider.dart";

import '../models/product_adon_mapping_info.dart';

class DraftItem extends StatefulWidget {
  List<POSSalesMaster> data;
  final int index;
  final String uid;
  // ignore: use_key_in_widget_constructors
  DraftItem(this.data, this.index, this.uid);

  @override
  _DraftItemState createState() => _DraftItemState();
}

class _DraftItemState extends State<DraftItem> {
  bool expanded = false;
  bool isloading = false;

  onedit(int ids, context) async {
    final order = Provider.of<Order>(context, listen: false);

    final cart = Provider.of<Cart>(context, listen: false);
    final payadd = Provider.of<PayA>(context, listen: false);
    payadd.clear();
    var dat = widget.data[widget.index];
    List<POSSalesDetail> possalesdetails =
        await MyDatabase.instance.readpossalesdetails(ids);
    Customer customerdata =
        await MyDatabase.instance.readcutomer(dat.customerID);
    cart.clear();
    order.pOSSalesMasterID = dat.pOSSalesMasterID;
    cart.discountcontroller.text = dat.discount.toString();
    cart.buttonselectedddiscount = dat.discountType;
    cart.disData = dat.discount;
    cart.fullnamecontroller.text = customerdata.fullName.toString();
    cart.addresscontroller.text = customerdata.address.toString();
    cart.emailcontroller.text = customerdata.email.toString();
    cart.phonenocontroller.text = customerdata.phoneNo.toString();
    List<POSSalesPayment> posSalesPayment =
        await MyDatabase.instance.readpossalespayments(dat.pOSSalesMasterID!);

    posSalesPayment.forEach((element) async {
      print("dfjlkdjflkfdj");
      var name =
          await MyDatabase.instance.readpaymentName(element.paymentModeID);
      payadd.additems(element.paymentModeID, name.name, element.amount);
    });
    order.addqrdata(
        customerdata.customerID!,
        null,
        cart.fullnamecontroller.text,
        cart.addresscontroller.text,
        cart.emailcontroller.text,
        cart.phonenocontroller.text);
    if (dat.discountType == "IN %") {
      print("yesma heer la");
      print(dat.netAmount.toStringAsFixed(2));
      print(dat.discount.toStringAsFixed(2));
      cart.discountcontroller.text =
          ((dat.discount / double.parse(dat.netAmount.toStringAsFixed(2)) * 100)
              .toStringAsFixed(2));
    }
    print("yesma heer la aba yo herer");
    print(dat.discount.toStringAsFixed(2));
    for (int i = 0; i < possalesdetails.length; i++) {
      List<ProductAdonMappingInfo?> productadonmappinginfo = [];
      List<AdonItem> adonitems = [];
      var newlycreated = [];
      productadonmappinginfo = await MyDatabase.instance
          .readproductadonid(possalesdetails[i].productID!);
      // List adonids=List.generate(productadonmappinginfo.length, (index) => productadonmappinginfo[index]!.productAdonID);
      Product product = await MyDatabase.instance
          .readoneproduct(possalesdetails[i].productID);

      for (int i = 0; i < productadonmappinginfo.length; i++) {
        newlycreated.addAll(await MyDatabase.instance
            .readproductadonasmap(productadonmappinginfo[i]!.productAdonID));
      }

      var particularadonlist =
          possalesdetails[i].extraAdonIDs.toString().split(",");

      adonitems = List<AdonItem>.generate(
          newlycreated.length,
          (index) => AdonItem(
              adonid: newlycreated[index].productAdonID.toString(),
              adonname: newlycreated[index].adonName.toString(),
              unitprice: 5,
              selected: false));
      for (int k = 0; k < possalesdetails[i].quantity; k++) {
        cart.additems(
            possalesdetails[i].productID.toString(),
            double.parse(possalesdetails[i].rate),
            product.productName.toString(),
            product.image.toString(),
            adonitems,
            possalesdetails[i].notes == "null" ? "" : possalesdetails[i].notes);
        cart.remarkscontroller.text = dat.remarks;
      }
      var adonlist = possalesdetails[i].adonIDs.split(",");

      if (adonlist.length != 0) {
        for (int j = 0; j < adonlist.length; j++) {
          if (particularadonlist[j].isNotEmpty) {
            for (int l = 0;
                l < int.parse(particularadonlist[j].split(':')[1]);
                l++) {
              var adonindex = cart.items.values
                  .toList()[i]
                  .adonlist
                  .indexWhere((element) => element.adonid == adonlist[j]);
              if (cart.items.values
                  .toList()[i]
                  .selectedadonlist!
                  .containsKey(adonlist[j])) {
                cart.items.values.toList()[i].selectedadonlist!.update(
                    adonlist[j],
                    (value) => AdonItem(
                        adonid: value.adonid,
                        adonname: value.adonname,
                        unitprice: value.unitprice,
                        selected: value.selected,
                        adonquantity: value.adonquantity + 1));
                cart.items.values.toList()[i].adonlist[adonindex].adonquantity =
                    cart.items.values
                            .toList()[i]
                            .adonlist[adonindex]
                            .adonquantity +
                        1;
              } else {
                cart.items.values.toList()[i].adonlist[adonindex].adonquantity =
                    cart.items.values
                            .toList()[i]
                            .adonlist[adonindex]
                            .adonquantity +
                        1;

                cart.items.values.toList()[i].selectedadonlist!.putIfAbsent(
                    adonlist[j],
                    () => cart.items.values.toList()[i].adonlist[adonindex]);
              }
            }
          }
        }
      }
    }
  }

  onreorder(int ids) async {
    List<POSSalesPayment> possalespayments =
        await MyDatabase.instance.readpossalespayments(ids);
    List<POSSalesDetail> possalesdetails =
        await MyDatabase.instance.readpossalesdetails(ids);
    int id = DateTime.now().millisecondsSinceEpoch;
    var dat = widget.data[widget.index];
    String salesid = UniqueKey().toString();
    final data1 = POSSalesMaster(
        pOSSalesMasterID: null,
        salesNo: salesid,
        customerID: dat.customerID,
        orderTypeID: dat.orderTypeID,
        isVoid: dat.isVoid,
        voidReason: dat.voidReason,
        voidBy: dat.voidBy,
        voidDate: dat.voidDate,
        netAmount: dat.netAmount,
        taxPercentage: dat.taxPercentage,
        grandTotal: dat.grandTotal,
        remarks: dat.remarks,
        status: dat.status,
        createdBy: dat.createdBy,
        discountType: dat.discountType,
        discount: dat.discount,
        salesStatus: 1,
        createdDate: DateTime.now());
    await MyDatabase.instance.createpossalesmaster(data1);
    String posid = await MyDatabase.instance.readpossalesmasterid(salesid);
    for (int i = 0; i < possalesdetails.length; i++) {
      final data2 = POSSalesDetail(
          pOSSalesDetailID: null,
          pOSSalesMasterID: int.parse(posid),
          productID: possalesdetails[i].productID,
          quantity: possalesdetails[i].quantity,
          rate: possalesdetails[i].rate,
          notes: possalesdetails[i].notes.toString(),
          adonIDs: possalesdetails[i].adonIDs,
          extraAdonIDs: possalesdetails[i].extraAdonIDs);
      await MyDatabase.instance.createpossalesdetail(data2);
    }
    for (int j = 0; j < possalespayments.length; j++) {
      final data3 = POSSalesPayment(
          pOSSalesPaymentID: null,
          pOSSalesMasterID: int.parse(posid),
          paymentModeID: possalespayments[j].paymentModeID,
          amount: possalespayments[j].amount,
          status: possalespayments[j].status,
          createdBy: possalespayments[j].createdBy,
          createdDate: DateTime.now());
      await MyDatabase.instance.createpossalespayment(data3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Card(
        child: ListTile(
            // ignore: unnecessary_string_interpolations
            title: Text(
              'Order No. ${widget.data[widget.index].pOSSalesMasterID.toString()}',
              style: titleStyle,
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.data[widget.index].createdDate),
              style: titleStyle3,
              //DateFormat('yyyy/MM/dd hh:mm').format(widget.data.createddate),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              title: const Text("Confirm!"),
                              content:
                                  const Text("Do you want to edit the order?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      onedit(
                                          widget.data[widget.index]
                                              .pOSSalesMasterID!,
                                          context);
                                    },
                                    child: const Text("OK")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"))
                              ]);
                        });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 28.w,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Confirm!"),
                            content: const Text(
                                "Are you sure to reorder this sales?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    onreorder(widget
                                        .data[widget.index].pOSSalesMasterID!);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                          "Sucessfully placed the order."),
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      action: SnackBarAction(
                                          label: "Dismiss",
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          }),
                                    ));
                                  },
                                  child: const Text("OK")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"))
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 28.w,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return MyVoidDialog(
                                widget.data, widget.index, widget.uid);
                          });
                    }),
              
              ],
            )),
      ),
    );
  }
}

class MyVoidDialog extends StatefulWidget {
  List<POSSalesMaster> data;
  final int index;
  final String uid;
  // ignore: use_key_in_widget_constructors
  MyVoidDialog(this.data, this.index, this.uid);

  @override
  _MyVoidDialogState createState() => _MyVoidDialogState();
}

TextEditingController voidreasoncontroller = TextEditingController();

class _MyVoidDialogState extends State<MyVoidDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm!"),
      content: const Text("Are you sure to void this sales?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Void Reason"),
                      content: TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        controller: voidreasoncontroller,
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            if (voidreasoncontroller.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text("Please give the void reason."),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else {
                              //   draft.removeItem(widget.data.possalesmasterid);
                              await MyDatabase.instance.updateposmaster(
                                  1,
                                  voidreasoncontroller.text,
                                  widget.uid,
                                  widget.data[widget.index].pOSSalesMasterID!);

                              voidreasoncontroller.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text("Successfully deleted."),
                                duration: const Duration(milliseconds: 1000),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            }
                          },
                          child: const Text("OK"),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"))
                      ],
                    );
                  });
            },
            child: const Text("OK")),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"))
      ],
    );
  }
}
