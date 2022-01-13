import 'dart:math';
import 'package:policesfs/Screen/ComplaintsDatabase.dart';
import 'package:policesfs/Screen/ComplaintsView.dart';
import 'package:policesfs/Screen/CriminalRecordDatabase.dart';
import 'package:policesfs/Screen/CriminalView.dart';
import 'package:policesfs/Screen/client_database.dart';
import 'package:flutter/material.dart';
import 'package:policesfs/Screen/AddProduct.dart';
import 'package:policesfs/Screen/Addedit.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/edit.dart';
import 'package:select_form_field/select_form_field.dart';

class CriminalRecord extends StatefulWidget {
  static final routeName = 'CriminalRecord';

  @override
  State<CriminalRecord> createState() => _CriminalRecordState();
}

class _CriminalRecordState extends State<CriminalRecord> {
  var streams = FirebaseFirestore.instance
      .collection('CriminalRecord')
      .snapshots(includeMetadataChanges: true);

  final List<Map<String, dynamic>> _policeRoles = [
    {
      'value': 'CrimeType',
      'label': 'CrimeType',
    },
    {
      'value': 'Description',
      'label': 'Description',
    },
    {
      'value': 'IdentificationMark',
      'label': 'IdentificationMark',
    },
    {
      'value': 'status',
      'label': 'status',
    },
    {
      'value': 'Title',
      'label': 'Title',
    },
  ];

  final name = TextEditingController();

  final filter = TextEditingController();

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
                        'Manage Criminal Record Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(bottom: 3),
                          child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: "status",
                              labelText: 'Search By',
                              items: _policeRoles,
                              onChanged: (val) => setState(() {
                                    filter.text = val;
                                  })),
                        ),
                        Container(
                          width: 210,
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
                              labelText:
                                  'Search by ${filter.text == "" ? "status" : filter.text}',
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
                        stream: streams,
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
                                    "CrimeType":
                                        (val.data() as Map)["CrimeType"],
                                    "Description":
                                        (val.data() as Map)["Description"],
                                    "IdentificationMark": (val.data()
                                        as Map)["IdentificationMark"],
                                    "status": (val.data() as Map)["status"],
                                    "Title": (val.data() as Map)["Title"],
                                    "id": val.id
                                  };
                                })
                                .where((element) => filter.text == ""
                                    ? element["status"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.text.toLowerCase())
                                    : element[filter.text]
                                        .toString()
                                        .toLowerCase()
                                        .contains(name.text.toLowerCase()))
                                .toList();
                            return Card(
                              elevation: 10,
                              child: PaginatedDataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('ID',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Text('Status',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'CrimeType',
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
                                    'Police Station',
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
          DataCell(Text('CR${index.toString()}')),
          DataCell(Text(_data[index]['status'].toString())),
          DataCell(Text(_data[index]['CrimeType'].toString())),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () async => {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text(
                              'Do you want to delete that Criminal Record ?',
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
                                    CriminalRecords.DelCriminalRecord(
                                        mainid: _data[index]["id"]);

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
                        Navigator.of(context).pushNamed(CriminalView.routeName,
                            arguments: _data[index]["id"])
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
