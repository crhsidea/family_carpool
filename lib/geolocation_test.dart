import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

class GeoLocator extends StatefulWidget {
  @override
  _GeoLocatorState createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {

  LatLng location = LatLng(30, -95);
  // ignore: close_sinks
  StreamController<double> controller;
  Stream stream;
  

  Locator() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(position!=null) {
      if(!isViewer)
        setState(() {
          location = new LatLng(position.latitude, position.longitude);
        });


      updateMarker();

      if(mapController!=null) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(new CameraPosition(
                target: location,
                zoom: 19.00
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

  String baseaddr = "http://192.168.0.12:8080/";

  final LatLng _center = const LatLng(45.521563, -122.677433);

  bool streaming = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String password = "12345678";
  String userdata = "{rating:4}";
  String name = "Prasann";

  bool isViewer = true;


  Stream<Map<String, dynamic>> streamLocation() async* {

    if (!isViewer)
      while (true) {
        if (location!=null){
          await Future.delayed(Duration(milliseconds: 2000));
          await http.get(baseaddr+"users/update/1/"+name+"/"+password+"/"+location.latitude.toString()+"/"+location.longitude.toString()+"/"+userdata);
          print(baseaddr+"users/update/1/"+name+"/"+password+"/"+location.latitude.toString()+"/"+location.longitude.toString()+"/"+userdata);
          yield {'lat':location.latitude, 'long':location.longitude};
        }
      }
    else{
      while (true) {
        if (location!=null){
          await Future.delayed(Duration(milliseconds: 2000));
          var h = await http.get(baseaddr+"users/byname/"+name);

          setState(() {
            location = LatLng(json.decode(h.body)["lat"], json.decode(h.body)["lng"]);
          });
          yield {'lat':location.latitude, 'long':location.longitude};
        }
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
