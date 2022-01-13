import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geoc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Currentlocation extends ChangeNotifier {
  late double lat;
  late double lng;
  double get latitude => lat;
  double get longitude => lng;
  String finalAddress = "Searching Address";
  Future currentlocation() async {
    var postiondate = await GeolocatorPlatform.instance.getCurrentPosition();
    final cord = geoc.placemarkFromCoordinates(
        postiondate.latitude, postiondate.longitude);
    // var address = await geoc.Geocoder.local.findAddressesFromCoordinates(cord);
    String mianaddrerss = cord.asStream().first.toString();
    lat = postiondate.latitude;
    lng = postiondate.longitude;
    finalAddress = mianaddrerss;

    notifyListeners();
  }
}
