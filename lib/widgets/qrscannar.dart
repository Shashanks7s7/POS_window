import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:possystem/provider/order.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:possystem/models/qrdata.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class QrScanner extends StatefulWidget {
  const QrScanner({ Key? key }) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
   Barcode? result;
  QRViewController? controller;
   @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
        var ispotrait=MediaQuery.of(context).orientation==Orientation.portrait;
     var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.h
        : 500.h;
    
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: QRView(
            key:qrKey ,
            onQRViewCreated: _onQRViewCreated,
             overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea,
             )
            
          ),
        ),
         Expanded(
            flex: 1,
            child: Column(
              children: [
           if(ispotrait)      SizedBox(height: 25.h),
                Center(
                  child: (result != null)
                      ? Text(
                          ' Data: ${QrData.fromJson (jsonDecode(result!.code.toString())).name}',style: TextStyle(color: Colors.white,fontSize: 30.sp),)
                      : Text('Scan a code',style: TextStyle(color: Colors.white,fontSize: 50.sp),),
                ),
              ispotrait? SizedBox(height:25.h):SizedBox(height: 5.h,),
                Center(
                  child:(result != null)? ElevatedButton(onPressed:()=> Navigator.of(context).pop(), child:Text("Done") ):null,
                )
              ],
            ),
          )
      ],
    );
  }
   void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        var da=QrData.fromJson (jsonDecode(result!.code.toString()));
        Provider.of<Order>(context,listen: false).addqrdata(da.customerID!,da.name.toString(),null,null,null,null);
      });
  
    });
  }
   @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}