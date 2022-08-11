import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/dbinitializer.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/payment_mode.dart';
import 'package:possystem/provider/payadd.dart';
import 'package:possystem/provider/cart.dart';
import 'package:possystem/provider/order.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';

import 'buildprintabledata.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  final String uid;
  final double amount;
  final String discounttype;

  PaymentScreen(this.uid, this.amount, this.discounttype, {Key? key})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final paycontroller = TextEditingController();

  double paymentprice = 0.0;

  List modea = [];
  String testpay = '';
  late String _buttonselecteddval;

  @override
  void initState() {
    super.initState();
    _buttonselecteddval =
        Provider.of<DbInitializer>(context, listen: false).paymentnames[0];
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    print(cart.disData);
    double grand =
        (widget.amount - cart.disData) * 0.15 + (widget.amount - cart.disData);
    double gt = double.parse(grand.toStringAsFixed(2));
    var p = Provider.of<PayA>(context);
    setState(() {
      p.total = gt;
    });
    var qrdata = Provider.of<Order>(context).qrdata;
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        width: 420.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: ispotriat
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceAround,
            children: [
              Text(
                " Payment Mode",
                style: titleStyle,
              ),
              Text("Amount", style: titleStyle),
              Text("Action", style: titleStyle),
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Consumer<PayA>(
            builder: (_, payadd, _1) => SizedBox(
              height: ispotriat ? 78.h : null,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: payadd.items.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          payadd.items.values.toList()[index].title,
                          style: subtitleStyle,
                        ),
                        Text(
                            payadd.items.values
                                .toList()[index]
                                .amount
                                .toStringAsFixed(2),
                            style: subtitleStyle),
                        IconButton(
                            onPressed: () {
                              payadd.removeItem(
                                  payadd.items.values.toList()[index].title);
                              paycontroller.text = payadd.ramain;
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    );
                  }),
            ),
          ),
          Consumer<PayA>(
              builder: (_, payadd, _1) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize:
                        ispotriat ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      FittedBox(
                        child: DropdownButton<String>(
                          value: _buttonselecteddval,
                          hint: const Text("Select"),
                          onChanged: (newvalue) {
                            setState(() {
                              _buttonselecteddval = newvalue.toString();
                            });
                          },
                          items:
                              Provider.of<DbInitializer>(context, listen: false)
                                  .paymentnames
                                  .map((String value) => DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                      ))
                                  .toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        height: 34.h,
                        width: ispotriat ? 90.w : 105.w,
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: TextFormField(
                            key: Key(payadd.ramain.toString()),
                            initialValue: payadd.ramain,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (valu) {
                              paycontroller.text = valu;
                              testpay = valu;
                            },
                            onTap: () {
                              paycontroller.selection = TextSelection(
                                  baseOffset: paycontroller.text.length,
                                  extentOffset: paycontroller.text.length);
                            }),
                      ),
                      FittedBox(
                        child: IconButton(
                            onPressed: () async {
                              PaymentMode mode = await MyDatabase.instance
                                  .readpaymentmode(_buttonselecteddval);
                              if (paycontroller.text.isEmpty) {
                                paycontroller.text = payadd.ramain;
                              }
                              if (paycontroller.text != testpay) {
                                paycontroller.text = payadd.ramain;
                              }

                              if (double.parse(paycontroller.text) >
                                  double.parse(gt.toStringAsFixed(2))) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Payment amount is grater than grand total. Please check !!!"),
                                  duration: const Duration(milliseconds: 800),
                                  action: SnackBarAction(
                                      label: "Dismiss",
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      }),
                                ));
                                return;
                              } else if (double.parse(paycontroller.text) >
                                  double.parse(payadd.ramain)) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "Payment amount is grater than grand total. Please check !!!"),
                                  duration: const Duration(milliseconds: 800),
                                  action: SnackBarAction(
                                      label: "Dismiss",
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      }),
                                ));
                                return;
                              } else if (double.parse(paycontroller.text) <=
                                  0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text("Please enter amount"),
                                  duration: const Duration(milliseconds: 800),
                                  action: SnackBarAction(
                                      label: "Dismiss",
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      }),
                                ));

                                return;
                              } else {
                                bool? b = payadd.additems(
                                    mode.paymentModeID!,
                                    _buttonselecteddval,
                                    double.parse(paycontroller.text));
                                paycontroller.text = payadd.ramain;
                                if (b == false) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        "Please select another method"),
                                    duration: const Duration(milliseconds: 800),
                                    action: SnackBarAction(
                                        label: "Dismiss",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        }),
                                  ));
                                }
                              }
                            },
                            icon: const Icon(Icons.add)),
                      )
                    ],
                  )),
          const Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 70.w,
                child: SizedBox(
                  child: Text(
                    "NET AMOUNT",
                    style: titleStyle1,
                  ),
                ),
              ),
              SizedBox(
                  width: 50.w,
                  child: SizedBox(
                    child: Text("TAX", style: titleStyle1),
                  )),
              SizedBox(
                  width: 70.w,
                  child: SizedBox(
                    child: Text("GRAND TOTAL", style: titleStyle1),
                  ))
            ],
          ),
          const Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: ispotriat
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 70.w,
                child: SizedBox(
                  child: Text(
                    (widget.amount - cart.disData).toStringAsFixed(2),
                    style: titleStyle1,
                  ),
                ),
              ),
              SizedBox(
                  width: 50.w,
                  child: SizedBox(
                    child: Text("15%", style: titleStyle1),
                  )),
              SizedBox(
                  width: 70.w,
                  child: SizedBox(
                    child: Text(gt.toStringAsFixed(2), style: titleStyle1),
                  ))
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartt, _1) => Container(
              margin: EdgeInsets.only(top: 4.h, right: 5.w),
              height: 32.h,
              width: ispotriat ? 200.w : 300.w,
              padding: EdgeInsets.all(2.h),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: cartt.remarkscontroller,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Consumer<Cart>(
              builder: (_, cartt, _1) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FittedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            final order =
                                Provider.of<Order>(context, listen: false);
                            if (cartt.items.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "Atleast one product has to be added."),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (p.items.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "At least one payment mode has to be added"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (double.parse(p.ramain) != 0.00) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "Payment is not equal to the grandtotal"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (qrdata == null) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text("Scan to add Customer Type"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                          title: const Text("Confirm!"),
                                          content: const Text(
                                              "Are you sure to order this sales?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text("Cancel")),
                                            ElevatedButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  if (order.pOSSalesMasterID ==
                                                      null) {
                                                    order.addtodb(
                                                        qrdata.cusid,
                                                        cartt.items.values
                                                            .toList(),
                                                        widget.amount,
                                                        gt,
                                                        15,
                                                        cartt.remarkscontroller
                                                            .text,
                                                        widget.uid,
                                                        widget.discounttype,
                                                        cart.disData,
                                                        false,
                                                        null,
                                                        null,
                                                        null,
                                                        p.items.values.toList(),
                                                        1,
                                                        3);
                                                  } else {
                                                    order.edittodb(
                                                      cartt.remarkscontroller
                                                          .text,
                                                      cartt.items.values
                                                          .toList(),
                                                      widget.amount,
                                                      gt,
                                                      widget.discounttype,
                                                      cart.disData,
                                                    );
                                                  }
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushNamed('draftscreen');
                                                  print(Provider.of<PayA>(
                                                          context,
                                                          listen: false)
                                                      .total);
                                                  cartt.clear();
                                                  cart.disData = 0;
                                                  cartt.disData = 0.0;
                                                  Provider.of<PayA>(context,
                                                          listen: false)
                                                      .clear();

                                                  cartt.remarkscontroller
                                                      .clear();
                                                  cartt.discountcontroller
                                                      .clear();
                                                  paycontroller.clear();
                                                })
                                          ]));
                            }
                          },
                          child: Text(
                            "Save Order",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(primary: button),
                        ),
                      ),
                      FittedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            if (cartt.items.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "Atleast one product has to be added."),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (p.items.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "At least one payment mode has to be added"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (double.parse(p.ramain) != 0.00) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "Payment is not equal to the grandtotal"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else if (qrdata == null) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text("Scan to add Customer Type"),
                                duration: const Duration(milliseconds: 800),
                                action: SnackBarAction(
                                    label: "Dismiss",
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text("Confirm!"),
                                        content: const Text(
                                            "Are you sure to order this sales?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Cancel")),
                                          ElevatedButton(
                                              child: const Text("OK"),
                                              onPressed: () async {
                                                Provider.of<Order>(context,
                                                        listen: false)
                                                    .addtodb(
                                                        qrdata.cusid,
                                                        cartt.items.values
                                                            .toList(),
                                                        widget.amount,
                                                        gt,
                                                        15,
                                                        cartt.remarkscontroller
                                                            .text,
                                                        widget.uid,
                                                        widget.discounttype,
                                                        cart.disData,
                                                        false,
                                                        null,
                                                        null,
                                                        null,
                                                        p.items.values.toList(),
                                                        1,
                                                        1);
                                                await printfunction();
                                                cartt.clear();
                                                Provider.of<PayA>(context,
                                                        listen: false)
                                                    .clear();
                                                cart.disData = 0;
                                                cartt.disData = 0.0;
                                                cartt.remarkscontroller.clear();

                                                cartt.discountcontroller.text =
                                                    "0";

                                                paycontroller.clear();
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      "Sucessfully placed the order."),
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  action: SnackBarAction(
                                                      label: "Dismiss",
                                                      onPressed: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                      }),
                                                ));
                                              })
                                        ],
                                      ));
                            }
                          },
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: mainColor,
                          ),
                        ),
                      ),
                    ],
                  ))
        ]));
  }

  Widget dialog() {
    return AlertDialog(
      title: const Text("Confirm!"),
      content: const Text("Are you sure to order this sales?"),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"))
      ],
    );
  }

  printfunction() async {
    final cartitems = Provider.of<Cart>(context, listen: false).items;
    final cart = Provider.of<Cart>(context, listen: false);
    final payment = Provider.of<PayA>(context, listen: false);
    print(Provider.of<Cart>(context, listen: false).cusData);
    final image = await imageFromAssetBundle(
      "assets/images/aem.jpg",
    );
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData(
              image, cartitems.values.toList(), cart, payment);
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
