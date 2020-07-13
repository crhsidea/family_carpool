import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

class GeoLocator extends StatefulWidget {
  @override
  _GeoLocatorState createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {

  Set<Polyline> polyline = new Set<Polyline>();

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

      if(false) {
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

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      print('1');
      mapController = controller;

      getRoute(location, LatLng(29.7353, -95.4609));
      getETA(location, LatLng(29.7353, -95.4609));

      print('here');
      if(route!=null) {
        polyline.add(
          Polyline(
            polylineId: PolylineId('route'),
            visible: true,
            points: route,
            width: 4,
            color: Colors.lightBlue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap,
          ),
        );
      }
      print('here 1');
    });
  }

  String password = "12345678";
  String userdata = "{rating:4}";
  String name = "Prasann";

  bool isViewer = false;


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

  List<LatLng> route;
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: 'AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ');

  getRoute(LatLng origin, LatLng destination) async {
    if(origin!=null&&destination!=null) {
      print('orgin: ${origin.toString()}');
      print('destination: ${destination.toString()}');
      route = await googleMapPolyline.getCoordinatesWithLocation(
        origin: origin,
        destination: destination,
        mode: RouteMode.driving,
      );
    }
  }

  getETA(LatLng origin, LatLng destination) async {
    Response etaResponse = await dio.get(
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ'
    );
    print('getting eta');
    print(etaResponse.data['rows'][0]['elements'][0]['duration']['text']);
    return etaResponse.toString();

  }


  @override
  Widget build(BuildContext context) {
    Locator();
    if(location!=null) {
      print(location.toString());
      print('it\'s this');
      return Scaffold(
        body: GoogleMap(
          markers: Set.of((marker!=null)?[marker]:[]),
          onMapCreated: _onMapCreated(mapController),
          polylines: polyline,
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: 1,
          ),
          mapType: MapType.normal,
          circles: circles(),
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
