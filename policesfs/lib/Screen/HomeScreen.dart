import 'package:flutter/material.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final staffsize = TextEditingController();
  final complaintc = TextEditingController();
  final complaintD = TextEditingController();
  final complaintP = TextEditingController();
  final complainta = TextEditingController();
  final user = TextEditingController();
  bool _isLoading = false;
  bool _isInit = true;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      FirebaseFirestore.instance.collection('PoliceStaff').get().then((snap) {
        staffsize.text = (snap.size).toString();
        FirebaseFirestore.instance
            .collection('Complaints')
            .where('status', isEqualTo: 'Complete')
            .snapshots()
            .listen((snap) {
          complaintc.text =
              (snap.size).toString(); // will return the collection size
          FirebaseFirestore.instance
              .collection('Complaints')
              .where('status', isEqualTo: 'Active')
              .get()
              .then((snap) {
            complainta.text =
                (snap.size).toString(); // will return the collection size
            FirebaseFirestore.instance.collection('user').get().then((snap) {
              user.text = (snap.size).toString();
              FirebaseFirestore.instance
                  .collection('Complaints')
                  .where('status', isEqualTo: 'pending')
                  .get()
                  .then((snap) {
                complaintP.text = (snap.size).toString();
                FirebaseFirestore.instance
                    .collection('Complaints')
                    .where('status', isEqualTo: 'disapprove')
                    .get()
                    .then((snap) {
                  complaintD.text = (snap.size).toString();
                  // will return the collection size
                  setState(() {
                    _isLoading = false;
                  });
                });
              });
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
    Map<String, double> dataMap = {
      "Completed Complaints":
          complaintc.text != "" ? double.parse(complaintc.text) : 0,
      "Active Complaints":
          complainta.text != "" ? double.parse(complainta.text) : 0,
      "Pending Complaints":
          complaintP.text != "" ? double.parse(complaintP.text) : 0,
      "Disapproved Complaints":
          complaintD.text != "" ? double.parse(complaintD.text) : 0,
    };
    Map<String, double> dataMa = {
      "User Registered":
          staffsize.text != "" ? double.parse(staffsize.text) : 0,
      "Police Staff Registered": user.text != "" ? double.parse(user.text) : 0,
    };
    return Scaffold(
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
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 340,
                                  height: 200,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 70,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Total Registered Staff",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          '${staffsize.text}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  height: 200,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.wifi_protected_setup_sharp,
                                          size: 70,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Active Complaints",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          '${complainta.text}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  height: 150,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: PieChart(
                                      dataMap: dataMa,
                                      animationDuration:
                                          Duration(milliseconds: 800),

                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: true,
                                      ),

                                      // gradientList: ---To add gradient colors---
                                      // emptyColorGradient: ---Empty Color gradient---
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            margin: width < 700
                                ? EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20)
                                : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 340,
                                  height: 200,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.verified_user_sharp,
                                          size: 70,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Total Registered Users",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          '${user.text}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  height: 200,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outlined,
                                          size: 70,
                                        ),
                                        FittedBox(
                                          child: Text(
                                            "Completed Complaints",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          '${complaintc.text}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 340,
                                  height: 150,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.blue[700],
                                    elevation: 10,
                                    child: PieChart(
                                      dataMap: dataMap,

                                      animationDuration:
                                          Duration(milliseconds: 800),
                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: true,
                                      ),

                                      // gradientList: ---To add gradient colors---
                                      // emptyColorGradient: ---Empty Color gradient---
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
