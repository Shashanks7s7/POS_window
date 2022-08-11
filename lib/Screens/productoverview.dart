import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/dbinitializer.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/models/product_adon.dart';
import 'package:possystem/models/product_adon_mapping_info.dart';
import 'package:possystem/models/productscategory.dart';

import 'package:possystem/provider/cart.dart';


import 'package:possystem/widgets/foodcard.dart';
import 'package:possystem/widgets/sideposscreen.dart';

import 'package:provider/provider.dart';

class ProductsOverView extends StatefulWidget {
  const ProductsOverView({Key? key}) : super(key: key);

  @override
  State<ProductsOverView> createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  var value = 0;
  bool? isImageShown=true;
  var isloading = false;
  var isloadingcategory = false;
  List<ProductsCategory> procat = [];
  List<Product> products = [];
  List<AdonItem> adonitems = [];
  List<ProductAdon> productadon = [];
  List<ProductAdonMappingInfo> productadonmappinginfo = [];
  List<Product> searchproducts = [];
  List<Product> allproducts = [];
 

  @override
  void initState() {
    super.initState();

    refreshprocat();
  }

  Future refreshprocat() async {
    setState(() {
      isloading = true;
    });

    procat = await MyDatabase.instance.readAllprocat();


    Provider.of<DbInitializer>(context, listen: false).getpaymentmodes();
    Provider.of<DbInitializer>(context, listen: false).getprocat();
    allproducts = await MyDatabase.instance.readAllproducts();

    if (procat.isNotEmpty) {
      products =
          await MyDatabase.instance.readproduct(procat[0].productCategoryID!);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    ispotriat
        ?  ScreenUtil.init(
            context,
            designSize: const Size(600, 912),
          )
        : ScreenUtil.init(
            context,
            designSize: const Size(912, 600),
          );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isloading
          ? Center(
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Loading   ',
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor)),
                CircularProgressIndicator(
                  color: mainColor,
                ),
              ],
            ))
          : procat.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " No data",
                        style: titleStyle,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('sync'),
                          icon: const Icon(Icons.sync),
                          label: const Text("Sync Data"))
                    ],
                  ),
                )
              : SafeArea(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(flex: 4, child: SidePosScreen()),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            SafeArea(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: Text('MENU', style: headerStyle),
                                  ),
                                  const Spacer(),
                                  IconButton(icon: Icon(Icons.ad_units),onPressed: (){
setState(() {
  if(isImageShown!=null){
  isImageShown=!isImageShown!;
                                  }});
                                  },),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                title: Center(
                                                  child: Text("Search"),
                                                ),
                                                content: Column(
                                                  children: [
                                                    SizedBox(
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15.0),
                                                                prefixIcon:
                                                                    Icon(Icons
                                                                        .search),
                                                                hintText:
                                                                    "Search "),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            searchproducts = allproducts
                                                                .where((element) => (element
                                                                    .productName!
                                                                    .contains(value
                                                                        .toUpperCase())))
                                                                .toList();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 470.h,
                                                        child: ListView.builder(
                                                            key: UniqueKey(),

                                                            //  physics: const BouncingScrollPhysics(),
                                                            itemCount:
                                                                searchproducts
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              print("object+++++++++++++++++//////////////////////********************" +
                                                                  searchproducts
                                                                      .toString());
                                                              return new FoodCard(
                                                                product:
                                                                    searchproducts[
                                                                        index],
                                                                key:
                                                                    UniqueKey(),
                                                              );
                                                            }))
                                                  ],
                                                )));
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        size: 30.w,
                                      )),
                                ],
                              ),
                            ),
                            buildFoodFilter(),
                            const Divider(),
                            buildFoodList(),
                            checkoutButton(context)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget checkoutButton(context) {
    return Container(
        margin: EdgeInsets.only(top: 15.h),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        //color:mainColor,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('draftscreen'),
                icon: Icon(
                  Icons.drafts,
                  size: 22.w,
                ),
                label: FittedBox(
                  child: Text("Drafts"),
                ),
                style: ElevatedButton.styleFrom(
                    primary: secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    shadowColor: Colors.black),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('profile'),
                icon: Icon(
                  Icons.person,
                  size: 22.w,
                ),
                label: FittedBox(
                  child: Text("Profile"),
                ),
                style: ElevatedButton.styleFrom(
                    primary: secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('sync'),
                icon: Icon(
                  Icons.refresh,
                  size: 22.w,
                ),
                label: FittedBox(
                  child: Text("Sync"),
                ),
                style: ElevatedButton.styleFrom(
                    primary: secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    shadowColor: Colors.black),
              ),
            ),
          ],
        ));
  }

  Widget buildAppBar(conte) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text('MENU', style: headerStyle),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                          title: Center(
                            child: Text("Search"),
                          ),
                          children: [
                            SizedBox(
                              child: TextField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Search "),
                                onChanged: (value) {
                                  setState(() {
                                    searchproducts = allproducts
                                        .where((element) => (element
                                            .productName!
                                            .contains(value.toUpperCase())))
                                        .toList();
                                  });
                                },
                              ),
                            ),
                            Container(
                                height: 470.h,
                                child: ListView.builder(
                                    key: UniqueKey(),

                                    //  physics: const BouncingScrollPhysics(),
                                    itemCount: searchproducts.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          "object+++++++++++++++++//////////////////////********************" +
                                              searchproducts.toString());
                                      return new FoodCard(
                                        product: searchproducts[index],
                                        key: UniqueKey(),
                                      );
                                    }))
                          ],
                        ));
              },
              icon: Icon(
                Icons.search,
                size: 30.w,
              )),
        ],
      ),
    );
  }

  Widget buildFoodFilter() {
    return Container(
      height: 51.h,
    
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: List.generate(procat.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
            child: ChoiceChip(
              selectedColor: mainColor,
              //  shape: roundedRectangle12,
              labelStyle: TextStyle(
                  color: value == index ? Colors.white : Colors.black),
              label: Center(
                  child: Text(
                procat[index].categoryName.toString().split('.').last,
                style: subtitleStyle,
              )),
              selected: value == index,
              onSelected: (_) {
                setState(() {
                  value = index;
                });
                // refresh();
              },
            ),
          );
        }),
      ),
    );
  }

  Widget buildFoodList() {
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    var height = MediaQuery.of(context).size.height;
    final dat = Provider.of<DbInitializer>(context, listen: false)
        .categorizedproducts['$value'];
        print(MediaQuery.of(context).size.width.toString()+ispotriat.toString()+height.toString());
    return Expanded(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ispotriat ? 2 : 3,
                childAspectRatio:!isImageShown!? 1.2
                .h:
                ispotriat
                    ? height > 1000
                        ? 0.60.h
                        : 0.7
                    : height > 1000
                        ? 0.57.h
                        : height > 900
                            ? 0.75.h
                            : 0.8.h,
                crossAxisSpacing: 5.w,
                mainAxisSpacing: 4.h),
            physics: const BouncingScrollPhysics(),
            
            itemCount: dat == null ? products.length : dat.length,
            itemBuilder: (context, index) {
              return FoodCard(
                  product: dat == null ? products[index] : dat[index],
                  isImageShown: isImageShown,
                  );

            }));
  }

  Widget searchbox(cont) {
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    return SimpleDialog(
      title: Center(
        child: Text("Search"),
      ),
      children: [
        SizedBox(
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                prefixIcon: Icon(Icons.search),
                hintText: "Search "),
            onChanged: (value) {
              setState(() {
                searchproducts = allproducts
                    .where((element) =>
                        (element.productName!.contains(value.toUpperCase())))
                    .toList();
              });
            },
          ),
        ),
        Container(
            height: ispotriat ? 470.h : 150.h,
            child: ListView.builder(
                key: UniqueKey(),

                //  physics: const BouncingScrollPhysics(),
                itemCount: searchproducts.length,
                itemBuilder: (cont, index) {
                  print(
                      "object+++++++++++++++++//////////////////////********************" +
                          searchproducts.toString());
                  return new FoodCard(
                    product: searchproducts[index],
                    key: UniqueKey(),
                    isImageShown:isImageShown
                  );
                }))
      ],
    );
  }
}
