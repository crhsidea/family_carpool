import 'package:http/http.dart' as http;

class User {

  String name;
  String email;
  String password;
  double lat;
  double lng;
  String userdata;

  User({this.name, this.email, this.password, this.lat, this.lng});

  get() {
    http.get('users/byname/name?');
    //todo: put name later
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }

  Map<String, dynamic> toJson() => _UserToJson(this);

  Map<String, dynamic> _UserToJson(User instance) {
    return <String, dynamic> {
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'lat': instance.lat,
      'lng': instance.lng,
    };
  }

}