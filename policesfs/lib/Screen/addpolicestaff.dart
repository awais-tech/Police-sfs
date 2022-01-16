import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/PolicestaffModel.dart';
import 'PoliceStaff_database.dart';
import 'package:policesfs/Screen/client_database.dart';

class Addpolicestaff extends StatefulWidget {
  static const routeName = '/edit-staff';

  @override
  _AddpolicestaffState createState() => _AddpolicestaffState();
}

class _AddpolicestaffState extends State<Addpolicestaff> {
  var select;
  var _stationDivisions;
  bool loading = false;
  bool _isInit = true;
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool isPhone(String em) {
    String p =
        r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool isCnic(String em) {
    String p = r'^[0-9]{5}-[0-9]{7}-[0-9]$';
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        loading = true;
      });
      final id = ModalRoute.of(context)?.settings.arguments;

      if (id != null) {
        var e = await FirebaseFirestore.instance
            .collection('PoliceStaff')
            .doc(id as String)
            .get();

        select = DateTime.parse(
            (e.data()!['dateofJoining'].toDate().toString()).toString());
        setState(() {
          initial = {
            'Address': e.data()!['Address'],
            'Email': e.data()!['Email'],
            'Gender': e.data()!['Gender'],
            'Role': e.data()!['Role'],
            'Name': e.data()!['Name'],
            'Nationality': e.data()!['Nationality'],
            'Phoneno': e.data()!['PhoneNo'],
            'PoliceStationDivision': e.data()!['PoliceStationID'],
            'imageUrl': e.data()!['imageUrl'],
            'CNIC': e.data()!['CNIC'],
            'id': e.id,
          };
        });
        _imageUrlController.text = e.data()!['imageUrl'];
      }

      final result = FirebaseFirestore.instance
          .collection('PoliceStation')
          .get()
          .then((result) {
        _stationDivisions = result.docs
            .map((val) =>
                {'label': val.data()["Division"], "value": val.data()["PSID"]})
            .toList();
        setState(() {
          loading = false;
        });
      });

      _isInit = false;

      super.didChangeDependencies();
    }
  }

  final List<Map<String, dynamic>> _policeRoles = [
    {
      'value': 'Police Inspector',
      'label': 'Police Inspector',
    },
    {
      'value': 'Sub-Inspector',
      'label': 'Sub-Inspector',
    },
    {
      'value': 'Assistant Sub-Inspector',
      'label': 'Assistant Sub-Inspector',
    },
    {
      'value': 'Head Constable',
      'label': 'Head Constable',
    },
    {
      'value': 'Constable',
      'label': 'Constable',
    },
    {
      'value': 'Operator',
      'label': 'Operator',
    },
  ];
  final List<Map<String, dynamic>> _gender = [
    {
      'value': 'Male',
      'label': 'Male',
    },
    {
      'value': 'Female',
      'label': 'Female',
    },
    {
      'value': 'Other',
      'label': 'Other',
    },
  ];

  selectdate() {
    showDatePicker(
            context: context,
            // currentDate: _editedProduct.DateofEstablish,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((picked) => {
              if (picked == null)
                {print(2)}
              else
                setState(() => select = picked)
            });
  }

  final _image = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = PoliceStaffmodel(
      Email: '',
      Gender: '',
      Address: '',
      Name: '',
      Nationality: '',
      Phoneno: '',
      PoliceStationDivision: '',
      Role: '',
      imageUrl: '',
      DateofJoinng: DateTime.now(),
      id: '',
      CNIC: '');
  var initial = {
    'Address': "",
    'Email': "",
    'Gender': "",
    'Role': "",
    'Name': "",
    'Nationality': "",
    'Phoneno': "",
    'PoliceStationDivision': "",
    'imageUrl': "",
    'CNIC': "",
    'id': '',
  };
  @override
  void dispose() {
    _image.removeListener(_updateImageUrl);
    super.dispose();
  }

  @override
  void initState() {
    _image.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    setState(() {});
  }

  void saveform() async {
    print(2);
    var form = _form.currentState!.validate();
    if (!form) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      loading = true;
    });

    try {
      if (initial['id'] != '') {
        await PoliceStaffDatabase.updatePoliceStaff(
            select, _editedProduct, initial['id']);
      } else {
        await PoliceStaffDatabase.addPoliceStaff(select, _editedProduct);
      }
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(
                  'Something Goes wrong ?',
                ),
                title: Text(
                  'Warning',
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green,
              semanticsLabel: 'Please Wait',
            ))
          : Center(
              child: Container(
                color: Colors.white,
                child: Card(
                  elevation: 14,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            initialValue: initial['Name'] as String,
                            decoration: InputDecoration(labelText: 'Name'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a description.';
                              }
                              if (value.length < 3) {
                                return 'Should be at least 3 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Name = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['Address'] as String,
                            decoration: InputDecoration(labelText: 'Address'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Address = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['CNIC'] as String,
                            decoration: InputDecoration(labelText: 'CNIC'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter valid CNIC.';
                              } else if (!isCnic(value)) {
                                return 'Please enter valid Cnic.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.CNIC = value!;
                              ;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['Email'] as String,
                            decoration: InputDecoration(labelText: 'Email'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Email';
                              } else if (!isEmail(value!)) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Email = value!;
                            },
                          ),
                          SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog

                              initialValue: initial["Gender"] == ""
                                  ? "Male"
                                  : initial["Gender"],
                              labelText: 'Gender',
                              items: _gender,
                              enableSearch: true,
                              onChanged: (val) => print(val),
                              onSaved: (value) {
                                _editedProduct.Gender = value!;
                              }),
                          SelectFormField(
                              type: SelectFormFieldType
                                  .dropdown, // or can be dialog
                              initialValue: initial["Role"] == ""
                                  ? "Police Inspector"
                                  : initial["Role"],
                              labelText: 'Role',
                              items: _policeRoles,
                              onChanged: (val) => print(val),
                              onSaved: (value) {
                                _editedProduct.Role = value!;
                              }),
                          TextFormField(
                            initialValue: initial['Phoneno'] as String,
                            decoration:
                                InputDecoration(labelText: 'Phone Number'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Phone number.';
                              }
                              if (!isPhone(value)) {
                                return 'Phone no is invalid.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Phoneno = value!;
                            },
                          ),
                          SelectFormField(
                              type: SelectFormFieldType.dropdown,
                              initialValue: initial["PoliceStationDivision"],
                              labelText: 'Police Station Division',
                              items: _stationDivisions,
                              onChanged: (val) => print(val),
                              onSaved: (value) {
                                _editedProduct.PoliceStationDivision = value!;
                              }),
                          TextFormField(
                            initialValue: initial['Nationality'] as String,
                            decoration:
                                InputDecoration(labelText: 'Nationality'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Nationality.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Nationality = value!;
                            },
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: TextButton(
                              onPressed: selectdate,
                              child: Text('Select Date'),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontWeight: FontWeight.bold))),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(
                                  top: 8,
                                  right: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: _imageUrlController.text.isEmpty
                                    ? Text('Enter a URL')
                                    : FittedBox(
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _image,
                                  onFieldSubmitted: (_) => {saveform},
                                  onSaved: (value) {
                                    _editedProduct.imageUrl = value!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an image URL.';
                                    }
                                    if (!value.startsWith('http') ||
                                        !value.startsWith('https') ||
                                        value.contains('www')) {
                                      return 'Please enter a valid URL.';
                                    }
                                    // if (!value.endsWith('.png') &&
                                    //     !value.endsWith('.jpg') &&
                                    //     !value.endsWith('.jpeg')) {
                                    //   return 'Please enter a valid image URL.';
                                    // }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: saveform, icon: Icon(Icons.save))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
