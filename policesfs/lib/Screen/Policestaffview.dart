import 'package:flutter/material.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceStaffView extends StatelessWidget {
  static final routeName = 'PoliceStaffView';
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as String;
    final stream = FirebaseFirestore.instance
        .collection('PoliceStaff')
        .doc(id)
        .snapshots();
    // .then((e) => {print(e.data()!['Address'])});
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
                child: Column(
                  children: [
                    Text(
                      'Detail of Police Staff',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: StreamBuilder(
                          stream: stream,
                          builder:
                              (context, AsyncSnapshot<DocumentSnapshot> snp) {
                            if (snp.hasError) {
                              print(snp);
                              return Center(
                                child: Text("No Data is here"),
                              );
                            } else if (snp.hasData || snp.data != null) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 1.2,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Card(
                                  color: Colors.grey[200],
                                  elevation: 34,
                                  shadowColor: Colors.blueGrey[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 80.0,
                                              child: ClipRRect(
                                                child: Image.network(
                                                    (snp.data!.data()
                                                        as Map)["imageUrl"]),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              (snp.data!.data() as Map)["Name"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Member since:  ${DateTime.parse((snp.data!.data() as Map)["dateofEstablish"].toDate().toString()).toString()}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey[700],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Total Complaints Register: 27",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Total Solved Complaints: 27",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue[700]),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  )),
                                                ),
                                                child: Text(
                                                    "View Complaints Detail"))
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(thickness: 2),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Official information",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blueGrey[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Address",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data()
                                                  as Map)["Address"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Email",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data()
                                                  as Map)["Email"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Phone no",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data()
                                                      as Map)["PhoneNo"]
                                                  .toString(),
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
                                                color: Colors.blueGrey[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Gender:",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data()
                                                  as Map)["Gender"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "CNIC",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data() as Map)["CNIC"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Nationality",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data()
                                                  as Map)["Nationality"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Police Station Division",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              (snp.data!.data() as Map)[
                                                  "PoliceStationDivision"],
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  var id =
                                                      (snp.data!.data() as Map)[
                                                          "PoliceStationID"];
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                    View.routeName,
                                                    arguments: id,
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue[700]),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  )),
                                                ),
                                                child:
                                                    Text("View Police Station"))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
