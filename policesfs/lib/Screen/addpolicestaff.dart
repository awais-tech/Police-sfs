import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/PolicestaffModel.dart';
import 'package:policesfs/Screen/client_database.dart';

class Addpolicestaff extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _AddpolicestaffState createState() => _AddpolicestaffState();
}

class _AddpolicestaffState extends State<Addpolicestaff> {
  var select;

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
  bool loading = false;
  bool init = true;
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
    "Address": "",
    "Email": "",
    "Gender": "",
    "Role": "",
    "Name": "",
    "Nationality": "",
    "Phoneno": "",
    "PoliceStationDivision": "",
    "StationPhoneno": "",
    "imageUrl": "",
    "CNIC": "",
    "id": '',
    "dateofEstablish": "",
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

  @override
  void didChangeDependencies() {
    if (init) {
      final id = ModalRoute.of(context)?.settings.arguments;

      if (id != null) {
        setState(() {
          loading = true;
        });
        FirebaseFirestore.instance
            .collection('PoliceStation')
            .doc(id as String)
            .get()
            .then((e) => {
                  _editedProduct.Address = e.data()!['Address'],
                  _editedProduct.DateofJoinng = DateTime.parse(
                      (e.data()!['dateofEstablish'].toDate().toString())
                          .toString()),
                  _editedProduct.PoliceStationDivision = e.data()!['Division'],
                  _editedProduct.Name = e.data()!['Name'],
                  _editedProduct.imageUrl = e.data()!['imageUrl'],
                  _editedProduct.Phoneno = e.data()!['PhoneNo'],
                  _editedProduct.id = e.id,
                  initial = {
                    "Address": _editedProduct.Address,
                    "Name": _editedProduct.Name,
                    "imageUrl": _editedProduct.imageUrl,
                  },
                  _imageUrlController.text = _editedProduct.imageUrl,
                  print(initial),
                  setState(() {
                    loading = false;
                  }),
                });
      }
    }
    init = false;
    super.didChangeDependencies();
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

    if (_editedProduct.id != '') {
      try {
        print(3);
        await PoliceStationDatabase.UpdatePoliceStation(
            select, _editedProduct, _editedProduct.id);
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
    } else {
      try {
        await PoliceStationDatabase.addPoliceStation(select, _editedProduct);
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
    }
    setState(() {
      loading = false;
    });
    Navigator.of(context).pop();
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              _editedProduct.PoliceStationDivision = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['Division'] as String,
                            decoration: InputDecoration(labelText: 'Division'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Division.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.CNIC = value!;
                              ;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['NearstLocation'] as String,
                            decoration:
                                InputDecoration(labelText: 'Nearst Location'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Nearst Location';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Email = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['Noofcells'] as String,
                            decoration:
                                InputDecoration(labelText: 'No of Cells'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Noofcells.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct.Gender = value!;
                            },
                          ),
                          TextFormField(
                            initialValue: initial['Noofcells'] as String,
                            decoration:
                                InputDecoration(labelText: 'No of Cells'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Noofcells.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
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
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Postel Code'),
                            initialValue: initial['PostelCode'] as String,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            onSaved: (value) {
                              _editedProduct.imageUrl = value!;
                            },
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
                                    _editedProduct.Role = value!;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an image URL.';
                                    }
                                    if (!value.startsWith('http') &&
                                            !value.startsWith('https') ||
                                        value.contains('www')) {
                                      return 'Please enter a valid URL.';
                                    }
                                    if (!value.endsWith('.png') &&
                                        !value.endsWith('.jpg') &&
                                        !value.endsWith('.jpeg')) {
                                      return 'Please enter a valid image URL.';
                                    }
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
