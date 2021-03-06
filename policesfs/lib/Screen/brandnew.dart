import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/Screen/CriminalRecord.dart';
import 'package:policesfs/Screen/CriminalsRecordGraph.dart';
import 'package:policesfs/Screen/GenerateReportStations.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class brandnew extends StatefulWidget {
  static const routeName = '/brandnew';

  @override
  _brandnewState createState() => _brandnewState();
}

class _brandnewState extends State<brandnew> {
  var _isInit = true;
  var _isLoading = false;
  var _charData = [EmployeesPerMonth(DateTime(2021, 1, 1), 5)];
  // void didChangeDependencies() async {
  //   if (_isInit) {
  //     // setState(() {
  //     //   _isLoading = true;
  //     // });

  //     // FirebaseFirestore.instance
  //     //     .collection("PoliceStaff")
  //     //     .snapshots()
  //     //     .listen((c) {
  //     //   setState(() {
  //     //     streams = c;
  //     //     _isLoading = false;
  //     //   });
  //     // });
  //     var url = Uri.parse(
  //         'https://creativeparkingsolutions.com/android_app/Allorder.php');
  //     var doc = await http.get(
  //       url,
  //       headers: {
  //         "Access-Control-Allow-Origin":
  //             "*", // Required for CORS support to work

  //         "Access-Control-Allow-Methods": "*"
  //       },
  //     );
  //     print(doc.statusCode);
  //     print(doc.statusCode);
  //     final extractedData = json.decode(doc.body);
  //     print(extractedData);
  //   }

  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  final List<Map<String, dynamic>> GraphType = [
    {
      'value': 'Monthly',
      'label': 'Monthly',
    },
    {
      'value': 'Yearly',
      'label': 'Yearly',
    },
    {
      'value': 'Day',
      'label': 'Day',
    },
  ];

  final filter = TextEditingController();

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work

    "Access-Control-Allow-Methods": "*"
  };

  Future fetch() async {
    var url = Uri.parse(
        'https://creativeparkingsolutions.com/android_app/Graphapi/GetGarages.php');
    var doc = await http.get(url);

    final extractedData = json.decode(doc.body);

    return extractedData;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: width < 700
          ? AppBar(
              backgroundColor: Colors.pink[900],
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(onPressed: () {}, child: Text('Logout'))))
          : null,
      drawer: width < 700 ? drawerwidget() : null,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                if (width > 700)
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: drawerwidget(),
                    ),
                  ),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                        future: fetch(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                              child: Text("No Data is here"),
                            );
                          } else if (snapshot.hasData ||
                              snapshot.data != null) {
                            print(snapshot.data);
                            var x = getCharData(snapshot.data);
                            var b = getCharData(snapshot.data);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () => {
                                              Navigator.of(context).pushNamed(
                                                BarGraph.routeName,
                                              )
                                            },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green)),
                                        icon: Icon(Icons.auto_graph_sharp),
                                        label: Text(
                                            "View Police Staff Record Graph")),
                                    ElevatedButton.icon(
                                        onPressed: () => {
                                              Navigator.of(context).pushNamed(
                                                CriminalRecordGraph.routeName,
                                              )
                                            },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green)),
                                        icon: Icon(Icons.auto_graph_sharp),
                                        label:
                                            Text("View Criminal Record Graph")),
                                  ],
                                ),
                                Container(
                                  width: 150,
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: SelectFormField(
                                      type: SelectFormFieldType
                                          .dropdown, // or can be dialog
                                      initialValue: "Day",
                                      labelText: 'GraphBy',
                                      items: GraphType,
                                      onChanged: (val) => setState(() {
                                            filter.text = val;
                                          })),
                                ),
                                SfCartesianChart(
                                  // isTransposed: true,
                                  title: ChartTitle(
                                    text:
                                        '${filter.text == "" ? "Day" : filter.text} wise Complaint Record',
                                  ),
                                  legend: Legend(isVisible: true),

                                  series: <ChartSeries>[
                                    BarSeries(
                                      name: 'Complaint Record',
                                      color: Colors.deepPurple,
                                      opacity: 0.9,
                                      dataSource: x,
                                      xValueMapper: (dynamic gdp, _) =>
                                          gdp.month,
                                      yValueMapper: (dynamic gdp, _) =>
                                          gdp.count,
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true),
                                      width: 0.6,
                                      spacing: 0.3,
                                    ),
                                    // BarSeries(
                                    //   name: 'Complaint Record',
                                    //   color: Colors.deepPurple,
                                    //   opacity: 0.9,
                                    //   dataSource: b,
                                    //   xValueMapper: (dynamic gdp, _) =>
                                    //       gdp.month,
                                    //   yValueMapper: (dynamic gdp, _) =>
                                    //       gdp.count,
                                    //   dataLabelSettings:
                                    //       DataLabelSettings(isVisible: true),
                                    //   width: 0.6,
                                    //   spacing: 0.3,
                                    // )
                                  ],
                                  primaryXAxis: DateTimeCategoryAxis(
                                      dateFormat: filter.text == "Yearly"
                                          ? DateFormat.y()
                                          : filter.text == "Monthly"
                                              ? DateFormat.yMMM()
                                              : DateFormat.yMMMd()),
                                  primaryYAxis: NumericAxis(
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift,
                                    title: AxisTitle(
                                        text: 'Complaint Records in numbers'),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orangeAccent),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
    ));
  }

  List<EmployeesPerMonth> getCharDat(datas) {
    var counts = {};

    datas.forEach((x) {
      // Timestamp dates;

      var c = DateTime.parse(x["Date"].toString());
      filter.text == "" || filter.text == "Day"
          ? counts[DateTime.parse(DateFormat('yyyy-MM-dd').format(c))] =
              (counts[DateTime.parse(DateFormat('yyyy-MM-dd').format(c))] ??
                      0) +
                  1
          : filter.text == "Yearly"
              ? counts[c.year] = (counts[c.year] ?? 0) + 1
              : filter.text == "Monthly"
                  ? counts['${c.year},${c.month}'] =
                      (counts['${c.year},${c.month}'] ?? 0) + 1
                  : 0;
    });

    final List<EmployeesPerMonth> charData = [
      ...counts.entries.map((e) => filter.text == "Yearly"
          ? EmployeesPerMonth(DateTime(e.key), e.value)
          : filter.text == "Monthly"
              ? EmployeesPerMonth(
                  (DateTime(int.parse((e.key.toString().split(",")[0])),
                      int.parse((e.key.toString().split(",")[1])))),
                  e.value)
              : EmployeesPerMonth(e.key, e.value))
    ];

    return charData;
  }

  List<EmployeesPerMonth> getCharData(datas) {
    var counts = {};
    print(datas);
    print(23);
    datas.forEach((x) {
      // Timestamp dates;

      var c = DateTime.parse(x["Date"].toString());
      filter.text == "" || filter.text == "Day"
          ? counts[DateTime.parse(DateFormat('yyyy-MM-dd').format(c))] =
              (counts[DateTime.parse(DateFormat('yyyy-MM-dd').format(c))] ??
                      0) +
                  1
          : filter.text == "Yearly"
              ? counts[c.year] = (counts[c.year] ?? 0) + 1
              : filter.text == "Monthly"
                  ? counts['${c.year},${c.month}'] =
                      (counts['${c.year},${c.month}'] ?? 0) + 1
                  : 0;
    });

    final List<EmployeesPerMonth> charData = [
      ...counts.entries.map((e) => filter.text == "Yearly"
          ? EmployeesPerMonth(DateTime(e.key), e.value)
          : filter.text == "Monthly"
              ? EmployeesPerMonth(
                  (DateTime(int.parse((e.key.toString().split(",")[0])),
                      int.parse((e.key.toString().split(",")[1])))),
                  e.value)
              : EmployeesPerMonth(e.key, e.value))
    ];

    return charData;
  }

  // Timestamp find(x) {
  //   return filter.text == "PoliceStation"
  //       ? x.data()["dateofEstablish"]
  //       : filter.text == "Complaints"
  //           ? x.data()["Date added"]
  //           : filter.text == "Complaints"
  //               ? x.data()["date"]
  //               : x.data()["dateofJoining"];
  // }
}

class EmployeesPerMonth {
  EmployeesPerMonth(this.month, this.count);
  final DateTime month;
  final int count;
}
