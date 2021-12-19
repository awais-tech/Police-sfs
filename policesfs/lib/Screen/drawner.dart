import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:policesfs/Screen/Complaints.dart';
import 'package:policesfs/Screen/CriminalRecord.dart';
import 'package:policesfs/Screen/EmergencyComplaint.dart';
import 'package:policesfs/Screen/GenerateReportComplaints.dart';

import 'package:policesfs/Screen/GenerateReportStaff.dart';
import 'package:policesfs/Screen/GenerateReportStations.dart';
import 'package:policesfs/Screen/PoliceStaff.dart';
import 'package:policesfs/Screen/RegisteredUsersDetails.dart';
import 'package:policesfs/Screen/UserRegistered.dart';
import 'package:policesfs/Screen/chat.dart';
import 'package:policesfs/widgets/Constants.dart';

class drawerwidget extends StatelessWidget {
  final List<String> navigators = [
    "Home",
    "Police Stations",
    "Police Staff",
    "Complaints",
    "Crime Record",
    "Registered Users",
    "Reports",
    "BarGraph",
    "Emergency Complaint",
    "Chats",
    "Logout"
  ];
  static List<IconData> navigatorsIcon = [
    Icons.home,
    Icons.local_police_outlined,
    Icons.person_outlined,
    Icons.comment_bank,
    Icons.fingerprint,
    Icons.verified_user,
    Icons.report,
    Icons.graphic_eq_outlined,
    Icons.warning_amber_outlined,
    Icons.chat_outlined,
    Icons.logout_outlined
  ];
  static List click = [
    '/',
    'PoliceStations',
    PoliceSaff.routeName,
    Complaints.routeName,
    CriminalRecord.routeName,
    UserRegistered.routeName,
    CreatePdfComplaintsStatefulWidget.routename,
    BarGraph.routeName,
    Emergency.routeName,
    Chat.routeName,
    'Signout',
  ];

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Drawer(
      elevation: 30,
      child: LayoutBuilder(builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                color: Colors.red[900],
                child: Image.asset(
                  'assets/images/police.png',
                  fit: BoxFit.contain,
                  height: 90.0,
                  width: 310.0,
                ),
              ),
              Container(
                  height: 90,
                  color: Colors.red[900],
                  child: DrawerHeader(child: createDrawerHeader())),
              Container(
                color: Colors.blue[900],
                height: constraints.minHeight,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: navigators.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 3),
                        child: ListTile(
                          onTap: () async {
                            if (click[index] == 'Signout') {
                              await _auth.signOut();
                              await Constants.prefs.remove('userData');
                              await Constants.prefs.setBool('login', false);
                              await _auth.signOut();
                              Navigator.of(context).pushNamed('/');
                              // Constants.prefs.setString('userData', '');
                            } else if (click[index] == Complaints.routeName) {
                              Navigator.of(context).pushNamed(click[index],
                                  arguments: {"em": 2});
                            } else {
                              Navigator.of(context).pushNamed(
                                click[index],
                              );
                            }
                          },
                          leading: Icon(
                            navigatorsIcon[index],
                            color: Colors.white,
                          ),
                          title: Text(
                            "${navigators[index]}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget createDrawerHeader() {
  return DrawerHeader(
      child: Stack(children: <Widget>[
    Positioned(
        //bottom: 5.0,
        left: 16.0,
        child: Text("Welcome to Police SFS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold))),
  ]));
}
