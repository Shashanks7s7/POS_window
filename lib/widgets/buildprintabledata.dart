import 'package:flutter/cupertino.dart';
import 'package:possystem/provider/cart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/fonts.dart';

 

 buildPrintableData(image, cartitems,cart,payment) {
 print(payment.items.values.toList());
   card(adonlist){
    print("dfdddddddddddddd");
    print(adonlist);
   var len=adonlist==null?[]:adonlist.values.toList(); 
  return pw.Container(
    child: pw.Column(
      children:[
 for(int j=0;j<len.length;j++)
  
   pw.Row(
             mainAxisSize: pw.MainAxisSize.max,
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Container(
              height: 16.h,
              width: 125.w,
           padding: pw.EdgeInsets.only(left: 10),
              child: pw.FittedBox(
                fit: pw.BoxFit.none,
                child: pw.Text(
                  adonlist.values.toList()[j].adonname,
                  softWrap: false,
                  
                   style:
                  pw.TextStyle(fontSize: 6.00, ),
                ),
              ),
            ),
            pw.SizedBox(
              height: 16.h,
              width: 28.w,
              child: pw.FittedBox(
                child: pw.Text(  adonlist.values.toList()[j].adonquantity.toString(),
                   style:
                  pw.TextStyle(fontSize: 6.00, ),),
              ),
            ),
            pw.SizedBox(
                width: 45.h,
                height: 16.w,
                child: pw.FittedBox(
                  
                  child: pw.Text(
                      adonlist.values.toList()[j].unitprice.toStringAsFixed(2),
                   style:
                  pw.TextStyle(fontSize: 6.00, ),
                   
                  ),
                )),
            pw.SizedBox(
              height: 16.h,
              width: 45.w,
              child: pw.FittedBox(
                child: pw.Text(
                  (  adonlist.values.toList()[j].unitprice *   adonlist.values.toList()[j].adonquantity).toStringAsFixed(2),
                 
                   style:
                  pw.TextStyle(fontSize: 6.00, ), 
                ),
              ),
            ),
          ],
        )
      ] )
  );
  
}
var style=pw.TextStyle(
                    fontSize: 10.00, fontWeight: pw.FontWeight.bold);
  return pw.Padding(
      padding: const pw.EdgeInsets.all(5.00),
      child: pw.Column(children: [
        pw.Container(
          margin: pw.EdgeInsets.symmetric(vertical: 5.h, horizontal: 1.w),
          height: 60.h,
          width: 70.w,
          child: pw.Image(
            image,
            fit: pw.BoxFit.cover,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [pw.Text("Custormer Type"), pw.Text("Walk In")]),
        pw.SizedBox(height: 20.00),
        pw.Row(
          mainAxisSize: pw.MainAxisSize.max,
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
             pw.Container(
              height: 16.h,
              width: 125.w,
           
              child: pw.FittedBox(
                fit: pw.BoxFit.none,
                child:
            pw.Text(
              " Item",
              style:
                  pw.TextStyle(fontSize: 10.00, fontWeight: pw.FontWeight.bold),
            ),)),
            
            pw.Text("Quantity",
                style: pw.TextStyle(
                    fontSize: 10.00, fontWeight: pw.FontWeight.bold)),
            pw.Text("Rate",
                style: pw.TextStyle(
                    fontSize: 10.00, fontWeight: pw.FontWeight.bold)),
            pw.Text("Total",
                style: pw.TextStyle(
                    fontSize: 10.00, fontWeight: pw.FontWeight.bold))
          ],
        ),
        pw.Divider(
          thickness: 2,
        ),
        for(int i=0;i<cartitems.length;i++)
        pw.Column(
          children:[
 pw.Row(
          mainAxisSize: pw.MainAxisSize.max,
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
             pw.Container(
              height: 16.h,
              width: 125.w,
           
              child: pw.FittedBox(
                fit: pw.BoxFit.none,
                child:
            pw.Text(
             cartitems[i].productname.toString(),
              style:
                  pw.TextStyle(fontSize: 8.00,fontWeight: pw.FontWeight.bold ),
            ),)),
             pw.SizedBox(
              height: 16.h,
              width: 28.w,
              child: pw.FittedBox( child:pw.Text( cartitems[i].quantity.toString(),
                style: pw.TextStyle(
                    fontSize: 8.00, )),)),
             pw.SizedBox(
              height: 16.h,
              width: 45.w,
              child: pw.FittedBox(
                child:pw.Text( cartitems[i].unitprice.toStringAsFixed(2),
                style: pw.TextStyle(
                    fontSize: 8.00, )),)),
          pw.SizedBox(
              height: 16.h,
              width: 45.w,
              child: pw.FittedBox(
                child:   pw.Text( (cartitems[i].unitprice*cartitems[i].quantity).toStringAsFixed(2),
                style: pw.TextStyle(
                    fontSize: 8.00, ))))
          ],
        ),
       card(cartitems[i].selectedadonlist),
        pw.Container(
              width: 300.w,
              padding: pw.EdgeInsets.only(left: 30.w, right: 0.w),
              child: pw.Text(
              cartitems[i].message ?? "",
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontSize: 5,),
              ),
            )
          ] ),
          pw.SizedBox(height: 20),
           pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              mainAxisSize: pw.MainAxisSize.min,
                              
                              children: [
                              pw.SizedBox(
                                          width: 100.w,
                                          height: 18.h,
                                          child: pw.FittedBox(
                                            child: pw.Text('Sub Total: '+
                                               cart.totalamount.toStringAsFixed(2),
                                                
                                        ),
                                          ),
                                        )
                                       
                              ],
                            ),
pw.SizedBox(height: 20),
         pw.Row(
                        mainAxisSize: pw.MainAxisSize.max,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                           pw.Text(
                            " Discount",
                            
                          ),
                          pw.Text(cart.discount),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                       pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
                " Payment Mode",
              style: style
              ),
              pw.Text("Amount",
             style:style
                       )],
          ),
            pw.Divider(
            
            thickness: 2,
          ),
        for(int i=0;i<payment.items.values.toList().length;i++)
   pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
              payment.items.values.toList()[i].title  ,
            
              ),
              pw.Text(payment.items.values.toList()[i].amount.toString(),
            
                       )],
          ),
                      pw.SizedBox(height: 20),
           pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
                " NET AMOUNT",
              style: style
              ),
              pw.Text(cart.netamount.toStringAsFixed(2),
             style:style
                       )],
          ),
            pw.SizedBox(height: 20),
           pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
                " TAX",
              style: style
              ),
              pw.Text("15%",
             style:style
                       )],
          ),
            pw.SizedBox(height: 20),
           pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
           mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
                " GRAND AMOUNT",
              style: style
              ),
              pw.Text(payment.total.toString(),
             style:style
                       )],
          ),
        // for(int i=0;i<cartitems.length;i++)
        //     pw.Container(
        //       width: 300.w,
        //       padding: pw.EdgeInsets.only(left: 10.w, right: 5.w),
        //       child: pw.Text(
        //       cartitems.values.toList()[i].message ?? "",
                
        //         style: pw.TextStyle(fontSize: 11.sp,),
        //       ),
        //     )
          //  pw.SizedBox(
          //                 height: 235.h,
          //                 child: pw.ListView.builder(
          //                     itemCount: 0,
                          
          //                     itemBuilder: ( context, int index) {
          //                       return buildCartItemList(
          //                           carrt, carrt.items.values.toList()[index], index);
          //                     },
                            
          //                 ),
          //               ),
      ]),
    );
}
