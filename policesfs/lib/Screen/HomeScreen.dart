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
                      height: constraints.maxHeight * 0.2,
                      child: DrawerHeader(child: createDrawerHeader())),
                  Container(
                    height: constraints.maxHeight * 0.8,
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: navigators.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: ListTile(
                              onTap: () {},
                              leading: Icon(navigatorsIcon[index]),
                              title: Text(
                                "${navigators[index]}",
                                style: TextStyle(fontSize: 15),
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
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxHeight * 0.3,
                        child: Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Daniyal",
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Daniyal",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxHeight * 0.3,
                        child: Card(
                          elevation: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Daniyal",
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Daniyal",
                                textAlign: TextAlign.center,
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
                        elevation: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daniyal",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Daniyal",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxHeight * 0.3,
                      child: Card(
                        elevation: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daniyal",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Daniyal",
                              textAlign: TextAlign.center,
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
    Positioned(
        bottom: 12.0,
        left: 16.0,
        child: Text("Welcome to Police SFS",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold))),
  ]));
}
