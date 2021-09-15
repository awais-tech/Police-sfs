import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> navigators = [
    "Home",
    "Police Stations",
    "Police Staff",
    "Complaints",
    "Feedbacks",
    "Notifications",
    "Reports",
    "Chats",
    "Logout"
  ];
  static List<IconData> navigatorsIcon = [
    Icons.home,
    Icons.local_police_outlined,
    Icons.person_outlined,
    Icons.comment_bank,
    Icons.feedback_outlined,
    Icons.notifications_active,
    Icons.report_outlined,
    Icons.chat_outlined,
    Icons.logout_outlined
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(children: [
        Container(
          child: Drawer(
            elevation: 24,
            child: LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Container(
                      color: Colors.red[900],
                      height: constraints.maxHeight * 0.2,
                      child: DrawerHeader(child: createDrawerHeader())),
                  Container(
                    color: Colors.blue[900],
                    height: constraints.maxHeight * 0.8,
                    child: ListView.builder(
                        itemCount: navigators.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: ListTile(
                              onTap: () {},
                              leading: Icon(
                                navigatorsIcon[index],
                                color: Colors.white,
                              ),
                              title: Text(
                                "${navigators[index]}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (ctx, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text("Overview"),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxHeight * 0.3,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.blue[700],
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people,
                                size: 70,
                              ),
                              Text(
                                "Total Registered Staff",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                "1300",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxHeight * 0.3,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.blue[700],
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_protected_setup_sharp,
                                size: 70,
                              ),
                              Text(
                                "Active Complaints",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                "2700",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight * 0.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.blue[700],
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_sharp,
                              size: 70,
                            ),
                            Text(
                              "Total Registered Users",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "4300",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight * 0.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.blue[700],
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outlined,
                              size: 70,
                            ),
                            Text(
                              "Completed Complaints",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "1100",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ]),
    );
  }
}

Widget createDrawerHeader() {
  return DrawerHeader(
      child: Stack(children: <Widget>[
    Image.asset(
      'assets/images/police.png',
      height: 10,
      width: 10,
    ),
    Positioned(
        bottom: 12.0,
        left: 16.0,
        child: Text("Welcome to Police SFS",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold))),
  ]));
}
