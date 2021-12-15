import 'dart:convert';

class Cities {
  Cities({
    this.country,
    this.name,
    this.lat,
    this.lng,
  });

  String? country;
  String? name;
  String? lat;
  String? lng;

  factory Cities.fromRawJson(String str) => Cities.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        country: json["country"],
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "name": name,
        "lat": lat,
        "lng": lng,
      };
}
