import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the PDF widget class.

/// Represents the PDF stateful widget class.
class CreatePdfComplaintsStatefulWidget extends StatefulWidget {
  /// Initalize the instance of the [CreatePdfStatefulWidget] class.
  static final routename = "complaintsreports";
  const CreatePdfComplaintsStatefulWidget({Key? key}) : super(key: key);

  @override
  _CreatePdfComplaintsState createState() => _CreatePdfComplaintsState();
}

class _CreatePdfComplaintsState
    extends State<CreatePdfComplaintsStatefulWidget> {
  final name = TextEditingController();

  final filter = TextEditingController();
  final fil = TextEditingController();

  var select;
  selectdate() {
    showDatePicker(
            context: context,
            // currentDate: _editedProduct.DateofEstablish,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((picked) => {
              if (picked == null)
                {print(2)}
              else
                setState(() => select = picked)
            });
  }

  var _isInit = true;
  var _isLoading = false;
  final List<Map<String, dynamic>> filterby = [
    {
      'value': 'Complete List',
      'label': 'Complete List',
    },
    {
      'value': 'Current Month',
      'label': 'Current Month',
    },
    {
      'value': 'Current Year',
      'label': 'Current Year',
    },
    {
      'value': 'Registered Today',
      'label': 'Registered Today',
    },
    {
      'value': 'Registered After',
      'label': 'Registered After',
    },
    {
      'value': 'Registered Before',
      'label': 'Registered Before',
    },
    {
      'value': 'Day Report',
      'label': 'Day Report',
    },
    {
      'value': 'Yearly Report',
      'label': 'Yearly Report',
    },
    {
      'value': 'Monthly Report',
      'label': 'Monthly Report',
    },
  ];
  final List<Map<String, dynamic>> option = [
    {
      'value': 'Complaint',
      'label': 'Complaint',
    },
    {
      'value': 'Criminal Record',
      'label': 'Criminal Record',
    },
  ];
  var streams;
  var stream;

  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      FirebaseFirestore.instance
          .collection("Complaints")
          .snapshots()
          .listen((c) {
        setState(() {
          streams = c;

          FirebaseFirestore.instance
              .collection("CriminalRecord")
              .snapshots()
              .listen((cd) {
            setState(() {
              stream = cd;
              _isLoading = false;
            });
          });
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
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
      body: Row(children: [
        if (width > 700)
          Flexible(
            flex: 2,
            child: Container(
              child: drawerwidget(),
            ),
          ),
        Expanded(
          flex: 6,
          child: Container(
              margin: EdgeInsets.all(10),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: 700,
                          child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: "Complaint",
                              labelText: 'Report Type',
                              items: option,
                              onChanged: (val) => setState(() {
                                    fil.text = val;
                                  })),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 700,
                          margin: EdgeInsets.only(bottom: 10),
                          child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: "Complete List",
                              labelText: 'Report by',
                              items: filterby,
                              onChanged: (val) => setState(() {
                                    filter.text = val;
                                  })),
                        ),
                        filter.text == "Registered After" ||
                                filter.text == "Registered Before" ||
                                filter.text == "Day Report" ||
                                filter.text == "Yearly Report" ||
                                filter.text == "Monthly Report"
                            ? Container(
                                padding: EdgeInsets.all(20),
                                child: TextButton(
                                  onPressed: selectdate,
                                  child: filter.text == "Yearly Report"
                                      ? Text(
                                          'Select year(Month and Day not matter)')
                                      : filter.text == "Monthly Report"
                                          ? Text(
                                              'Select Month and year(Day not matter)')
                                          : Text('Select date'),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 30),
                        TextButton(
                          child: const Text('Generate PDF'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.red,
                            onSurface: Colors.grey,
                          ),
                          onPressed: generateReport,
                        ),
                      ],
                    )),
        ),
      ]),
    );
  }

  Future<void> generateReport() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.save();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.

    Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
      AnchorElement(
          href:
              "data:application/octet-stream;charset-utf-161e;base64,${base64.encode(bytes)}")
        ..setAttribute('download', fileName)
        ..click();
    }

    await saveAndLaunchFile(bytes, 'Police Report.pdf');
  }

  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString('POLICE STATION FACILITATION SYSTEM',
        PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString(
        '\nJOHAR TOWN', PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Division', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber =
        'Report ID: 2058557939\r\n\r\nDate: ' + format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Report Generated By: \r\n\r\nPolice Operator,
        \r\n\r\nPakistan, Punjab, Lahore,
        \r\n\r\nHead Office R Block Johar town, \r\n\r\n04235125152''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    // page.graphics.drawString('Grand Total',
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         quantityCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         quantityCellBounds!.width,
    //         quantityCellBounds!.height));
    // page.graphics.drawString(getTotalAmount(grid).toString(),
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         totalPriceCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         totalPriceCellBounds!.width,
    //         totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        // ignore: leading_newlines_in_multiline_strings
        '''PIA Main Blvd.\r\n\r\nSuite R Block, Johar town,
         LHR 52102\r\n\r\nAny Questions? support@police-sfs.com''';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 8);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value =
        fil.text == "Criminal Record" ? "CrimeType" : 'ComplaintNo';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value =
        fil.text == "Criminal Record" ? "Description" : 'Title';
    headerRow.cells[2].value =
        fil.text == "Criminal Record" ? "IdentificationMark" : 'Type';
    headerRow.cells[3].value =
        fil.text == "Criminal Record" ? "Person Name" : 'Catagory';
    headerRow.cells[4].value =
        fil.text == "Criminal Record" ? "status" : 'status';
    headerRow.cells[5].value =
        fil.text == "Criminal Record" ? "Title" : 'sub category';
    headerRow.cells[6].value =
        fil.text == "Criminal Record" ? "Date added" : 'date';
    headerRow.cells[7].value =
        fil.text == "Criminal Record" ? "ImageUrl" : 'PoliceStationName';

    //Add rows

    fil.text == "Complaint" || fil.text == ""
        ? filter.text != "Complete List" && filter.text != ""
            ? streams.docs
                .map((val) => filter.text == "Current Year"
                    ? DateTime.parse(val.data()["date"].toDate().toString()).year.toInt() ==
                            DateTime.parse(DateTime.now().toString())
                                .year
                                .toInt()
                        ? addProducts(
                            val.id,
                            val.data()["Title"],
                            val.data()["Type"],
                            val.data()["Catagory"],
                            val.data()["status"],
                            val.data()["sub category"],
                            DateTime.parse(val.data()["date"].toDate().toString())
                                .toString(),
                            val.data()["PoliceStationName"],
                            grid)
                        : Container()
                    : filter.text == "Monthly Report"
                        ? DateTime.parse(val.data()["date"].toDate().toString()).year.toInt() ==
                                    select.year.toInt() &&
                                DateTime.parse(val.data()["date"].toDate().toString()).month.toInt() ==
                                    select.month.toInt()
                            ? addProducts(
                                val.id,
                                val.data()["Title"],
                                val.data()["Type"],
                                val.data()["Catagory"],
                                val.data()["status"],
                                val.data()["sub category"],
                                DateTime.parse(val.data()["date"].toDate().toString())
                                    .toString(),
                                val.data()["PoliceStationName"],
                                grid)
                            : Container()
                        : filter.text == "Yearly Report"
                            ? DateTime.parse(val.data()["date"].toDate().toString()).year.toInt() ==
                                    select.year.toInt()
                                ? addProducts(
                                    val.id,
                                    val.data()["Title"],
                                    val.data()["Type"],
                                    val.data()["Catagory"],
                                    val.data()["status"],
                                    val.data()["sub category"],
                                    DateTime.parse(val.data()["date"].toDate().toString())
                                        .toString(),
                                    val.data()["PoliceStationName"],
                                    grid)
                                : Container()
                            : filter.text == "Day Report"
                                ? DateTime.parse(val.data()["date"].toDate().toString()).day.toInt() == select.day.toInt() &&
                                        DateTime.parse(val.data()["date"].toDate().toString()).year.toInt() ==
                                            select.year.toInt() &&
                                        DateTime.parse(val.data()["date"].toDate().toString()).month.toInt() == select.month.toInt()
                                    ? addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)
                                    : Container()
                                : filter.text == "Registered Today"
                                    ? DateTime.parse(val.data()["date"].toDate().toString()).day == DateTime.parse(DateTime.now().toString()).day && DateTime.parse(val.data()["date"].toDate().toString()).month == DateTime.parse(DateTime.now().toString()).month && DateTime.parse(val.data()["date"].toDate().toString()).year == DateTime.parse(DateTime.now().toString()).year
                                        ? addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)
                                        : Container()
                                    : filter.text == "Current Month"
                                        ? DateTime.parse(val.data()["date"].toDate().toString()).month.toInt() == DateTime.parse(DateTime.now().toString()).month.toInt() && DateTime.parse(val.data()["date"].toDate().toString()).year.toInt() == DateTime.parse(DateTime.now().toString()).year.toInt()
                                            ? addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)
                                            : Container()
                                        : filter.text == "Registered After"
                                            ? DateTime.parse(val.data()["date"].toDate().toString()).isAfter(select)
                                                ? addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)
                                                : Container()
                                            : filter.text == "Registered Before"
                                                ? DateTime.parse(val.data()["date"].toDate().toString()).isBefore(select)
                                                    ? addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)
                                                    : Container()
                                                : Container())
                .toList()
            : streams.docs.map((val) => addProducts(val.id, val.data()["Title"], val.data()["Type"], val.data()["Catagory"], val.data()["status"], val.data()["sub category"], DateTime.parse(val.data()["date"].toDate().toString()).toString(), val.data()["PoliceStationName"], grid)).toList()
        : filter.text != "Complete List" && filter.text != ""
            ? stream.docs
                .map((val) => filter.text == "Current Year"
                    ? DateTime.parse(val.data()["Date added"].toDate().toString()).year.toInt() == DateTime.parse(DateTime.now().toString()).year.toInt()
                        ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                        : Container()
                    : filter.text == "Monthly Report"
                        ? DateTime.parse(val.data()["Date added"].toDate().toString()).year.toInt() == select.year.toInt() && DateTime.parse(val.data()["Date added"].toDate().toString()).month.toInt() == select.month.toInt()
                            ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                            : Container()
                        : filter.text == "Yearly Report"
                            ? DateTime.parse(val.data()["Date added"].toDate().toString()).year.toInt() == select.year.toInt()
                                ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                : Container()
                            : filter.text == "Day Report"
                                ? DateTime.parse(val.data()["Date added"].toDate().toString()).day.toInt() == select.day.toInt() && DateTime.parse(val.data()["Date added"].toDate().toString()).year.toInt() == select.year.toInt() && DateTime.parse(val.data()["Date added"].toDate().toString()).month.toInt() == select.month.toInt()
                                    ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                    : Container()
                                : filter.text == "Registered Today"
                                    ? DateTime.parse(val.data()["Date added"].toDate().toString()).day == DateTime.parse(DateTime.now().toString()).day && DateTime.parse(val.data()["Date added"].toDate().toString()).month == DateTime.parse(DateTime.now().toString()).month && DateTime.parse(val.data()["Date added"].toDate().toString()).year == DateTime.parse(DateTime.now().toString()).year
                                        ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                        : Container()
                                    : filter.text == "Current Month"
                                        ? DateTime.parse(val.data()["Date added"].toDate().toString()).month.toInt() == DateTime.parse(DateTime.now().toString()).month.toInt() && DateTime.parse(val.data()["Date added"].toDate().toString()).year.toInt() == DateTime.parse(DateTime.now().toString()).year.toInt()
                                            ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                            : Container()
                                        : filter.text == "Registered After"
                                            ? DateTime.parse(val.data()["Date added"].toDate().toString()).isAfter(select)
                                                ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                                : Container()
                                            : filter.text == "Registered Before"
                                                ? DateTime.parse(val.data()["Date added"].toDate().toString()).isBefore(select)
                                                    ? add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)
                                                    : Container()
                                                : Container())
                .toList()
            : stream.docs.map((val) => add(val.data()["CrimeType"], val.data()["Description"], val.data()["IdentificationMark"], val.data()["Person Name"], val.data()["status"], val.data()["Title"], DateTime.parse(val.data()["Date added"].toDate().toString()).toString(), val.data()["ImageUrl"], grid)).toList();

    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(
      String productId,
      String productName,
      String role,
      String division,
      String contact,
      String contacts,
      String contactss,
      String contactsss,
      PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = role;
    row.cells[3].value = division;
    row.cells[4].value = contact;
    row.cells[5].value = contacts;
    row.cells[6].value = contactss;
    row.cells[7].value = contactsss;
  }

  void add(
      String productId,
      String productName,
      String role,
      String division,
      String contact,
      String contacts,
      String contactss,
      String contactsss,
      PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = role;
    row.cells[3].value = division;
    row.cells[4].value = contact;
    row.cells[5].value = contacts;
    row.cells[6].value = contactss;
    row.cells[7].value = contactsss;
  }
  // //Get the total amount.
  // double getTotalAmount(PdfGrid grid) {
  //   double total = 0;
  //   for (int i = 0; i < grid.rows.count; i++) {
  //     final String value =
  //         grid.rows[i].cells[grid.columns.count - 1].value as String;
  //     total += double.parse(value);
  //   }
  //   return total;
  // }
}
