import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/PoliceModel.dart';
import 'package:policesfs/Screen/PolicestaffModel.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection =
    _firestore.collection("PoliceStaff");

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
      await _mainCollection.add({
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
