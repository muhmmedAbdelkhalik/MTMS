import 'dart:convert';

class Place {
  Place({
    this.name,
    this.longitude,
    this.latitude,
  });

  String? name;
  double? longitude;
  double? latitude;

  factory Place.fromRawJson(String str) => Place.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Place.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "longitude": longitude,
        "latitude": latitude,
      };
}
