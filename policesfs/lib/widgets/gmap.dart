import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:policesfs/Utlits/helpers.dart';
import 'package:policesfs/provider/gmapprovider.dart';
import 'package:provider/provider.dart';

class Maps extends StatefulWidget {
  late int id;
  late String name;
  Maps(name, id) {
    this.id = id;
    this.name = name;
  }
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Provider.of<GernateMap>(context, listen: false).fetchmap(context),
          Center(
              child: Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset("assets/images/markerselect.png",
                      color: Colors.black))),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Provider.of<GernateMap>(context, listen: true).getmovemarker
                      ? LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.orange),
                        )
                      : TextButton.icon(
                          icon: Icon(Icons.location_searching),
                          label: Provider.of<GernateMap>(context, listen: true)
                                  .getmovemarker
                              ? Text("Locating........")
                              : Flexible(
                                  child: Text(
                                    Provider.of<GernateMap>(context,
                                            listen: true)
                                        .getfinaladdess
                                        .toString(),
                                  ),
                                ),
                          onPressed: () {},
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: AbsorbPointer(
                        absorbing:
                            Provider.of<GernateMap>(context, listen: true)
                                    .getmovemarker
                                ? true
                                : false,
                        child: FlatButton(
                            onPressed: () {
                              FormHelper.showMessage(
                                context,
                                "Are you want Save this Location",
                                "Cancel",
                                "",
                                "done",
                                () {
                                  final mapprovider = Provider.of<GernateMap>(
                                      context,
                                      listen: false);
                                  Provider.of<GernateMap>(context,
                                          listen: false)
                                      .updatelocation(
                                          mapprovider.selectgarage.id,
                                          mapprovider.selectgarage.name,
                                          context);
                                  Fluttertoast.showToast(
                                      msg: "Saving Location Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  //back after save data
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => GarageAdmin()));
                                },
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            color:
                                Provider.of<GernateMap>(context, listen: true)
                                        .getmovemarker
                                    ? Colors.grey
                                    : Colors.orange,
                            child: Text("Confrim Button")),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: 50,
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => UpdateLocation("name", 92)));
                  }))
        ],
      ),
    );
  }
}
