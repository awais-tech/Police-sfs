import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:policesfs/Screen/PoliceModel.dart';
import 'package:policesfs/Screen/PoliceStaff_database.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection =
    _firestore.collection("CriminalRecord");

class CriminalRecords {
  static String? userID;

  static Future<void> DelCriminalRecord({
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
}
