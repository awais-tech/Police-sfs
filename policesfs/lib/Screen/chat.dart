import 'package:flutter/material.dart';
import 'package:policesfs/Screen/chat/messages.dart';
import 'package:policesfs/Screen/chat/new_message.dart';
import 'package:policesfs/Screen/drawner.dart';

class Chat extends StatelessWidget {
  static final routeName = 'Chat';
  @override
  Widget build(BuildContext context) {
    var id = ModalRoute.of(context)?.settings.arguments as Map;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width < 700
          ? AppBar(
              backgroundColor: Colors.pink[900],
              title: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: TextButton(onPressed: () {}, child: Text('Logout'))))
          : null,
      drawer: width < 700 ? drawerwidget() : null,
      body: Row(
        children: [
          if (width > 700)
            Flexible(
              flex: 2,
              child: Container(
                child: drawerwidget(),
              ),
            ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Messages(id),
                ),
                NewMessage(id),
              ],
            ),

            // child: SingleChildScrollView(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         flex: 2,
            //         child: Container(
            //           alignment: Alignment.center,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Container(
            //                 width: 300,
            //                 height: 200,
            //                 child: Card(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   color: Colors.blue[700],
            //                   elevation: 10,
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Icon(
            //                         Icons.people,
            //                         size: 70,
            //                       ),
            //                       FittedBox(
            //                         child: Text(
            //                           "Total Registered Staff",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                       ),
            //                       Text(
            //                         "1300",
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(
            //                             fontSize: 34,
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 width: 300,
            //                 height: 200,
            //                 child: Card(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   color: Colors.blue[700],
            //                   elevation: 10,
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Icon(
            //                         Icons.wifi_protected_setup_sharp,
            //                         size: 70,
            //                       ),
            //                       FittedBox(
            //                         child: Text(
            //                           "Active Complaints",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                       ),
            //                       Text(
            //                         "2700",
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(
            //                             fontSize: 34,
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Flexible(
            //         flex: 2,
            //         child: Container(
            //           margin: width < 700
            //               ? EdgeInsets.symmetric(horizontal: 10, vertical: 20)
            //               : null,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Container(
            //                 width: 300,
            //                 height: 200,
            //                 child: Card(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   color: Colors.blue[700],
            //                   elevation: 10,
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Icon(
            //                         Icons.verified_user_sharp,
            //                         size: 70,
            //                       ),
            //                       FittedBox(
            //                         child: Text(
            //                           "Total Registered Users",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                       ),
            //                       Text(
            //                         "4300",
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(
            //                             fontSize: 34,
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 width: 300,
            //                 height: 200,
            //                 child: Card(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   color: Colors.blue[700],
            //                   elevation: 10,
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceAround,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       Icon(
            //                         Icons.check_circle_outlined,
            //                         size: 70,
            //                       ),
            //                       FittedBox(
            //                         child: Text(
            //                           "Completed Complaints",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                       ),
            //                       Text(
            //                         "1100",
            //                         textAlign: TextAlign.center,
            //                         style: TextStyle(
            //                             fontSize: 34,
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
