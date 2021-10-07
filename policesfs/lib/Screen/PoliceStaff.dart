import 'dart:math';

import 'package:flutter/material.dart';
import 'package:policesfs/Screen/AddProduct.dart';
import 'package:policesfs/Screen/Addedit.dart';
import 'package:policesfs/Screen/PoliceStaff_database.dart';
import 'package:policesfs/Screen/Policestaffview.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/edit.dart';

class PoliceSaff extends StatelessWidget {
  static final routeName = 'PoliceSaff';
  final streams = FirebaseFirestore.instance
      .collection('PoliceStaff')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var stream;
    if (id != null) {
      stream = FirebaseFirestore.instance
          .collection('PoliceStaff')
          .where('PoliceStationID', isEqualTo: id)
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
                        'Manage Police Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueAccent)),
                            child: Text('Export pdf'),
                          ),
                        ),
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(bottom: 3),
                          child: TextField(
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
                            return Card(
                              elevation: 10,
                              child: PaginatedDataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('Name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Address',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Role',
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
                                source: MyData(snp.data?.docs, context),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline_sharp,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Addedit.routeName);
        },
        backgroundColor: Colors.red,
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
          DataCell(Text(_data[index].data()['Name'].toString())),
          DataCell(Text(_data[index].data()['PoliceStationName'].toString())),
          DataCell(Text(_data[index].data()['Role'].toString())),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () => {
                        Navigator.of(context).pushNamed(Addedit.routeName,
                            arguments: _data[index].id)
                      },
                  icon: Icon(Icons.edit),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  label: Text("Edit")),
              ElevatedButton.icon(
                  onPressed: () async => {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text(
                              'Do you want to delete Police Station ?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                              ),
                              TextButton(
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    PoliceStaffDatabase.DeletePoliceStaff(
                                        mainid: _data[index].id);
                                    Navigator.of(ctx).pop(false);
                                  }),
                            ],
                          ),
                        ),
                      },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  icon: Icon(Icons.edit),
                  label: Text("Delete")),
              ElevatedButton.icon(
                  onPressed: () => {
                        Navigator.of(context).pushNamed(
                            PoliceStaffView.routeName,
                            arguments: _data[index].id)
                      },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  icon: Icon(Icons.edit),
                  label: Text("View")),
            ],
          )),
        ]);
  }
}
