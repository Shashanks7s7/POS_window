import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../models/pos_sales_detail.dart';
import '../models/pos_sales_payment.dart';
import '../models/product.dart';
import '../models/product_adon_mapping_info.dart';
import '../provider/cart.dart';
import '../provider/order.dart';
import '../provider/payadd.dart';
class History extends StatefulWidget {
  const History({ Key? key }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<POSSalesMaster> posmasterlist=[];
  bool isloading=false;
   Map loggedinuser={};
Future getposdata() async{
  setState(() {
    isloading=true;
  });
  posmasterlist=await MyDatabase.instance.readAllpossalesmaster(1); 
  final prefs = await sp.SharedPreferences.getInstance();
      loggedinuser = jsonDecode(prefs. getString('loggedinuserinfo').toString());
  setState(() {
    isloading=false;
  });
}
 onedit(int ids, context,int index) async {
    final order = Provider.of<Order>(context, listen: false);

    final cart = Provider.of<Cart>(context, listen: false);
    final payadd = Provider.of<PayA>(context, listen: false);
    payadd.clear();
    var dat = posmasterlist[index];
    List<POSSalesDetail> possalesdetails =
        await MyDatabase.instance.readpossalesdetails(ids);
    Customer customerdata =
        await MyDatabase.instance.readcutomer(dat.customerID);
    cart.clear();
    // order.pOSSalesMasterID = dat.pOSSalesMasterID;
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
@override
  void initState() {
  
    super.initState();
    getposdata();
  }
  @override
  Widget build(BuildContext context) {
     var orientation=MediaQuery.of(context).orientation;
  bool ispotriat=orientation==Orientation.portrait;
  ispotriat?  ScreenUtil.init(
            context,
            designSize: const Size(600, 912),
          )
        : ScreenUtil.init(
            context,
            designSize: const Size(912, 600),
          );
    return Scaffold(
    body: SafeArea(
      child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ListTile(leading:
            IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(Icons.arrow_back,size: 36.w)),
             title: Center(
               child: Padding(
                 padding: EdgeInsets.only(top:10.h),
                 child: Text('History      ', style: headerStyle),
               ),
             )
            ),
            
            SingleChildScrollView(
              child: Container(
              //  height: MediaQuery.of(context).size.height/1.1,
                  padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: ispotriat?5.w:20.w),
                child: ListView.builder(
                  
                    itemCount:posmasterlist.length,
                  
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Card(
                        child: SizedBox(
                    
                          child: ListTile(
                            title: Text("Sales No. ${posmasterlist[index].pOSSalesMasterID.toString()}",style: titleStyle,),
                            subtitle: Text( DateFormat('dd/MM/yyyy hh:mm').format(posmasterlist[index].createdDate),style: titleStyle3,),
                      trailing:FittedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: IconButton(onPressed: (){
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
                                     
                                 Provider.of<Order>(context,listen: false).pOSSalesMasterID =null;
                          onedit(posmasterlist[index].pOSSalesMasterID!,  context, index);
                                    },
                                    child: const Text("OK")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"))
                              ]);
                        });


                              }, icon: Icon(Icons.refresh,size:30.h)),
                            ),
                              Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: IconButton(onPressed: (){}, icon: Icon(Icons.print,size: 30.h,)),
                            ),
                            Column(
                              
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                   FittedBox(
                                     child: Text("Net Amount: ${posmasterlist[index].netAmount.toStringAsFixed(2)}",style: titleStyle4,
                                                               ),
                                   ),
                                   FittedBox(
                                     child: Text( "Discount"+" :  "+posmasterlist[index].discount.toStringAsFixed(2),style: titleStyle4,
                                                               ),
                                   ),
                                  FittedBox(
                                    child: Text("Grand Total: ${posmasterlist[index].grandTotal.toStringAsFixed(2)}",style: titleStyle4,
                                    ),
                                  ),
                                ],
                            ),
                          ],
                        ),
                      ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            
          ],
        ),
      ),
        
    );
  }
}