import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarGraph extends StatefulWidget {
  static const routeName = '/bar-graph';

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  var streams;
  var stream;
  var _isInit = true;
  var _isLoading = false;
  var _charData = [EmployeesPerMonth(DateTime(2021, 1, 1), 2)];
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      FirebaseFirestore.instance
          .collection("PoliceStaff")
          .snapshots()
          .listen((c) {
        setState(() {
          streams = c;
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SfCartesianChart(
              // isTransposed: true,
              title: ChartTitle(
                text: 'Month wise Police Staff - 2021',
              ),
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                BarSeries(
                  name: 'employee',
                  color: Colors.deepPurple,
                  opacity: 0.9,
                  dataSource: getCharData(),
                  xValueMapper: (dynamic gdp, _) => gdp.month,
                  yValueMapper: (dynamic gdp, _) => gdp.count,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  width: 0.6,
                  spacing: 0.3,
                )
              ],
              primaryXAxis: DateTimeCategoryAxis(dateFormat: DateFormat.yMMM()),
              primaryYAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                title: AxisTitle(text: 'Employees in numbers'),
              ),
            ),
    ));
  }

  List<EmployeesPerMonth> getCharData() {
    var counts = {};
    streams.docs.forEach((x) {
      counts[x] = (counts[x] ?? 0) + 1;
    });
    final List<EmployeesPerMonth> charData = [
      ...streams.docs
          .map((doc, index) => EmployeesPerMonth(DateTime(2021, 1, 1), 4))
          .toList(),
    ];
    return charData;
  }
}

class EmployeesPerMonth {
  EmployeesPerMonth(this.month, this.count);
  final DateTime month;
  final int count;
}
