import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/Complaints.dart';
import 'package:policesfs/Screen/UserRegistered.dart';
import 'package:policesfs/Screen/UsercomplaintsGraph.dart';
import 'package:policesfs/Screen/drawner.dart';

class Userdetails extends StatefulWidget {
  static final routename = "Viewregistered";
  @override
  _UserdetailsState createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {
  bool _isLoading = false;
  bool _isInit = true;
  final staffsize = TextEditingController();
  final complaintc = TextEditingController();
  final complainta = TextEditingController();
  final user = TextEditingController();
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var id = ModalRoute.of(context)?.settings.arguments as String;
      FirebaseFirestore.instance
          .collection('Complaints')
          .where("Userid", isEqualTo: id)
          .snapshots()
          .listen((snap) {
        staffsize.text = (snap.size).toString();
        FirebaseFirestore.instance
            .collection('Complaints')
            .where('status', isEqualTo: 'Complete')
            .where("Userid", isEqualTo: id)
            .snapshots()
            .listen((snap) {
          complaintc.text =
              (snap.size).toString(); // will return the collection size
          FirebaseFirestore.instance
              .collection('Complaints')
              .where('status', isEqualTo: 'active')
              .where("Userid", isEqualTo: id)
              .snapshots()
              .listen((snap) {
            complainta.text = (snap.size).toString();
            setState(() {
              _isLoading = false;
            }); // will return the
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as String;

    final stream =
        FirebaseFirestore.instance.collection('user').doc(id).snapshots();
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
      body: Row(
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
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: Column(children: [
                        Text(
                          'Detail of Complaints',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _isLoading
                            ? CircularProgressIndicator()
                            : Center(
                                child: SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.2,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Card(
                                        color: Colors.grey[200],
                                        elevation: 34,
                                        shadowColor: Colors.blueGrey[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: StreamBuilder(
                                            stream: stream,
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snap) {
                                              return Row(children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        radius: 80.0,
                                                        child: ClipRRect(
                                                          child: Image.asset(
                                                              'assets/images/police.png'),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["name"],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Age:${(snap.data!.data() as Map)["age"]}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blueGrey[700],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Total Complaints Registered: ${staffsize.text}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Total Solved Complaints: ${complaintc.text}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Total Active Complaints: ${complainta.text}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            var id =
                                                                snap.data!.id;

                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                              Complaints
                                                                  .routeName,
                                                              arguments: {
                                                                "User": id
                                                              },
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                            .blue[
                                                                        700]),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            )),
                                                          ),
                                                          child: Text(
                                                              "View Complaints Details")),
                                                      SizedBox(height: 15),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            var ids =
                                                                snap.data!.id;
                                                            var id =
                                                                snap.data!.id;
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                              UserComplaintGraph
                                                                  .routeName,
                                                              arguments: {
                                                                "id": id,
                                                                "ids": ids
                                                              },
                                                            );
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                            .blue[
                                                                        700]),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            )),
                                                          ),
                                                          child: Text(
                                                              "View Complaint Graph ")),
                                                    ],
                                                  ),
                                                ),
                                                VerticalDivider(thickness: 2),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "User Information",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .blueGrey[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Email",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["email"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Phone Number",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["phoneno"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Address",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["address"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Personal Information",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors
                                                              .blueGrey[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Area",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["area"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "House no",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        (snap.data!.data()
                                                            as Map)["houseNo"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]);
                                            }))))
                      ]))))
        ],
      ),
    );
  }
}
      // body:
  
