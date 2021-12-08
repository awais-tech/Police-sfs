import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class testing extends StatefulWidget {
  static final routename = "testing";
  @override
  State<testing> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<testing> {
  var save;
  var loading = false;
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        loading = true;
      });

      final result = FirebaseFirestore.instance
          .collection('PoliceStaff')
          .get()
          .then((result) {
        save = result.docs.map((val) => val.data()).toList();
        setState(() {
          loading = false;
        });
      });

      _isInit = false;

      super.didChangeDependencies();
    }
  }

  final staffsize = TextEditingController();
  final complaintc = TextEditingController();
  final complainta = TextEditingController();
  final user = TextEditingController();

  bool _isLoading = false;
  bool _isInit = true;
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const <int, pw.TableColumnWidth>{
              0: pw.IntrinsicColumnWidth(),
              1: pw.FlexColumnWidth(),
              2: pw.FixedColumnWidth(10),
            },
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: save
                .map(
                  (val, index) => pw.TableRow(
                    children: [
                      pw.Container(
                          height: 64, width: 128, child: pw.Text(val["Name"])),
                      pw.Container(
                        height: 32,
                      ),
                      pw.Center(
                        child: pw.Container(
                          height: 32,
                          width: 32,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width < 700
          ? AppBar(
              backgroundColor: Colors.pink[900],
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(onPressed: () {}, child: Text('Logout'))))
          : null,
      drawer: width < 700 ? drawerwidget() : null,
      body: !loading
          ? PdfPreview(
              build: (format) => _generatePdf(format, "ssd"),
            )
          : CircularProgressIndicator(),
    );
  }
}
