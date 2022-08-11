import 'dart:io';

import 'package:flutter/material.dart';
import 'package:possystem/Screens/draftscreen.dart';
import 'package:possystem/Screens/history.dart';
import 'package:possystem/Screens/printable_screen.dart';
import 'package:possystem/Screens/profilepage.dart';
import 'package:possystem/Screens/dataapiupdate.dart';
import 'package:possystem/Screens/splashScreen.dart';
import 'package:possystem/Screens/testsearch.dart';
import 'package:possystem/db/dbinitializer.dart';
import 'package:possystem/provider/payadd.dart';
import 'package:possystem/provider/auth.dart';
import 'package:possystem/provider/cart.dart';
import 'package:possystem/provider/company_info.dart';
import 'package:possystem/provider/getsetup_api.dart';
import 'package:possystem/provider/loggedin_user.dart';
import 'package:possystem/provider/order.dart';
import 'package:possystem/widgets/qrscannar.dart';
import 'package:provider/provider.dart';
import 'Screens/loginpage.dart';
import 'Screens/productoverview.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, CompanyInfo>(
          create: (context) => CompanyInfo(),
          update: (_, auth, comapanyinfo) =>
              comapanyinfo!..update(auth.token.toString()),
        ),
        ChangeNotifierProxyProvider<Auth, LoggedInUser>(
          create: (context) => LoggedInUser(),
          update: (_, auth, loggedininfo) => 
              loggedininfo!..update(auth.token.toString()),
        ),
        ChangeNotifierProxyProvider<Auth, GetSetupAPI>(
          create: (context) => GetSetupAPI(),
          update: (_, auth, getapi) => getapi!..update(auth.token.toString()),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
        ChangeNotifierProvider(
          create: (context) => PayA(),
        ),
        ChangeNotifierProvider(
          create: (context) => DbInitializer(),
        ),

        // ChangeNotifierProxyProvider<Auth,Order>(
        //   create: (context) => Order(),
        //   update: (_,aut,dat)=>dat!..orderlis(
        //     aut.token.toString(),
        //     aut.userId.toString()
        //   ),)
      ],
      
      child: Consumer<Auth>(builder: (context, auth, _) {
        return  MaterialApp(
            title: 'ALSMARTAEM',
            theme: ThemeData(
               
                textTheme: const TextTheme(
                    headline1:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    headline2:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            home: auth.authd
                ? const ProductsOverView()
                : FutureBuilder(
                    future: auth.tryautologin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : const AuthScreen()),
            routes: {
              'profile': (context) =>const PrintableScreen(),  //const Profile(),
              'sync': (context) => const DataApiUpdate(),
              'draftscreen': (context) => const DraftScreen(),
              'history':(context)=>const History(),
              'qrscanner':(context)=>const QrScanner(),
              'search':(context)=> const TestSearch(),
              'printscreen':(context)=>const PrintableScreen()
            },
          
        );
      }),
    );
  }}
  

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
