import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/customer.dart';
import 'package:possystem/models/ordertype.dart';
import 'package:possystem/models/payment_mode.dart';

import 'package:possystem/models/product.dart';
import 'package:possystem/models/product_adon_mapping_info.dart';

import 'package:possystem/models/productscategory.dart';
import 'package:possystem/models/product_adon.dart';
import 'package:possystem/provider/company_info.dart';
import 'package:possystem/provider/getsetup_api.dart';
import 'package:possystem/provider/loggedin_user.dart';
import 'package:provider/provider.dart';

class DataApiUpdate extends StatefulWidget {
  const DataApiUpdate({Key? key}) : super(key: key);

  @override
  _DataApiUpdateState createState() => _DataApiUpdateState();
}

class _DataApiUpdateState extends State<DataApiUpdate> {
  

  Future fetch() async {
    setState(() {
      isloading = true;
    });
 
    apidata = await Provider.of<GetSetupAPI>(context, listen: false).getdata();
    
    setState(() {
      isloading = false;
    });
  }

  var isloading = false;
  var apidata;
  var isloadingProcat = false;
  bool procatdone = false;
  var isloadingAdon = false;
  bool adondone = false;
  var isloadingProduct = false;
  bool productdone = false;
  bool isloadingorder = false;
  bool orderdone = false;
  bool isloadingpaymentmode = false;
  bool paymentmodedone = false;
  bool sinkcomplete = false;
  sync() async {
    ///////////////ProductCategory
    setState(() {
      isloadingProcat = true;
    });
    apidata = await Provider.of<GetSetupAPI>(context, listen: false).getdata();
    await Provider.of<CompanyInfo>(context, listen: false).fetchdata();
    await Provider.of<LoggedInUser>(context, listen: false).fetchdata();
    await MyDatabase.instance.deleteAllprocat();
    for (int i = 0; i < apidata['Data']['ProductCategory'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data = ProductsCategory(
        productCategoryID: apidata['Data']['ProductCategory'][i]
            ['ProductCategoryID'],
        categoryName:
            apidata['Data']['ProductCategory'][i]['CategoryName'].toString(),
        categoryCode:
            apidata['Data']['ProductCategory'][i]['CategoryCode'].toString(),
      );
      await MyDatabase.instance.createprocat(data);
    }
    setState(() {
      isloadingProcat = false;
      procatdone = true;
    });
    ////////////////////////////////////ProductAdon
    setState(() {
      isloadingAdon = true;
    });
    await MyDatabase.instance.deleteAlladon();
    for (int i = 0; i < apidata['Data']['ProductAdon'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data1 = ProductAdon(
        productAdonID: apidata['Data']['ProductAdon'][i]['ProductAdonID'],
        adonName: apidata['Data']['ProductAdon'][i]['AdonName'].toString(),
        adonCode: apidata['Data']['ProductAdon'][i]['AdonCode'].toString(),
        localAdonName:
            apidata['Data']['ProductAdon'][i]['LocalAdonName'].toString(),
        rate: apidata['Data']['ProductAdon'][i]['Rate'],
      );
      await MyDatabase.instance.createadon(data1);
    }
    setState(() {
      isloadingAdon = false;
      adondone = true;
    });
    //////////////////////////Products

    setState(() {
      isloadingProduct = true;
      
    });

    await MyDatabase.instance.deleteAllproduct();
    for (int i = 0; i < apidata['Data']['Product'].length; i++) {
      final data = Product(
          productID: apidata['Data']['Product'][i]['ProductID'],
          productName: apidata['Data']['Product'][i]['ProductName'].toString(),
          productCode: apidata['Data']['Product'][i]['ProductCode'].toString(),
          unitPrice: apidata['Data']['Product'][i]['UnitPrice'],
          image: apidata['Data']['Product'][i]['Image'].toString(),
          localName: apidata['Data']['Product'][i]['LocalName'].toString(),
          productCategoryID: apidata['Data']['Product'][i]['ProductCategoryID'],
          productStatus: apidata['Data']['Product'][i]['ProductStatus'],
          productCategoryName:
              apidata['Data']['Product'][i]['ProductCategoryName'].toString(),
          productAdons:
              apidata['Data']['Product'][i]['ProductAdons'].toString(),
          nonProductAdons:
              apidata['Data']['Product'][i]['NonProductAdons'].toString(),
          productAdonIds:
              apidata['Data']['Product'][i]['ProductAdonIds'].toString(),
          productAdonNames:
              apidata['Data']['Product'][i]['ProductAdonNames'].toString());
      await MyDatabase.instance.createproduct(data);
    }
    setState(() {
      isloadingProduct = false;
      productdone=true;
    });

    /////////////////////////////ProductAdonMappingInfo
setState(() {
      isloadingorder = true;
    });
    await MyDatabase.instance.deleteAllproductAdonMappingInfo();
    for (int i = 0; i < apidata['Data']['ProductAdonMappingInfo'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data1 = ProductAdonMappingInfo(
        productAdonMappingID: i,
        productID: apidata['Data']['ProductAdonMappingInfo'][i]['ProductID'],
        productAdonID: apidata['Data']['ProductAdonMappingInfo'][i]
            ['ProductAdonID'],
      );
    
      await MyDatabase.instance.createproductAdonMAppingInfo(data1);
    }
    ///////////////////////////////////////////Order
    
    await MyDatabase.instance.deleteAllordertype();
    for (int i = 0; i < apidata['Data']['OrderType'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data = OrderType(
        orderTypeID: apidata['Data']['OrderType'][i]['OrderTypeID'],
        orderTypeName:
            apidata['Data']['OrderType'][i]['OrderTypeName'].toString(),
        orderTypeCode:
            apidata['Data']['OrderType'][i]['OrderTypeCode'].toString(),
      );
      await MyDatabase.instance.createordertype(data);
    }
    await MyDatabase.instance.deleteAllcustomer();
    for (int i = 0; i < apidata['Data']['Customers'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data=Customer(
        customerID: apidata['Data']['Customers'][i]['CustomerID'],
        fullName: apidata['Data']['Customers'][i]['FullName'], address:apidata['Data']['Customers'][i]['Address'], status:0, email:apidata['Data']['Customers'][i]['Email'], phoneNo:apidata['Data']['Customers'][i]['PhoneNo'], createdBy: "", createdDate: DateTime.now(), modifiedBy:"", modifiedDate: DateTime.now());
      await MyDatabase.instance.createcustomer(data);
    }
    setState(() {
      isloadingorder = false;
      orderdone = true;
    });
    ///////////////////////////////////////////PaymentMODE
    setState(() {
      isloadingpaymentmode = true;
    });
    await MyDatabase.instance.deleteAllpaymentmode();
    for (int i = 0; i < apidata['Data']['PaymentMode'].length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      final data = PaymentMode(
        paymentModeID: apidata['Data']['PaymentMode'][i]['PaymentModeID'],
        name: apidata['Data']['PaymentMode'][i]['Name'].toString(),
        code: apidata['Data']['PaymentMode'][i]['Code'].toString(),
      );
      await MyDatabase.instance.createpaymentmode(data);
    }
    setState(() {
      isloadingpaymentmode = false;
      paymentmodedone = true;
    });
    setState(() {
      sinkcomplete = true;
    });
      Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          sinkcomplete = false;
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left_sharp,
                        size: 38.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        label: Text('Sync Now',style: titleStyle,),
                        onPressed: () {
                          if (!sinkcomplete) {
                            sync();
                          } else {
                            null;
                          }
                        },
                        icon: const Icon(Icons.sync),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => mainColor)),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ProductCategory",
                          style: titleStyle,
                        ),
                        if (isloadingProcat) const CircularProgressIndicator(),
                        if (procatdone) Icon(Icons.done,size: 28.w,),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ProductAdon",
                          style: titleStyle,
                        ),
                        if (isloadingAdon) const CircularProgressIndicator(),
                        if (adondone) Icon(Icons.done,size: 28.w,),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product",
                          style: titleStyle,
                        ),
                        if (isloadingProduct) const CircularProgressIndicator(),
                        if (productdone) Icon(Icons.done,size: 28.w,),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OrderType",
                          style: titleStyle,
                        ),
                        if (isloadingorder) const CircularProgressIndicator(),
                        if (orderdone) Icon(Icons.done,size: 28.w,),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PaymentMode",
                          style: titleStyle,
                        ),
                        if (isloadingpaymentmode) const CircularProgressIndicator(),
                        if (paymentmodedone) Icon(Icons.done,size: 28.w,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
