import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/product.dart';
import 'package:possystem/widgets/foodcard.dart';

class TestSearch extends StatefulWidget {
  const TestSearch({ Key? key }) : super(key: key);

  @override
  _TestSearchState createState() => _TestSearchState();
}

class _TestSearchState extends State<TestSearch> {
  List<Product>searchproducts=[];
   List<Product> allproducts = [];
   @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
   allproducts=await MyDatabase.instance.readAllproducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
  
    child:  ListView.builder(
     
         key: UniqueKey(),
         
          //  physics: const BouncingScrollPhysics(),
            itemCount:searchproducts.length,
            shrinkWrap: true,
            itemBuilder: (cont, index) {
              print("object+++++++++++++++++//////////////////////********************"+searchproducts.toString());
              return new FoodCard(product: searchproducts[index],key: UniqueKey(),);
            })
  )
        ],
      ),
      
    );
  }
}