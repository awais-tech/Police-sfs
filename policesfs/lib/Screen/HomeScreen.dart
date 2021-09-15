import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';

class HomeScreen extends StatelessWidget {
  final List<String> navigators = [
    "Home",
    "Police Stations",
    "Police Staff",
    "Complaints",
    "Feedbacks",
    "Notifications",
    "Reports",
    "Chats"
  ];
  static List<IconData> navigatorsIcon = [
    Icons.home,
    Icons.local_police_outlined,
    Icons.person_outlined,
    Icons.comment_bank,
    Icons.feedback_outlined,
    Icons.notifications_active,
    Icons.report_outlined,
    Icons.chat_outlined
  ];

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Drawer(
        elevation: 5,
        child: ListView.builder(
            itemCount: navigators.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {},
                tileColor: Colors.pink[900],
                leading: Icon(
                  navigatorsIcon[index],
                  color: Colors.white,
                ),
                title: Text(
                  "${navigators[index]}",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              );
            }),
      ),
      Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 25, right: 25, bottom: 25),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        )),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.pink[900]), // <-- Button color
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.red; // <-- Splash color
                        }),
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                "Logout",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 16,
                                )),
                          ],
                        ),
                      ),
                      onPressed: () => {}),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  child: Text("Overview",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[900])),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView(
                  children: <Widget>[
                    SlimyCard(
                      color: Colors.red,
                      width: 200,
                      topCardHeight: 400,
                      bottomCardHeight: 200,
                      borderRadius: 15,
                      topCardWidget: Text("Total Users Registered"),
                      bottomCardWidget: Text("1000"),
                      slimeEnabled: true,
                    ),
                  ],
                ),
                ListView(
                  children: <Widget>[
                    SlimyCard(
                      color: Colors.red,
                      width: 200,
                      topCardHeight: 400,
                      bottomCardHeight: 200,
                      borderRadius: 15,
                      topCardWidget: Text("Total Police Staff Registered"),
                      bottomCardWidget: Text("2000"),
                      slimeEnabled: true,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView(
                  children: <Widget>[
                    SlimyCard(
                      color: Colors.red,
                      width: 200,
                      topCardHeight: 400,
                      bottomCardHeight: 200,
                      borderRadius: 15,
                      topCardWidget: Text("Total Reports Registered"),
                      bottomCardWidget: Text("1000"),
                      slimeEnabled: true,
                    ),
                  ],
                ),
                ListView(
                  children: <Widget>[
                    SlimyCard(
                      color: Colors.red,
                      width: 200,
                      topCardHeight: 400,
                      bottomCardHeight: 200,
                      borderRadius: 15,
                      topCardWidget: Text("Total Complaints Registered"),
                      bottomCardWidget: Text("1000"),
                      slimeEnabled: true,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

Widget createDrawerHeader() {
  return DrawerHeader(
      child: Stack(children: <Widget>[
    Positioned(
        bottom: 12.0,
        left: 16.0,
        child: Text("Welcome to Police SFS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500))),
  ]));
}
