import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection =
    _firestore.collection("PoliceStaff");
final CollectionReference _main = _firestore.collection("PoliceStation");

class PoliceStaffDatabase {
  static String? userID;

  static Future<void> UpdatePoliceStaff(select, policeStaff, id) async {
    DocumentReference collectionRef = _mainCollection.doc(id);
    await collectionRef
        .update({
          "Address": policeStaff.Address,
          "PoliceStationDivision": policeStaff.PoliceStationDivision,
          "Name": policeStaff.Name,
          "Gender": policeStaff.Gender,
          "Nationality": policeStaff.Nationality,
          "CNIC": policeStaff.CNIC,
          "Email": policeStaff.Email,
          "Role": policeStaff.Role,
          "Phoneno": policeStaff.Phoneno,
          "dateofJoining": select,
          "imageUrl": policeStaff.imageUrl
        })
        .then((value) => print("User Account Status Updated"))
        .catchError((error) => print("Failed to update transaction: $error"));
  }

  static Future<void> DeletePoliceStaff({
    required String mainid,
  }) async {
    DocumentReference collectionRef = _mainCollection.doc(mainid);
    await collectionRef
        .delete()
        .then((value) => print("User Account Deleted"))
        .catchError((error) => print("Failed to Delete User Account: $error"));
  }

  static Future<void> addPoliceStaff(select, policeStaff) async {
    try {
      print(policeStaff);
      Random random = new Random();
      int randomNumber = random.nextInt(10000) + 100;
      int randoms = random.nextInt(1000) + 10;
      FirebaseAuth auth = FirebaseAuth.instance;

      _main.doc(policeStaff.PoliceStationDivision).get().then((val) async {
        var password =
            policeStaff.Name + randomNumber.toString() + randoms.toString();
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: policeStaff.Email,
          password: password,
        );
        await _mainCollection.doc(userCredential.user!.uid).set({
          "Address": policeStaff.Address,
          "PoliceStationID": policeStaff.PoliceStationDivision,
          "Name": policeStaff.Name,
          "Gender": policeStaff.Gender,
          "Nationality": policeStaff.Nationality,
          "CNIC": policeStaff.CNIC,
          "Email": policeStaff.Email,
          "Role": policeStaff.Role,
          "PhoneNo": policeStaff.Phoneno,
          "dateofJoining": select,
          "imageUrl": policeStaff.imageUrl,
          "PoliceStationDivision": (val.data() as Map)["Division"],
          "PoliceStaffId": userCredential.user!.uid,
        });

        final url = Uri.parse(
            'https://fitnessappauth.herokuapp.com/api/users/TokenRefreshs');
        Map<String, String> headers = {"Content-type": "application/json"};

        var doc = await http.post(
          url,
          headers: headers,
          body: json.encode({
            'email': policeStaff.Email,
            'message':
                "Hi ${policeStaff.Name}!<br> You selected as a ${policeStaff.Role} at ${(val.data() as Map)['Division']}<br> Please use this Email:${policeStaff.Email} and Password:$password for sign up your account <br> Police station Address:${(val.data() as Map)["Address"]}",
          }),
        );
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  static Future<void> updatePoliceStaff(select, policeStaff,id) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      _main.doc(policeStaff.PoliceStationDivision).get().then((val) async {
        await _mainCollection.doc(id).update({
          "Address": policeStaff.Address,
          "PoliceStationID": policeStaff.PoliceStationDivision,
          "Name": policeStaff.Name,
          "Gender": policeStaff.Gender,
          "Nationality": policeStaff.Nationality,
          "CNIC": policeStaff.CNIC,
          "Email": policeStaff.Email,
          "Role": policeStaff.Role,
          "PhoneNo": policeStaff.Phoneno,
          "dateofJoining": select,
          "imageUrl": policeStaff.imageUrl,
          "PoliceStationDivision": (val.data() as Map)["Division"],
        });
      });
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  static Stream<QuerySnapshot> PoliceStaffmodel() {
    return _mainCollection.snapshots();
  }

  static getComplaintsOfClients(String id) {
    return _mainCollection.doc(id).snapshots();
  }
}
