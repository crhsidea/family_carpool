import 'package:http/http.dart' as http;

class Routes {

  String dates;
  String addresses;
  String users;
  double lat;
  double lng;
  String routedata;

  Routes({this.dates, this.addresses, this.users, this.lat, this.lng, this.routedata});

  post() {
    http.post(
      'users/byname/name?',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: toJson(),
    );
    //todo: put name later
  }

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      dates: json['dates'] as String,
      addresses: json['addresses'] as String,
      users: json['users'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      routedata: json['routedata'] as String,
    );
  }

  Map<String, dynamic> toJson() => _UserToJson(this);

  Map<String, dynamic> _UserToJson(Routes instance) {
    return <String, dynamic> {
      'dates': instance.dates,
      'addresses': instance.addresses,
      'users': instance.users,
      'lat': instance.lat,
      'lng': instance.lng,
      'routedata': instance.routedata
    };
  }

}