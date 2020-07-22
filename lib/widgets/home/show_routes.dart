import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class RouteViewer extends StatefulWidget {

  final Set<Polyline> routes;
  final bool isRoute;
  final String driver;
  final bool isViewer;

  RouteViewer({this.routes, this.isRoute, this.driver, this.isViewer});

  @override
  _RouteViewerState createState() => _RouteViewerState();
}

class _RouteViewerState extends State<RouteViewer> {

  LatLng location = LatLng(30, -95);
  // ignore: close_sinks

  StreamController<double> controller;
  Stream stream;
  Dio dio = new Dio();




  bool zoomin = true;

  Locator() async {
    if(!streaming){
      await streamData();
    }
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if(position!=null) {
      if(widget.isViewer)
        setState(() {
          location = new LatLng(position.latitude, position.longitude);
          print(location.toString());
        });
        //updateMarks();

      if(zoomin&&mapController!=null) {
        mapController.animateCamera(
            CameraUpdate.newCameraPosition(new CameraPosition(
                target: location,
                zoom: 19.00
            )));
      }

    }

  }

  Set<Marker> stops = {};

  void addStops(){
    setState(() {
      var iter = widget.routes.iterator;
      while(iter.moveNext()) {
        stops.add(
          Marker(
            markerId: MarkerId('Marker ${iter.hashCode}'),
            position: iter.current.points[0]
          ),
        );
      }
      stops.add(
        Marker(
          markerId: MarkerId('destination'),
          position: widget.routes.last.points[widget.routes.last.points.length-1]
        ),
      );
    });
  }

  void updateMarks(){
    print(location.longitude);
    Set<Marker> temp = {};
    int i = 0;
    temp.add(Marker(
      markerId: MarkerId('curloc'),
      position: location,
      icon: BitmapDescriptor.fromAsset('Obama.PNG')
    ));
    for (Marker m in stops){
      if (i!=0)
        temp.add(m);
      i++;
    }
    setState(() {
      stops = temp;
    });
  }

  GoogleMapController mapController;


  bool streaming = false;

  Future getIP()async{

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/ip.txt');
      String temp = await file.readAsString();
      setState(() {
        baseaddr = temp;
      });
      print(temp);
    } catch (e) {
      print("Couldn't read file");
    }
  }

  String baseaddr;



  String uname = "";

  Future<String> getCurUser() async {
    String val = "";

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/user.txt');
      String temp = await file.readAsString();
      val = temp;
    } catch (e) {
      print("Couldn't read file");
    }
    return val;
  }

  Future<Stream<dynamic>>testStreams()async{

    print("started request");
    String url = "http://192.168.0.12:8080/users/locstream";


    var client = http.Client();
    var streamedResponse = await client.send(
        http.Request('get', Uri.parse(url))
    );
    //var request = await http.get("http://192.168.0.12:8080/users/locstream");
    //print(request.body.toString());
    return streamedResponse.stream.transform(utf8.decoder);
  }

  Future<Stream<dynamic>>streamLoc()async{

    print("started request");
    String url = "http://192.168.0.12:8080/users/locstream";


    var client = http.Client();
    var streamedResponse = await client.send(
        http.Request('get', Uri.parse(url))
    );
    //var request = await http.get("http://192.168.0.12:8080/users/locstream");
    //print(request.body.toString());
    return streamedResponse.stream.transform(utf8.decoder);
  }

  StreamSubscription subscription;

  Stream<Map<String, dynamic>> streamLocation() async*{
    while (true) {
      if (location!=null&&mounted){
        await Future.delayed(Duration(milliseconds: 2000));
        await http.get(baseaddr+"users/updatecoords/"+uname+"/"+location.latitude.toString()+"/"+location.longitude.toString());
        print(baseaddr+"users/updatecoords/"+uname+"/"+location.latitude.toString()+"/"+location.longitude.toString());
        yield {'lat':location.latitude, 'long':location.longitude};
      }
    }
  }



  Future streamData() async {
    setState(() {
      streaming = true;
    });

    String tmp = await getCurUser();
    uname = tmp;

    if (widget.driver==uname){
      subscription = streamLocation().listen((event) {


        print(event.toString());
      });
    }
    else{
      await testStreams().then((strm){
        print("STARTED");
        subscription = strm.listen((event) {
          print(event.toString());
          if(json.decode(event.toString())['drivername']==widget.driver &&mounted){
            setState(() {
              location = LatLng(json.decode(event.toString())["lat"], json.decode(event.toString())["lng"]);
            });
          }
        });
      });
    }

  }
  bool stopadded = false;


  _onMapCreated(GoogleMapController controller) {
    setState(() {
      if(stopadded){
        addStops();
        stopadded= true;
      }

      print('1');
      mapController = controller;

      print('here');

      print('here 1');
    });
  }

  @override
  void initState() {

    getIP();


    if(widget.isRoute){
      Locator();
      controller = StreamController<double>();
      stream = controller.stream;
    }



    super.initState();

  }

  String id = "Pointer";
  
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: 'AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ');




  @override
  Widget build(BuildContext context) {


    Set<Circle> circles;
    if(mounted&&ModalRoute.of(context).isCurrent){
      circles = Set.from([Circle(
          circleId: CircleId("curlocation"),
          center: location,
          radius: 20,
          fillColor: Colors.blue.withOpacity(.25)
      )]);

      if(widget.isRoute){
        controller = StreamController<double>();
        stream = controller.stream;
      }
      Locator();
    }
    if(location!=null&&mounted&&ModalRoute.of(context).isCurrent) {


      print('it\'s this');
      return Scaffold(
        body: GoogleMap(
          markers: stops,
          onMapCreated: _onMapCreated(mapController),
          polylines: widget.routes,
          initialCameraPosition: CameraPosition(
            target: widget.routes.first.points[widget.routes.first.points.length~/2],
            zoom: 10,
          ),
          mapType: MapType.normal,
          buildingsEnabled: true,
          circles: circles,
        ),
      );
    }
    else {
      return Scaffold(
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.close();
    subscription.cancel();//Streams must be closed when not needed
    super.dispose();
  }
}
