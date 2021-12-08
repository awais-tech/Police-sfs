import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:policesfs/Screen/PoliceModel.dart';
import 'package:policesfs/Screen/PoliceStation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/client_database.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
  var _editedProduct = PoliceStation(
    Address: '',
    Name: '',
    Division: '',
    NearstLocation: '',
    NoofCells: '',
    DateofEstablish: DateTime.now(),
    PostelCode: '',
    imageUrl: '',
    StationPhoneno: '',
    id: '',
  );
  var initial = {
    "Address": "",
    "Division": "",
    "Name": "",
    "NearstLocation": "",
    "Noofcells": "",
    "PostelCode": "",
    "StationPhoneno": "",
    "imageUrl": "",
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
                  _editedProduct.DateofEstablish = DateTime.parse(
                      (e.data()!['dateofEstablish'].toDate().toString())
                          .toString()),
                  _editedProduct.Division = e.data()!['Division'],
                  _editedProduct.Name = e.data()!['Name'],
                  _editedProduct.NearstLocation = e.data()!['Nearst Location'],
                  _editedProduct.NoofCells = e.data()!['No of cells'],
                  _editedProduct.imageUrl = e.data()!['imageUrl'],
                  _editedProduct.PostelCode = e.data()!['Postel Code'],
                  _editedProduct.StationPhoneno = e.data()!['Station Phone No'],
                  _editedProduct.id = e.id,
                  print(_editedProduct.StationPhoneno),
                  initial = {
                    "Address": _editedProduct.Address,
                    "Division": _editedProduct.Division,
                    "Name": _editedProduct.Name,
                    "NearstLocation": _editedProduct.NearstLocation,
                    "Noofcells": _editedProduct.NoofCells,
                    "PostelCode": _editedProduct.PostelCode,
                    "StationPhoneno": _editedProduct.StationPhoneno,
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
                              _editedProduct = PoliceStation(
                                  id: _editedProduct.id,
                                  Address: _editedProduct.Address,
                                  Name: value!,
                                  Division: _editedProduct.Division,
                                  NearstLocation: _editedProduct.NearstLocation,
                                  NoofCells: _editedProduct.NoofCells,
                                  DateofEstablish:
                                      _editedProduct.DateofEstablish,
                                  PostelCode: _editedProduct.PostelCode,
                                  imageUrl: _editedProduct.imageUrl,
                                  StationPhoneno:
                                      _editedProduct.StationPhoneno);
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
                              _editedProduct = PoliceStation(
                                  id: _editedProduct.id,
                                  Address: value!,
                                  Name: _editedProduct.Name,
                                  Division: _editedProduct.Division,
                                  NearstLocation: _editedProduct.NearstLocation,
                                  NoofCells: _editedProduct.NoofCells,
                                  DateofEstablish:
                                      _editedProduct.DateofEstablish,
                                  PostelCode: _editedProduct.PostelCode,
                                  imageUrl: _editedProduct.imageUrl,
                                  StationPhoneno:
                                      _editedProduct.StationPhoneno);
                            },
                          ),
                          _editedProduct.Division == ""
                              ? TextFormField(
                                  initialValue: initial['Division'] as String,
                                  decoration:
                                      InputDecoration(labelText: 'Division'),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a Division.';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedProduct = PoliceStation(
                                        id: _editedProduct.id,
                                        Address: _editedProduct.Address,
                                        Name: _editedProduct.Name,
                                        Division: value!,
                                        NearstLocation:
                                            _editedProduct.NearstLocation,
                                        NoofCells: _editedProduct.NoofCells,
                                        DateofEstablish:
                                            _editedProduct.DateofEstablish,
                                        PostelCode: _editedProduct.PostelCode,
                                        imageUrl: _editedProduct.imageUrl,
                                        StationPhoneno:
                                            _editedProduct.StationPhoneno);
                                    ;
                                  },
                                )
                              : Container(),
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
                              _editedProduct = PoliceStation(
                                  id: _editedProduct.id,
                                  Address: _editedProduct.Address,
                                  Name: _editedProduct.Name,
                                  Division: _editedProduct.Division,
                                  NearstLocation: value!,
                                  NoofCells: _editedProduct.NoofCells,
                                  DateofEstablish:
                                      _editedProduct.DateofEstablish,
                                  PostelCode: _editedProduct.PostelCode,
                                  imageUrl: _editedProduct.imageUrl,
                                  StationPhoneno:
                                      _editedProduct.StationPhoneno);
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
                              _editedProduct = PoliceStation(
                                  id: _editedProduct.id,
                                  Address: _editedProduct.Address,
                                  Name: _editedProduct.Name,
                                  Division: _editedProduct.Division,
                                  NearstLocation: _editedProduct.NearstLocation,
                                  NoofCells: value!,
                                  DateofEstablish:
                                      _editedProduct.DateofEstablish,
                                  PostelCode: _editedProduct.PostelCode,
                                  imageUrl: _editedProduct.imageUrl,
                                  StationPhoneno:
                                      _editedProduct.StationPhoneno);
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
                              _editedProduct = PoliceStation(
                                  id: _editedProduct.id,
                                  Address: _editedProduct.Address,
                                  Name: _editedProduct.Name,
                                  Division: _editedProduct.Division,
                                  NearstLocation: _editedProduct.NearstLocation,
                                  NoofCells: _editedProduct.NoofCells,
                                  DateofEstablish:
                                      _editedProduct.DateofEstablish,
                                  PostelCode: value!,
                                  imageUrl: _editedProduct.imageUrl,
                                  StationPhoneno:
                                      _editedProduct.StationPhoneno);
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
                                    _editedProduct = PoliceStation(
                                        id: _editedProduct.id,
                                        Address: _editedProduct.Address,
                                        Name: _editedProduct.Name,
                                        Division: _editedProduct.Division,
                                        NearstLocation:
                                            _editedProduct.NearstLocation,
                                        NoofCells: _editedProduct.NoofCells,
                                        DateofEstablish:
                                            _editedProduct.DateofEstablish,
                                        PostelCode: _editedProduct.PostelCode,
                                        imageUrl: value!,
                                        StationPhoneno:
                                            _editedProduct.StationPhoneno);
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
