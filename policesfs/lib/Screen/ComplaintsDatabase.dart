import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/PoliceModel.dart';
import 'package:policesfs/Screen/PoliceStaff_database.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("Complaints");
final CollectionReference _mainCollections = _firestore.collection("Emergency");

class ComplaintsDatabase {
  static String? userID;

  static Future<void> UpdatePoliceStation(select, policeStation, id) async {
    DocumentReference collectionRef = _mainCollection.doc(id);
    print(select);
    if (select == null) {
      await collectionRef.update({
        "Address": policeStation.Address,
        "Name": policeStation.Name,
        "Nearst Location": policeStation.NearstLocation,
        "No of cells": policeStation.NoofCells,
        "Postel Code": policeStation.PostelCode,
        "Station Phone No": policeStation.StationPhoneno,
        "imageUrl": policeStation.imageUrl
      });
    } else {
      await collectionRef
          .update({
            "Address": policeStation.Address,
            "Name": policeStation.Name,
            "Nearst Location": policeStation.NearstLocation,
            "No of cells": policeStation.NoofCells,
            "Postel Code": policeStation.PostelCode,
            "Station Phone No": policeStation.StationPhoneno,
            "dateofEstablish": select,
            "imageUrl": policeStation.imageUrl
          })
          .then((value) => print("User Account Status Updated"))
          .catchError((error) => print("Failed to update transaction: $error"));
    }
  }

  static Future<void> ComplaintsDelete({
    required String mainid,
  }) async {
    DocumentReference collectionRef = _mainCollection.doc(mainid);

    await collectionRef.delete();
    // var del = await FirebaseFirestore.instance
    //     .collection('PoliceStaff')
    //     .where('PoliceStationID', isEqualTo: mainid)
    //     .get();

    print("User Account Deleted");
  }

  static Future<void> EmergencyDelete({
    required String mainid,
  }) async {
    DocumentReference collectionRef = _mainCollections.doc(mainid);

    await collectionRef.delete();
    // var del = await FirebaseFirestore.instance
    //     .collection('PoliceStaff')
    //     .where('PoliceStationID', isEqualTo: mainid)
    //     .get();

    print("User Account Deleted");
  }

  static Future<void> addPoliceStation(select, policeStation) async {
    try {
      select == null ? DateTime.now() : select;
      await _mainCollection.add({
        "Address": policeStation.Address,
        "Division": policeStation.Division,
        "Name": policeStation.Name,
        "Nearst Location": policeStation.NearstLocation,
        "No of cells": policeStation.NoofCells,
        "Postel Code": policeStation.PostelCode,
        "Station Phone No": policeStation.StationPhoneno,
        "dateofEstablish": select,
        "imageUrl": policeStation.imageUrl
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  static Stream<QuerySnapshot> PoliceStation() {
    return _mainCollection.snapshots();
  }

  static getComplaintsOfClients(String id) {
    return _mainCollection.doc(id).snapshots();
  }
}
