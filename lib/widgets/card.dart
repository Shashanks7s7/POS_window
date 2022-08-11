import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';

import 'package:possystem/provider/cart.dart';


class Cardlist extends StatefulWidget {
  final CartItem cartModel;
   Cardlist(this.cartModel);

  @override
  _CardlistState createState() => _CardlistState();
}

class _CardlistState extends State<Cardlist> {
  @override
  Widget build(BuildContext context) {
    List<AdonItem> length = widget.cartModel.selectedadonlist==null?[]:widget.cartModel.selectedadonlist!.values.toList();
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: length.length,
      itemBuilder: (context, index) {
        var ado = length[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 16.h,
              width: 90.w,
              padding: EdgeInsets.only(left: 1.w),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  ado.adonname,
                  style: titleStyle3,
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
              width: 28.w,
              child: FittedBox(
                child: Text(ado.adonquantity.toString(), style: titleStyle3),
              ),
            ),
            SizedBox(
                width: 45.h,
                height: 16.w,
                child: FittedBox(
                  child: Text(
                    ado.unitprice.toStringAsFixed(2),
                    style: titleStyle3,
                  ),
                )),
            SizedBox(
              height: 16.h,
              width: 45.w,
              child: FittedBox(
                child: Text(
                  (ado.unitprice * ado.adonquantity).toStringAsFixed(2),
                  style: titleStyle3,
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
