import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:possystem/constants/fonts.dart';
import 'package:possystem/db/mydatabase.dart';
import 'package:possystem/models/pos_sales_master.dart';
import 'package:possystem/widgets/draftitem.dart';

import 'package:shared_preferences/shared_preferences.dart' as sp;

class DraftScreen extends StatefulWidget {
  const DraftScreen({Key? key}) : super(key: key);

  @override
  _DraftScreenState createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  List<POSSalesMaster> posmasterlist = [];
  bool isloading = false;
  Map loggedinuser = {};
  Future getposdata() async {
    setState(() {
      isloading = true;
    });
    posmasterlist = await MyDatabase.instance.readAllpossalesmaster(3);
    final prefs = await sp.SharedPreferences.getInstance();
    loggedinuser = jsonDecode(prefs.getString('loggedinuserinfo').toString());
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getposdata();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    bool ispotriat = orientation == Orientation.portrait;
    ispotriat
        ? ScreenUtil.init(
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
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/");
                            },
                            icon: Icon(Icons.arrow_back, size: 36.w)),
                        title: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text('Draft Items    ', style: headerStyle),
                          ),
                        )),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: ispotriat ? 5.w : 20.w),
                        //height:ispotriat?  800.h:(MediaQuery.of(context).size.height/1.3).h,
                        child: ListView.builder(
                            itemCount: posmasterlist.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return DraftItem(posmasterlist, index,
                                  loggedinuser['UserId'].toString());
                            }),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
