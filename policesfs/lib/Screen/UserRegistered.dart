import 'dart:math';
import 'package:flutter/material.dart';
import 'package:policesfs/Screen/AddProduct.dart';
import 'package:policesfs/Screen/Addedit.dart';
import 'package:policesfs/Screen/Addstaff.dart';
import 'package:policesfs/Screen/PoliceStaff_database.dart';
import 'package:policesfs/Screen/Policestaffview.dart';
import 'package:policesfs/Screen/RegisteredUsersDetails.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/edit.dart';

class UserRegistered extends StatefulWidget {
  static final routeName = 'UserRegistered';

  @override
  State<UserRegistered> createState() => _UserRegisteredState();
}

class _UserRegisteredState extends State<UserRegistered> {
  final streams = FirebaseFirestore.instance
      .collection('user')
      .snapshots(includeMetadataChanges: true);
  final name = TextEditingController();
  final filter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var stream;
    if (id != null) {
      stream = FirebaseFirestore.instance
          .collection('user')
          .doc(id as String)
          .snapshots();
    }
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
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Text(
                        'Manage Registered Users',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(bottom: 3),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                name.text = val;
                              });
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: Colors.blueAccent[50],
                              filled: true,
                              labelText: 'Search',
                              icon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              labelStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: id != null ? stream : streams,
                        builder: (context, snp) {
                          if (snp.hasError) {
                            print(snp);
                            return Center(
                              child: Text("No Data is here"),
                            );
                          } else if (snp.hasData || snp.data != null) {
                            var stationdata = snp.data?.docs
                                .map((val) {
                                  return {
                                    "address": (val.data() as Map)["address"],
                                    "age": (val.data() as Map)["age"],
                                    "area": (val.data() as Map)["area"],
                                    "city": (val.data() as Map)["city"],
                                    "email": (val.data() as Map)["email"],
                                    "houseNo": (val.data() as Map)["houseNo"],
                                    "name": (val.data() as Map)["name"],
                                    "phoneno": (val.data() as Map)["phoneno"],
                                    "streetNo": (val.data() as Map)["streetNo"],
                                    "id": val.id
                                  };
                                })
                                .where((element) => element.keys.any((elem) =>
                                    element[elem]
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.text.toLowerCase())))
                                .toList();

                            return Card(
                              elevation: 10,
                              child: PaginatedDataTable(
                                sortColumnIndex: 0,
                                sortAscending: true,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('ID',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text('name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Phone no',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Action',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                                source: MyData(stationdata, context),
                                header: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Police Staff',
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                columnSpacing: 50,
                                horizontalMargin: 10,
                                rowsPerPage: 6,
                                showCheckboxColumn: false,

                                //     .map(,
                                // rows: snp.data!.docs,
                                //     .map(
                                //       (val) => DataRow(
                                //         cells: <DataCell>[
                                //           DataCell(
                                //               Text((val.data() as Map)['address'])),
                                //           DataCell(
                                //               Text((val.data() as Map)['address'])),
                                //           DataCell(Row(
                                //             children: [
                                //               TextButton(
                                //                   onPressed: () => {},
                                //                   child: Text('View')),
                                //               TextButton(
                                //                   onPressed: () => {},
                                //                   child: Text('Delete')),
                                //               TextButton(
                                //                   onPressed: () => {},
                                //                   child: Text('Update')),
                                //             ],
                                //           )),
                                //         ],
                                //       ),
                                // )
                                // .toList());
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

class MyData extends DataTableSource {
  MyData(this._data, this.context);
  // Generate some made-up data
  final _data;
  BuildContext context;

  bool get isRowCountApproximate => false;
  int get rowCount => _data.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(
        color: index % 2 == 0
            ? MaterialStateProperty.all(Colors.lightGreen.withOpacity(0.12))
            : MaterialStateProperty.all(Colors.lightBlue.withOpacity(0.14)),
        cells: [
          DataCell(Text('U${index.toString()}')),
          DataCell(Text(_data[index]['name'].toString())),
          DataCell(Text(_data[index]['phoneno'].toString())),
          DataCell(Text(_data[index]['email'].toString())),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pushNamed(Userdetails.routename,
                              arguments: _data[index]["id"])
                        },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    icon: Icon(Icons.edit),
                    label: Text("View")),
              ],
            ),
          ),
        ]);
  }
}
