import 'dart:convert';
import 'package:family_carpool/screens/home_page.dart';
import 'package:family_carpool/themes/colors.dart';
import 'package:family_carpool/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:family_carpool/widgets/home/show_routes.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;


class RoutePreviewPage extends StatefulWidget {

  final bool isFirst;
  final String name;
  final String description;
  final List<String> addrList;
  final String base;
  final bool isRoute;
  final bool isViewer;


  const RoutePreviewPage({Key key, this.isFirst, this.base, this.name, this.description, this.addrList, this.isRoute, this.isViewer}) : super(key: key);

  @override
  _RoutePreviewPageState createState() => _RoutePreviewPageState();
}

class _RoutePreviewPageState extends State<RoutePreviewPage> {


  List<LatLng> route = new List<LatLng>();
  Set<Polyline> polyline = {};
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: 'AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ');
  Dio dio = new Dio();
  String estimated = '';
  //List<String> addresses = ['2800 Post Oak Blvd, Houston, TX 77056', '600 Travis St, Houston, TX 77002', '1500 McKinney St, Houston, TX 77010', '6100 Main St, Houston, TX 77005', 'NRG Pkwy, Houston, TX 77054'];
  double nlat = 0;
  double nlong = 0;

  createRoute(LatLng origin, LatLng destination) async {
    if(origin!=null&&destination!=null) {
      print('orgin: ${origin.toString()}');
      print('destination: ${destination.toString()}');
      route = await googleMapPolyline.getCoordinatesWithLocation(
        origin: origin,
        destination: destination,
        mode: RouteMode.driving,
      );
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
  }

  Future getETA() async {
    print('running eta');
    Response etaResponse = await dio.get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${polyline.first.points[0].latitude},${polyline.first.points[0].longitude}&destinations=${polyline.last.points[polyline.last.points.length-1].latitude},${polyline.last.points[polyline.last.points.length-1].longitude}&key=AIzaSyCMg5dMbyzuuuBArqp7A0BArFxH80f2BJQ'
    );
    print('getting eta');
    print(etaResponse.data['rows'][0]['elements'][0]['duration']['text']);
    setState(() {
      estimated = etaResponse.data['rows'][0]['elements'][0]['duration']['text'].toString();
    });
  }

  Future submitRoute(BuildContext context) async{
    //TODO add the route points data here as well
    if (widget.isFirst){
      var routeJson = {
        'title':widget.name,
        'description':widget.description,
        'eta':estimated,
      };
      await http.get(widget.base+nlat.toString()+"/"+nlong.toString()+"/"+json.encode(routeJson));
    }


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomBar()),
    );

  }

  createRouteAddress(String origin, String destination, int index) async {
    if(origin!=null&&destination!=null) {
      print('orgin: ${origin.toString()}');
      print('destination: ${destination.toString()}');
      route = await googleMapPolyline.getPolylineCoordinatesWithAddress(
        origin: origin,
        destination: destination,
        mode: RouteMode.driving,
      );
      setState(() {
        polyline.add(
          Polyline(
            polylineId: PolylineId('route $index'),
            visible: true,
            points: route,
            width: 4,
            color: Colors.lightBlue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap,
          ),
        );
      });
      await getETA();
      setState(() {
        nlat = polyline.last.points[polyline.last.points.length-1].latitude;
        nlong = polyline.last.points[polyline.last.points.length-1].longitude;
      });
    }
  }

  @override
  void initState() {
    for(int i=0;i<widget.addrList.length-1;i++) {
      createRouteAddress(widget.addrList[i], widget.addrList[i+1], i);
      print('created route: ${widget.addrList[i]} to ${widget.addrList[i+1]}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  polyline != null ? RouteViewer(
                    routes: polyline,
                    isRoute: widget.isRoute,
                    isViewer: widget.isViewer,
                  ) : Container(),
                  GestureDetector(
                    onTap: () {
                      submitRoute(context);
                    },
                    child: Container(
                      height: 80,
                      width: width,
                      child: Container(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        width: width - 40,
                        decoration: BoxDecoration(
                          color: LightColors.kBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 450.0,
                          height: MediaQuery.of(context).size.height-260,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          decoration: new BoxDecoration(color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0),
                                bottomLeft: const Radius.circular(25.0),
                                bottomRight:const Radius.circular(25.0) ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],),

                          width: 500.0,
                          height: 190.0,
                          child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50.0,
                                    height: 75.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            alignment: Alignment.bottomLeft,

                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                "https://i.thecartoonist.me/cartoon-face-of-white-male.png")
                                        )
                                    )),
                                Text(
                                  "Mr.Swift",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),

                                Row(
                                  children: <Widget>[
                                    Text(
                                      "           Route ETA: $estimated     ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "     Driving EXP: 5 Yrs",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),

                                SizedBox(
                                  height: 5.0,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Hero(
                                    tag: "search",
                                    child: Container(
                                      height: 50.0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: FutureBuilder(
                                              future: Geocoder.local.findAddressesFromCoordinates(Coordinates(polyline.last.points[polyline.last.points.length-1].latitude, polyline.last.points[polyline.last.points.length-1].longitude)),
                                              builder: (context, snapshots) {
                                                if(snapshots.connectionState == ConnectionState.done) {
                                                  return Text(
                                                    "Destination: ${snapshots.data.first.addressLine}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  );
                                                }
                                                else {
                                                  return Text(
                                                    "Destination: loading",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ]
                          ),

                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
