import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/models/product_adon.dart';
import 'package:possystem/models/product_adon_mapping_info.dart';

import 'package:possystem/provider/cart.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodCard extends StatefulWidget {
   final Product? product;
   final bool? isImageShown;
  
  const FoodCard({ Key? key, this.product, this.isImageShown}) : super(key: key);

  @override
  _FoodCardState createState() => _FoodCardState();
}







class _FoodCardState extends State<FoodCard> with SingleTickerProviderStateMixin {
 
  Product? get product => widget.product;
    List<ProductAdon> productadon=[];
 
  List<ProductAdonMappingInfo?> productadonmappinginfo=[];
  @override
  void initState() {
    super.initState();
  
  }
 
//   Future fetch()async{
    
    
//      productadon = await MyDatabase.instance.readAlladon();
//      adonitems = List<AdonItem>.generate(
//       productadon.length,
//       (index) => AdonItem(
//           adonid: productadon[index].productAdonID.toString(),
//           adonname: productadon[index].adonName.toString(),
//           unitprice: 5,
//           selected: false),
//     );
//   }
//  bool load=false;
//     Future getadondb(int id)async{
//        setState(() {
//          load=true;
//        });
//      var newlycreated=[];
//       productadonmappinginfo=await MyDatabase.instance.readproductadonid(id);
//       // List adonids=List.generate(productadonmappinginfo.length, (index) => productadonmappinginfo[index]!.productAdonID);
    
//       for (int i=0;i<productadonmappinginfo.length;i++)
//       {
//       newlycreated.addAll(await MyDatabase.instance.readproductadonasmap(productadonmappinginfo[i]!.productAdonID));
//       }
//       print("object"+newlycreated.toString());
    
//        adonitems =  List<AdonItem>.generate(
//       newlycreated.length,
//       (index) => AdonItem(
//           adonid: newlycreated[index].productAdonID.toString(),
//           adonname: newlycreated[index].adonName.toString(),
//           unitprice: 5,
//           selected: false));
//           print("k" +adonitems.toString());
//       setState(() {
//         load=false;
//       });
//   }
  

  @override
  Widget build(BuildContext context) {
     var isslected=Provider.of<Cart>(context).items.containsKey(product!.productID.toString());
    // print("fgdfgsdg"+isslected.toString());
    return Container(

      child:
      Consumer<Cart>(
                            builder: (_, carrt, _1) =>  Card(
color:mainColor,
        elevation: 2,
        shape: roundedRectangle12,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if(widget.isImageShown!) buildImage(),
              if(!widget.isImageShown!) SizedBox(height:50),
                buildTitle(),
               // buildRating(),
                buildPriceInfo(),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
            
              child: Container(
                padding: EdgeInsets.only(right: 5.w,top: 2.h),
              
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12.r)),
                ),
                child: Text(product!.productName.toString(),style: infoStyle,overflow: TextOverflow.fade,),
              ),
            ),
             Align(
              alignment: Alignment.topLeft,
             
                child:  Padding(
                  padding: EdgeInsets.only(top: 8.h,left:10.h),
                  child: SizedBox(
                    height: 30.h,
                    width:28.w,
                    
                    child: 
                     Transform.scale(
      scale: 2.2.h,child:
                    Checkbox(
                    splashRadius: 2,
                      activeColor: mainColor,
                      checkColor: Colors.white,
                      side: MaterialStateBorderSide.resolveWith(
      (states) => BorderSide(width: 1.5.h, color: Colors.white),),
                    value:carrt.items.containsKey(product!.productID.toString()),
                    onChanged: (df){
                     if(!isslected){
                      addItemToCard();
                     }
                     if(isslected){
                     
                       setState(() {
                          carrt.removeallitems(product!.productID.toString());
                      
                       });
                     }
                    },
               
              
              ),),
                  ),
                ),
            )
          ],
        ),
      ),)
    );
  }

  Widget buildImage() {
    return Padding(
      padding:  EdgeInsets.only(top:20.h),
      child: SizedBox(
        height: 120.h,
        
        child: ClipRRect(
      
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          child: FittedBox(
            child:CachedNetworkImage(
          imageUrl: '$BASE_URL${product!.image}',
        
         
          errorWidget: (context, url, error) => const Icon(Icons.error),
       ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      padding:  EdgeInsets.only(left: 4.w, right: 4.w),
      child:
         
             Text(
              product!.localName.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
             
              style: foodcardtitleStyle,
            ),
          
          // Text(
          //   product!.productCategoryID.toString(),
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          //   style: infoStyle,
          // ),
        
    );
  }
/*
  Widget buildRating() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RatingBar(
            initialRating: 5.0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 14,
            unratedColor: Colors.black,
            itemPadding: EdgeInsets.only(right: 4.0),
            ignoreGestures: true,
            itemBuilder: (context, index) => Icon(Icons.star, color: mainColor),
            onRatingUpdate: (rating) {},
          ),
          Text('(${food.rating})'),
        ],
      ),
    );
  }*/

  Widget buildPriceInfo() {
       final cartitem = Provider.of<Cart>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Card(
           
            shape: roundedRectangle4,
            color: Colors.red,
            child: InkWell(
              onTap: ()
              {
                cartitem.removesingleitem(product!.productID.toString());
                 
                },
              splashColor: Colors.white70,
              customBorder: roundedRectangle4,
              child: Icon(Icons.remove,size: 25.w,color: Colors.white,)
            ),
          ),
          Text(
            '\$ ${product!.unitPrice}',
            style: foodcardtitleStyle,
          ),
          Card(
           
            shape: roundedRectangle4,
            color: Colors.green,
            child: InkWell(
              onTap: addItemToCard,
              splashColor: Colors.white70,
              customBorder: roundedRectangle4,
              child: Icon(Icons.add,size: 25.w,color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

  addItemToCard()async {
    List<AdonItem> adonitems=[];
     var newlycreated=[];
      productadonmappinginfo=await MyDatabase.instance.readproductadonid(product!.productID!);
      // List adonids=List.generate(productadonmappinginfo.length, (index) => productadonmappinginfo[index]!.productAdonID);
    
      for (int i=0;i<productadonmappinginfo.length;i++)
      {
      newlycreated.addAll(await MyDatabase.instance.readproductadonasmap(productadonmappinginfo[i]!.productAdonID));
      }
     
      
       adonitems =  List<AdonItem>.generate(
      newlycreated.length,
      (index) => AdonItem(
          adonid: newlycreated[index].productAdonID.toString(),
          adonname: newlycreated[index].adonName.toString(),
          unitprice: 5,
          selected: false));
  
  
    await Provider.of<Cart>(context,listen: false).additems(product!.productID.toString() ,product!.unitPrice!, product!.productName!,product!.image!,adonitems,"" );
// Scaffold.of(context). hideCurrentSnackBar();
//                     Scaffold.of(context).showSnackBar(SnackBar(
//                       content: Text(
//                         "Added item to the cart",
//                         textAlign: TextAlign.center,
//                       ),
                      
//                       duration: Duration(milliseconds: 1500),
//                       action: SnackBarAction(label: "UNDO",
//                       onPressed: (){     Provider.of<Cart>(context,listen: false).removesingleitem(product!.productID.toString());}),
//                     ));
    // if (isAddSuccess) {
    //   final snackBar = SnackBar(
    //     content: Text('${product!.productName} added to cart'),
    //     action: SnackBarAction(
    //       label: 'view',
    //       onPressed: showCart,
    //     ),
    //     duration: Duration(milliseconds: 1500),
    //   );
    //   Scaffold.of(context).showSnackBar(snackBar);
    // } else {
    //   final snackBar = SnackBar(
    //     content: Text('You can\'t order from multiple shop at the same time'),
    //     duration: Duration(milliseconds: 1500),
    //   );
    //   // ignore: deprecated_member_use
    //   Scaffold.of(context).showSnackBar(snackBar);
    // }
    
  }

  //  showCart() {
  //    showModalBottomSheet(
  //      shape: roundedRectangle40,
  //      context: context,
  //      builder: (context) => CartBottomSheet(),
  //    );
  //  }
}