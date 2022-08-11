import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/provider/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map companyinfo = {};
  Map loggedinuser = {};
  bool isloading = true;
  @override
  didChangeDependencies() async {
  
    final prefs = await SharedPreferences.getInstance();

    companyinfo = jsonDecode(prefs.getString('companyinfo').toString());
    loggedinuser = jsonDecode(prefs.getString('loggedinuserinfo').toString());
    
    super.didChangeDependencies();
    setState(() {
      isloading = false;
    });
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
     
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
            child: !ispotriat?landscape():
             SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 480.h,
                            decoration: const BoxDecoration(
                               image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/profile.jpg',
                                  ),
                                  fit: BoxFit.fill),
                           
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: ()=>Navigator.of(context).pop(), 
                              
                              
                              icon: Icon(Icons.arrow_back,size: 38.w,)),
                           
                              Row(
                               
                                children: [
                                  ElevatedButton.icon(onPressed: (){Navigator.of(context).pushNamed('history');},
                                  
                                  style:  ElevatedButton.styleFrom(
                          primary: secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          shadowColor:Colors.black
                        ),
                                                 icon: const Icon(Icons.history_edu_outlined), label: Text("History",style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),)),
                                 SizedBox(width: 10.w), 
                                   ElevatedButton.icon(onPressed: (){ Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacementNamed('/');
                                    Provider.of<Auth>(context,listen: false).logout();
                                    },
                                    style:  ElevatedButton.styleFrom(
                          primary: secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          shadowColor:Colors.black
                        ),
              
              
                                     icon: const Icon(Icons.logout),
                                     
                                      label: Text("LogOut",style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),)),
                               SizedBox(width: 10.w),
                                ],
                              ),
                              
                            ],
                          ),
                           Positioned(
                      left: 200.w,
                      top: 57.h,
                      child: Container(
                        height: 181.h,
                        width: 200.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Stack(
                          children: [
                            Center(
                            child: Container(
                              height: 181.h,
                              width: 181.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  )),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                 backgroundImage: AssetImage('assets/images/logo1.png')
                                ),
                              ),
                            ),
                          
                              
                              
                             
                          ],
                        ),
                      ),
                    ),
          
                          Positioned(
                            top: 261.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                              height: 300.h,
                              width: 600.w,
                              child: Column(
                                children: [
                                  FittedBox(
                                    alignment: Alignment.center,
                                    child: Text(
                                      companyinfo['companyname'],
                                      style:headerStyle
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.home,
                                        color: Colors.black54,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          companyinfo['address'],
                                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: Colors.blueGrey)
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () => ul.launch(
                                              "tel://${companyinfo['phoneno']}"),
                                          icon: Icon(
                                            Icons.call,
                                            color: Colors.green,
                                            size: 40.w,
                                          )),
                                      IconButton(
                                          onPressed: () => ul.launch(
                                              "mailto://${companyinfo['phoneno']}"),
                                          icon: Icon(
                                            Icons.mail,
                                            color: Colors.red,
                                            size: 40.w,
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 6.w,vertical: 6.h),
                      elevation: 25,
                      child: Container(
                          height: 370.h,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                          padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Logged In User Information",
                                  style: TextStyle(fontSize: 19.sp,fontWeight: FontWeight.w700)),
                              SizedBox(
                                height: 15.h,
                              ),
                              rowww('User ID', loggedinuser['UserId'].toString()),
                              rowww("User Name",
                                  loggedinuser['Username'].toString()),
                              rowww("User Group ID",
                                  loggedinuser['UserGroupId'].toString()),
                              rowww("User Group Name",
                                  loggedinuser['UserGroupName'].toString()),
                              rowww("Employee ID",
                                  loggedinuser['EmployeeID'].toString()),
                              rowww("Employee Code",
                                  loggedinuser['EmployeeCode'].toString()),
                              rowww("First Name",
                                  loggedinuser['FirstName'].toString()),
                              rowww("Middle Name",
                                  loggedinuser['MiddleName'].toString()),
                              rowww("Last Name",
                                  loggedinuser['Last Name'].toString()),
                              rowww("Email", loggedinuser['Email'].toString())
                            ],
                          )),
                    ),
                  ],
                ),
              ),
          ),
    );
  }

  Widget rowww(String na, String ya) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          na,
          style:titleStyle,
        ),
        Text(ya, style: titleStyle1)
      ],
    );
  }
 Widget landscape(){
   return  SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Container(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: const BoxDecoration(
                                     image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/profile.jpg',
                                        ),
                                        fit: BoxFit.fill),
                                 
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back,size: 38.w,)),
                                 
                                    Row(
                                     
                                      children: [
                                        ElevatedButton.icon(onPressed: (){Navigator.of(context).pushNamed('history');}, icon: const Icon(Icons.history_edu_outlined,), 
                                        style:  ElevatedButton.styleFrom(
                          primary: secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          shadowColor:Colors.black
                        ),
              
                                        
                                        label: Text("History",style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),)),
                                       SizedBox(width: 10.w), 
                                         ElevatedButton.icon(onPressed: (){ Navigator.of(context).pop();
                                            Navigator.of(context).pushReplacementNamed('/');
                                          Provider.of<Auth>(context,listen: false).logout();
                                          }, icon: const Icon(Icons.logout,), 
                                          style:  ElevatedButton.styleFrom(
                          primary: secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          shadowColor:Colors.black
                        ),
              
                                          label: Text("LogOut",style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),)),
                                     SizedBox(width: 10.w),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                                 Positioned(
                            left: 150.w,
                            top:80.h,
                            child: Container(
                              height: 181.h,
                              width: 200.h,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Stack(
                                children: [
                                  Center(
                                  child: Container(
                                    height: 181.h,
                                    width: 181.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        )),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                       backgroundImage: AssetImage('assets/images/logo1.png')
                                      ),
                                    ),
                                  ),
                                
                                    
                                    
                                   
                                ],
                              ),
                            ),
                          ),
                              
                                Positioned(
                                  top: 300.h,
                                 
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 5.h),
                                    height: 300.h,
                                    width: 480.w,
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          alignment: Alignment.center,
                                          child: Text(
                                            companyinfo['companyname'],
                                            style:headerStyle
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.home,
                                              color: Colors.black54,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                companyinfo['address'],
                                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: Colors.blueGrey)
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 35.h,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                onPressed: () => ul.launch(
                                                    "tel://${companyinfo['phoneno']}"),
                                                icon: Icon(
                                                  Icons.call,
                                                  color: Colors.green,
                                                  size: 40.w,
                                                )),
                                            IconButton(
                                                onPressed: () => ul.launch(
                                                    "mailto://${companyinfo['phoneno']}"),
                                                icon: Icon(
                                                  Icons.mail,
                                                  color: Colors.red,
                                                  size: 40.w,
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                               
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          
                        ],
                      ),
                    ),
Expanded(
  flex:5,
  child:    Container(
  
                                height: MediaQuery.of(context).size.height,
  
                              
  
                                margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
  
                                padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
  
                                decoration: BoxDecoration(
  
                                    borderRadius: BorderRadius.circular(10.r)),
  
                                child: Column(
  
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
                                  children: [
  
                                    Text("Logged In User Information",
  
                                        style: TextStyle(fontSize: 19.sp,fontWeight: FontWeight.w700)),
  
                                    SizedBox(
  
                                      height: 15.h,
  
                                    ),
  
                                    rowww('User ID', loggedinuser['UserId'].toString()),
  
                                    rowww("User Name",
  
                                        loggedinuser['Username'].toString()),
  
                                    rowww("User Group ID",
  
                                        loggedinuser['UserGroupId'].toString()),
  
                                    rowww("User Group Name",
  
                                        loggedinuser['UserGroupName'].toString()),
  
                                    rowww("Employee ID",
  
                                        loggedinuser['EmployeeID'].toString()),
  
                                    rowww("Employee Code",
  
                                        loggedinuser['EmployeeCode'].toString()),
  
                                    rowww("First Name",
  
                                        loggedinuser['FirstName'].toString()),
  
                                    rowww("Middle Name",
  
                                        loggedinuser['MiddleName'].toString()),
  
                                    rowww("Last Name",
  
                                        loggedinuser['Last Name'].toString()),
  
                                    rowww("Email", loggedinuser['Email'].toString())
  
                                  ],
  
                                )),
  
                          ),



                  ],
                ),
              );

  }
}
