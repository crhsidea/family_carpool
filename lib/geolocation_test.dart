import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocator extends StatefulWidget {
  @override
  _GeoLocatorState createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {

  String location;

  Locator() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(position!=null) {
      setState(() {
        location = "${position.latitude}, ${position.longitude}";
      });
    }
  }

  @override
  void initState() {
    Locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locator();
    if(location!=null) {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text(
              '($location)'
            ),
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body: Container(
          child: Center(
            child: Text(
              'no'
            ),
          ),
        ),
      );
    }
  }
}
