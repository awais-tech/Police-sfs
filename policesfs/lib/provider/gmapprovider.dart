import 'dart:convert';

import 'package:CreativeParkingSolution/GaragePanel/UpdateLocation.dart';
import 'package:CreativeParkingSolution/Model/Garages.dart';
import 'package:CreativeParkingSolution/Model/Locationupdate.dart';
import 'package:CreativeParkingSolution/Service/LocationService.dart';
import 'package:CreativeParkingSolution/google_map/Currentlocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart' as geoc;
import 'package:provider/provider.dart';

class GernateMap extends ChangeNotifier {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool issave = false;
  bool issaveselectmap = false;
  bool movemarker = false;
  bool get getmovemarker => movemarker;

  bool get getissaveselectmap => issaveselectmap;
  var reponse;
  String msg;
  Garages selectgarage;
  Position position;
  double lat = 0.00;
  double lng = 0.00;
  double get latitude => lat;
  double get longitude => lng;
  String finaladdeess, countryname = "Searching......";
  String get getcountryname => countryname;
  String get getfinaladdess => finalAddress;
  Garages get selectgarages => selectgarage;
  Position get getpostion => position;
  String finalAddress;
  GoogleMapController mapController;
  Future currentlocation() async {
    var postiondate = await GeolocatorPlatform.instance.getCurrentPosition();
    final cord = geoc.Coordinates(postiondate.latitude, postiondate.longitude);
    var address = await geoc.Geocoder.local.findAddressesFromCoordinates(cord);
    String mianaddrerss = address.first.addressLine;
    lat = postiondate.latitude;
    lng = postiondate.longitude;
    finalAddress = mianaddrerss;
    position = postiondate;
    notifyListeners();
  }

  selectdata(Garages garage) {
    selectgarage = garage;
    notifyListeners();
  }

  getmarker(double lat, double lng) {
    MarkerId markerId = MarkerId(lat.toString() + lng.toString());
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "My Title", snippet: "Country Name"));
    markers[markerId] = marker;
  }

  Widget fetchmap(context) {
    return GoogleMap(
      mapType: MapType.normal,
      minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.0),
      onTap: (tap) async {
        // final cord = geoc.Coordinates(tap.latitude, tap.longitude);

        // var address =
        //     await geoc.Geocoder.local.findAddressesFromCoordinates(cord);
        // finalAddress = address.first.addressLine;
        // countryname = address.first.countryName;
        // lat = tap.latitude;
        // lng = tap.longitude;

        // notifyListeners();

        // markers.isEmpty
        //     ? getmarker(tap.latitude, tap.longitude)
        //     : markers.clear();
        // updatelocation(selectgarages.id, selectgarages.name, context);
      },
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController googleMapController) {
        mapController = googleMapController;
        notifyListeners();
      },
      onCameraIdle: () {
        movemarker = false;
        notifyListeners();
        getmovecamera();
      },
      onCameraMove: (CameraPosition position) {
        movemarker = true;

        onCameraMove(position);
      },
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
          target: LatLng(
              Provider.of<Currentlocation>(context, listen: false).latitude,
              Provider.of<Currentlocation>(context, listen: false).longitude),
          zoom: 10.0),
    );
  }

  void onCameraMove(CameraPosition position) async {
    this.lat = position.target.latitude;
    this.lng = position.target.longitude;
    notifyListeners();
  }

  Future<void> getmovecamera() async {
    final cord = geoc.Coordinates(this.latitude, this.longitude);

    var address = await geoc.Geocoder.local.findAddressesFromCoordinates(cord);
    finalAddress = address.first.addressLine;
    notifyListeners();
    countryname = address.first.countryName;
    notifyListeners();
    print(finalAddress);
  }

  void updatelocation(id, name, context) {
    issaveselectmap = true;
    notifyListeners();
    var locationservice = new LocationUpdateService();
    LocationUpdate locationupdate = new LocationUpdate(
        id: id,
        lat: Provider.of<GernateMap>(context, listen: false).latitude,
        lng: Provider.of<GernateMap>(context, listen: false).longitude);
    locationservice
        .currentlocationUpdate(locationupdate, context)
        .then(((value) {
      issaveselectmap = false;
      notifyListeners();
      reponse = jsonDecode(value.body);
      issave = reponse["status"];
      msg = reponse["msg"];
      // setState(() {
      //   issave = false;
      // });
      final snackBar = SnackBar(
        content: Text(msg),
        backgroundColor: Colors.blue[50],
        duration: Duration(seconds: 5),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }));
    issave = reponse["status"];
    msg = reponse["msg"];

    // msg = response["msg"];
  }
}
