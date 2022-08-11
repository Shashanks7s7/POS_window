import 'dart:math';

import 'package:flutter/material.dart';

import 'package:possystem/models/exception.dart';
import 'package:possystem/provider/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          // height:deviceheight,
          // width:double.infinity,
          decoration: const BoxDecoration(
               gradient: LinearGradient(
                  colors: [ Color.fromRGBO(238, 49, 88,1), Color.fromRGBO(112, 71, 238,1)],
                 begin: Alignment.bottomLeft,
                   end: Alignment.topRight)
               
                  ),
        ),
        SingleChildScrollView(
          // ignore: sized_box_for_whitespace
          child: Container(
            height: deviceheight.height,
            width: deviceheight.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                  child: Text(
                    "ALSMARTAEM",
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.w900),
                  ),
                ),
                transform: Matrix4.rotationZ(-8 * pi / 100),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 49, 88,1),
                    borderRadius: BorderRadius.circular(18),
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ]),
              ),
              const SizedBox(
                height: 30,
              ),
              Flexible(
                  flex: deviceheight.width > 600 ? 2 : 1,
                  child: const AuthCard())
            ]),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> key = GlobalKey();

  Map<String, String> authData = {
    'clientid': '',
    'username': '',
    'password': ''
  };
  final _passwordcontroller = TextEditingController();
  var isloading = false;
 
  
  
  void showdialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("An Error Occured."),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Okay"),
              )
            ],
          );
        });
  }

  Future<void> onsaved() async {
    if (!key.currentState!.validate()) {
      return;
    }
    key.currentState!.save();
    setState(() {
      isloading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
          authData['clientid'].toString(),
          authData['username'].toString(),
          authData['password'].toString());
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email is already in use.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find an user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      showdialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you.Please try  again  later';
      showdialog(errorMessage);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 11,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        child: Container(
          //  height: _heightanimation!.value.height,
          height: 360,
          constraints: const BoxConstraints(minHeight: 260),
          //minHeight: _heightanimation!.value.height),
          width: devicesize.width * 0.75,
          padding: const EdgeInsets.all(15),

          child: Column(
            children: [
              const SizedBox(
                height: 50,
                width: 300,
                child: Center(child: Text("Login Form",style: TextStyle(fontSize: 29,color: Color.fromRGBO(112, 71, 238,1)
                
                ,fontWeight: FontWeight.w600),)),
              ),
              Form(
                  key: key,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Enter ClientId'),
                      keyboardType: TextInputType.name,
                      onSaved: (value) {
                        authData['clientid'] = value.toString();
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Enter UserName'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        authData['username'] = value.toString();
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      controller: _passwordcontroller,
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'Password is too short';
                        }
                      },
                      onSaved: (value) {
                        authData['password'] = value.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    if (isloading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(238, 49, 88,1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          shadowColor:Colors.black
                        ),
                        onPressed: onsaved,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 24,
                                fontFamily: 'Lato', fontWeight: FontWeight.w800,color: Colors.white),
                          ),
                        ),
                      ),
                  ]))),
            ],
          ),
        ),
      ),
    );
  }
}
