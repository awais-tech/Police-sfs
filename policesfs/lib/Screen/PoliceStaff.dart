import 'dart:math';

import 'package:flutter/material.dart';
import 'package:policesfs/Screen/AddProduct.dart';
import 'package:policesfs/Screen/Addedit.dart';
import 'package:policesfs/Screen/Addstaff.dart';
import 'package:policesfs/Screen/PoliceStaff_database.dart';
import 'package:policesfs/Screen/Policestaffview.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/drawner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/edit.dart';
import 'package:select_form_field/select_form_field.dart';

class PoliceSaff extends StatefulWidget {
  static final routeName = 'PoliceSaff';

  @override
  State<PoliceSaff> createState() => _PoliceSaffState();
}

class _PoliceSaffState extends State<PoliceSaff> {
  final streams = FirebaseFirestore.instance
      .collection('PoliceStaff')
      .snapshots(includeMetadataChanges: true);
  final name = TextEditingController();
  final filter = TextEditingController();
  final List<Map<String, dynamic>> _policeRoles = [
    {
      'value': 'Name',
      'label': 'Name',
    },
    {
      'value': 'PoliceStationDivision',
      'label': 'Police Station Division',
    },
    {
      'value': 'Role',
      'label': 'Role',
    },
    {
      'value': 'Email',
      'label': 'Email',
    }
  ];

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
                          width: 150,
                          margin: EdgeInsets.only(bottom: 3),
                          child: SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: "Name",
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
                                  'Search by ${filter.text == "" ? "Name" : filter.text}',
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
                                    "Name": (val.data() as Map)["Name"],
                                    "PoliceStationDivision": (val.data()
                                        as Map)["PoliceStationDivision"],
                                    "PoliceStaffId":
                                        (val.data() as Map)["PoliceStaffId"],
                                    "Role": (val.data() as Map)["Role"],
                                    "Email": (val.data() as Map)["Email"],
                                    "id": val.id,
                                    "Type": (val.data() as Map)["Type"],
                                    "ComplaintNo":
                                        (val.data() as Map)["ComplaintNo"]
                                  };
                                })
                                .where((element) => filter.text == ""
                                    ? element["Name"]
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
                                    label: Text('Name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Police Station Division',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline_sharp,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(Adddstaff.routeName);
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
          DataCell(Text('ST${index.toString()}')),
          DataCell(Text(_data[index]['Name'].toString())),
          DataCell(Text(_data[index]['PoliceStationDivision'].toString())),
          DataCell(Text(_data[index]['Role'].toString())),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                                      FirebaseFirestore.instance
                                          .collection('Complaints')
                                          .where("PoliceOfficerid",
                                              isEqualTo: _data[index]
                                                  ["PoliceStaffId"])
                                          .get()
                                          .then((val) async {
                                        if (val.docs.length <= 0) {
                                          var del = await FirebaseFirestore
                                              .instance
                                              .collection('Duties')
                                              .where('PoliceStaffid',
                                                  isEqualTo: _data[index]["id"])
                                              .get()
                                              .then((del) {
                                            if (del.docs.length <= 0) {
                                              PoliceStaffDatabase
                                                  .DeletePoliceStaff(
                                                      mainid: _data[index]
                                                          ["id"]);

                                              Navigator.of(ctx).pop(false);
                                            } else {
                                              return showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        content: Text(
                                                          'This Police Staff have some duties Please Complete it first Make sure they dont have any duties assign',
                                                        ),
                                                        title: Text(
                                                          'Warning',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text('Ok'),
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                            }
                                          });
                                        } else {
                                          return showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                    content: Text(
                                                      'This Police Staff Have Complaint Assign Resolve it First?',
                                                    ),
                                                    title: Text(
                                                      'Warning',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('Ok'),
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        }
                                      });
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
                              arguments: _data[index]["id"])
                        },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    icon: Icon(Icons.edit),
                    label: Text("View")),
                ElevatedButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pushNamed(Adddstaff.routeName,
                              arguments: _data[index]["id"])
                        },
                    icon: Icon(Icons.edit),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    label: Text("Edit")),
              ],
            ),
          ),
        ]);
  }
}
