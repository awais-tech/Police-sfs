class PoliceStation {
  String Address;
  String Division;
  String Name;
  String NearstLocation;
  String NoofCells;
  String PostelCode;
  String StationPhoneno;
  String imageUrl;
  DateTime DateofEstablish;
  String id;

  PoliceStation({
    required this.Address,
    required this.Name,
    required this.Division,
    required this.NearstLocation,
    required this.NoofCells,
    required this.DateofEstablish,
    required this.PostelCode,
    required this.imageUrl,
    required this.StationPhoneno,
    required this.id,
  });
}
