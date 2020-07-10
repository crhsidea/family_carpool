import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoLocator extends StatefulWidget {
  @override
  _GeoLocatorState createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {

  LatLng location;
  // ignore: close_sinks
  StreamController<double> controller;
  Stream stream;
  

  Locator() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(position!=null) {
      setState(() {
        location = new LatLng(position.latitude, position.longitude);
      });


      updateMarker();

      if(mapController!=null) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(new CameraPosition(
                target: location,
                zoom: 18.00
            )));
      }

      if(!streaming){
        streaming = true;
        streamLocation().listen((value){
          print(value);
        });
      }

    }

  }


  Marker marker;


  void updateMarker(){
    setState(() {
      marker = Marker(
        markerId: MarkerId("Home"),
        position: location,
      );
    });
  }

  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  bool streaming = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Stream<Map<String, dynamic>> streamLocation() async* {

    while (true) {
      if (location!=null){
        await Future.delayed(Duration(seconds: 1));
        yield {'lat':location.latitude, 'long':location.longitude};
      }
    }

  }

  @override
  void initState() {

    Locator();
    controller = StreamController<double>();
    stream = controller.stream;

    super.initState();



  }

  String id = "Pointer";
  Set<Circle> circles (){
    return Set.from([Circle(
      circleId: CircleId(id),
      center: location,
      radius: 4000,
    )]);
  }


  @override
  Widget build(BuildContext context) {
    Locator();
    if(location!=null) {
      return Scaffold(
        body: GoogleMap(
          markers: Set.of((marker!=null)?[marker]:[]),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: 20.0,
          ),
          circles: circles(),
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

  @override
  void dispose() {
    controller.close(); //Streams must be closed when not needed
    super.dispose();
  }
}
