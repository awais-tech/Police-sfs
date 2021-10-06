import 'package:flutter/material.dart';

import 'package:policesfs/Screen/Addedit.dart';
import 'package:policesfs/Screen/Complaints.dart';
import 'package:policesfs/Screen/ComplaintsView.dart';
import 'package:policesfs/Screen/Login.dart';
import 'package:policesfs/Screen/PoliceStaff.dart';
import 'package:policesfs/Screen/PoliceStation.dart';
import 'package:policesfs/Screen/Policestaffview.dart';
import 'package:policesfs/Screen/View.dart';
import 'package:policesfs/Screen/chat.dart';
import 'package:policesfs/Screen/edit.dart';
import 'package:policesfs/widgets/Constants.dart';
import './Screen/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Container();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return CircularProgressIndicator();
    }

    // return MultiProvider(
    //     providers: [
    //       // ChangeNotifierProvider(
    //       //   create: (ctx) => Auth(),
    //       // ),
    //     ],
    return MaterialApp(
        title: 'Police Sfs',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        // home: Constants.prefs.getBool('login') == true
        //     ? ProductsOverviewScreen()
        //     : AuthScreen(),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.data != null) {
                return HomeScreen();
              }

              return Constants.prefs.getBool('login') == true
                  ? HomeScreen()
                  : AuthScreen();
            }),
        routes: {
          PoliceStations.routeName: (ctx) => PoliceStations(),
          Edit.routeName: (ctx) => Edit(),
          View.routeName: (ctx) => View(),
          Addedit.routeName: (ctx) => Addedit(),
          PoliceSaff.routeName: (ctx) => PoliceSaff(),
          PoliceStaffView.routeName: (ctx) => PoliceStaffView(),
          Complaints.routeName: (ctx) => Complaints(),
          ComplaintsView.routeName: (ctx) => ComplaintsView(),
          Chat.routeName: (ctx) => Chat(),
        });
  }
}
