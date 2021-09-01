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
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:flutter/material.dart';

class HomeBLMMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  final bool isMemorial;
  const HomeBLMMaps({required this.latitude, required this.longitude, required this.isMemorial});

  HomeBLMMapsState createState() => HomeBLMMapsState();
}

class HomeBLMMapsState extends State<HomeBLMMaps>{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
      ),
      body: PlatformMap(
        initialCameraPosition: CameraPosition(
          target: const LatLng(47.6, 8.8796),
          zoom: 16.0,
        ),
        markers: Set<Marker>.of(
          [
            Marker(
              markerId: MarkerId('marker_1'),
              position: LatLng(widget.latitude, widget.longitude),
              consumeTapEvents: true,
              infoWindow: InfoWindow(
                title: 'PlatformMarker',
                snippet: "Hi I'm a Platform Marker",
              ),
              onTap: () {
                print("Marker tapped");
              },
            ),
          ],
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (location) => print('onTap: $location'),
        onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
        compassEnabled: true,
        onMapCreated: (controller) {
          Future.delayed(Duration(seconds: 2)).then(
            (_) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 270.0,
                    target: LatLng(widget.latitude, widget.longitude),
                    tilt: 30.0,
                    zoom: 18,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}