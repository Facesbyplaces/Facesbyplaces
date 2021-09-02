// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:giffy_dialog/giffy_dialog.dart';
// import 'package:flutter/material.dart';

// class HomeBLMMaps extends StatefulWidget{
//   final double latitude;
//   final double longitude;
//   final bool isMemorial;
//   const HomeBLMMaps({required this.latitude, required this.longitude, required this.isMemorial});

//   HomeBLMMapsState createState() => HomeBLMMapsState();
// }

// class HomeBLMMapsState extends State<HomeBLMMaps>{
//   List<StaticPositionGeoPoint> staticPoints = [];
//   MapController controller = MapController();

//   void initState(){
//     super.initState();
//     controller = MapController(initMapWithUserPosition: false, initPosition: GeoPoint(latitude: widget.latitude, longitude: widget.longitude),);
//     staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: widget.isMemorial == true ? Icon(MdiIcons.graveStone, color: Colors.blue,) : Icon(MdiIcons.human, color: Colors.blue,)), [GeoPoint(latitude: widget.latitude, longitude: widget.longitude)],),);
//     Future.delayed(Duration(seconds: 5), () async{
//       await controller.zoom(5);
//     });
//   }

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Maps', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
//         backgroundColor: const Color(0xff04ECFF),
//       ),
//       body: OSMFlutter( 
//         controller: controller,
//         onGeoPointClicked: (GeoPoint value){
//           print('The latitude is ${value.latitude}');
//           print('The longitude is ${value.longitude}');
//         },
//         staticPoints: staticPoints,
//         road: Road(startIcon: MarkerIcon(icon: Icon(Icons.person, size: 64, color: Colors.brown,),), roadColor: Colors.yellowAccent,),
//         markerOption: MarkerOption(defaultMarker: MarkerIcon(icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56,),),),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             heroTag: 'button1',
//             child: const Icon(Icons.select_all),
//             onPressed: () async{
//               context.loaderOverlay.show();
//               await controller.removeLastRoad();
//               context.loaderOverlay.hide();

//               GeoPoint point1 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.blue, size: 48,),),);
//               RoadInfo roadInformation = await controller.drawRoad(point1, GeoPoint(latitude: widget.latitude, longitude: widget.longitude), roadOption: RoadOption(roadWidth: 10, roadColor: Colors.green, showMarkerOfPOI: false));

//               await showDialog(
//                 context: context,
//                 builder: (_) => AssetGiffyDialog(
//                   description: Text('Approximately ${(roadInformation.distance! * 0.62137).ceil()} miles from the location.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
//                   title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
//                   image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                   entryAnimation: EntryAnimation.DEFAULT,
//                   onlyOkButton: true,
//                   onOkButtonPressed: (){
//                     Navigator.pop(context, true);
//                   },
//                 ),
//               );

//               print('The distance is ${roadInformation.distance}');
//               print('The travel time in minutes is ${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}');
//             },  
//           ),

//           const SizedBox(height: 10,),

//           FloatingActionButton(
//             heroTag: 'button2',
//             child: const Icon(Icons.add),
//             onPressed: () async{
//               await controller.zoomIn();
//             },
//           ),

//           const SizedBox(height: 10,),

//           FloatingActionButton(
//             heroTag: 'button3',
//             child: const Icon(Icons.remove),
//             onPressed: () async{
//               await controller.zoomOut();
//             },
//           ),

//           const SizedBox(height: 10,),
//         ],
//       ),
//     );
//   }
// }



import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeBLMMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  final bool isMemorial;
  const HomeBLMMaps({required this.latitude, required this.longitude, required this.isMemorial});

  HomeBLMMapsState createState() => HomeBLMMapsState();
}

class HomeBLMMapsState extends State<HomeBLMMaps>{
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}