class Policestation {
  String name = '';
  double lat = 0;
  double lng = 0;
  int id = 0;
  Policestation(
      {required this.id,
      required this.lat,
      required this.lng,
      required this.name});
  Policestation.fromjson(Map<String, dynamic> fromjson) {
    id = fromjson["id"];
    name = fromjson["name"];
    lat = fromjson["latitude"];
    lng = fromjson["longitude"];
  }
  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    data["latitude"] = this.lat;
    data["longitude"] = this.lng;
    return data;
  }
}
