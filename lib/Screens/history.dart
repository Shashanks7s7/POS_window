import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'package:intl/intl.dart';
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
                        child: Column(
                          
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               FittedBox(
                                 child: Text("Net Amount: ${posmasterlist[index].netAmount}",style: titleStyle4,
                                                           ),
                               ),
                               FittedBox(
                                 child: Text( posmasterlist[index].discountType+" :  "+posmasterlist[index].discount.toString(),style: titleStyle4,
                                                           ),
                               ),
                              FittedBox(
                                child: Text("Grand Total: ${posmasterlist[index].grandTotal}",style: titleStyle4,
                                ),
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