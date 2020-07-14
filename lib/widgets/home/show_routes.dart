import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteViewer extends StatefulWidget {

  Set<Polyline> routes;

  RouteViewer({this.routes});

  @override
  _RouteViewerState createState() => _RouteViewerState();
}

class _RouteViewerState extends State<RouteViewer> {

  LatLng location = LatLng(30, -95);
  // ignore: close_sinks
  StreamController<double> controller;
  Stream stream;
  Dio dio = new Dio();


  Locator() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(position!=null) {
      if(!isViewer)
        setState(() {
          location = new LatLng(position.latitude, position.longitude);
          print(location.toString());
        });


      updateMarker();

      /*if(false) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(new CameraPosition(
                target: location,
                zoom: 19.00
            )));
      }*/

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

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      print('1');
      mapController = controller;

      print('here');

      print('here 1');
    });
  }

  String password = "12345678";
  String userdata = "{rating:4}";
  String name = "Prasann";

  bool isViewer = false;

  @override
  void initState() {

    Locator();
    controller = StreamController<double>();
    stream = controller.stream;

    super.initState();



  }

  String id = "Pointer";
  
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: 'AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ');



  @override
  Widget build(BuildContext context) {
    Locator();
    if(location!=null) {
      print('it\'s this');
      return Scaffold(
        body: GoogleMap(
          markers: Set.of((marker!=null)?[marker]:[]),
          onMapCreated: _onMapCreated(mapController),
          polylines: widget.routes,
          initialCameraPosition: CameraPosition(
            target: widget.routes.first.points[widget.routes.first.points.length~/2],
            zoom: 20,
          ),
          mapType: MapType.normal,
          buildingsEnabled: true,
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
