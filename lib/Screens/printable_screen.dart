import 'package:flutter/material.dart';
import 'package:possystem/provider/order.dart';
import 'package:possystem/provider/payadd.dart';
import 'package:possystem/widgets/buildprintabledata.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
class PrintableScreen extends StatefulWidget {
  const PrintableScreen({Key? key}) : super(key: key);

  @override
  State<PrintableScreen> createState() => _PrintableScreenState();
}

class _PrintableScreenState extends State<PrintableScreen> {
  @override
  Widget build(BuildContext contextt) {
  final cartitems= Provider.of<Cart>(context).items;
final cart=Provider.of<Cart>(context);
final payment=Provider.of<PayA>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Print"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Hello everyone"),
            ElevatedButton(onPressed: ()async{
                final image = await imageFromAssetBundle(
      "assets/images/aem.jpg",
    );
              final doc = pw.Document();
              doc.addPage(pw.Page(
                pageFormat: PdfPageFormat.roll80,
                build: (pw.Context context){
                  return buildPrintableData(image,cartitems.values.toList(),cart,payment);
                }
              )) ;
               await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
            }, child: Text("Print"))
          ],
        ),
      ),
    );
  }
}