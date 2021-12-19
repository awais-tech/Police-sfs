import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:policesfs/Screen/Complaints.dart';
import 'package:policesfs/Screen/ComplaintsGraph.dart';
import 'package:policesfs/Screen/CriminalsRecordGraph.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarGraph extends StatefulWidget {
  static const routeName = '/bar-graph';

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  var _isInit = true;
  var _isLoading = false;
  var _charData = [EmployeesPerMonth(DateTime(2021, 1, 1), 5)];
  // void didChangeDependencies() async {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     FirebaseFirestore.instance
  //         .collection("PoliceStaff")
  //         .snapshots()
  //         .listen((c) {
  //       setState(() {
  //         streams = c;
  //         _isLoading = false;
  //       });
  //     });
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
  var streams =
      FirebaseFirestore.instance.collection("PoliceStaff").snapshots();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: StreamBuilder<Object>(
                  stream: streams,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot);
                      return Center(
                        child: Text("No Data is here"),
                      );
                    } else if (snapshot.hasData || snapshot.data != null) {
                      var x = getCharData(snapshot.data);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                  label: Text("View Criminal Record Graph")),
                              ElevatedButton.icon(
                                  onPressed: () => {
                                        Navigator.of(context).pushNamed(
                                          ComplaintsGraph.routeName,
                                        )
                                      },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  icon: Icon(Icons.auto_graph_sharp),
                                  label: Text("View Complaint Record Graph")),
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
                                  '${filter.text == "" ? "Day" : filter.text} wise Police Staff ',
                            ),
                            legend: Legend(isVisible: true),
                            series: <ChartSeries>[
                              BarSeries(
                                name: 'Police Staff',
                                color: Colors.deepPurple,
                                opacity: 0.9,
                                dataSource: x,
                                xValueMapper: (dynamic gdp, _) => gdp.month,
                                yValueMapper: (dynamic gdp, _) => gdp.count,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                                width: 0.6,
                                spacing: 0.3,
                              )
                            ],
                            primaryXAxis: DateTimeCategoryAxis(
                                dateFormat: filter.text == "Yearly"
                                    ? DateFormat.y()
                                    : filter.text == "Monthly"
                                        ? DateFormat.yMMM()
                                        : DateFormat.yMMMd()),
                            primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              title: AxisTitle(text: 'PoliceStaff in numbers'),
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                      ),
                    );
                  }),
            ),
    ));
  }

  List<EmployeesPerMonth> getCharData(datas) {
    var counts = {};

    datas.docs.forEach((x) {
      // Timestamp dates;

      var c = DateTime.parse(x.data()["dateofJoining"].toDate().toString());
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
  //       : filter.text == "CriminalRecord"
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
