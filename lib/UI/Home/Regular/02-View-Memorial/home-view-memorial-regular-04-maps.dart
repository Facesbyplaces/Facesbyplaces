import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/material.dart';

class HomeRegularMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  const HomeRegularMaps({required this.latitude, required this.longitude});

  HomeRegularMapsState createState() => HomeRegularMapsState();
}

class HomeRegularMapsState extends State<HomeRegularMaps>{
  List<StaticPositionGeoPoint> staticPoints = [];
  MapController controller = MapController();

  void initState(){
    super.initState();
    controller = MapController(initMapWithUserPosition: false, initPosition: GeoPoint(latitude: widget.latitude, longitude: widget.longitude),);
    staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: Icon(MdiIcons.graveStone, color: Colors.blue,)), [GeoPoint(latitude: widget.latitude, longitude: widget.longitude)],),);
    Future.delayed(Duration(seconds: 5), () async {
      await controller.zoom(5);
    });
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
        actions: [
          IconButton(
            onPressed: () async{
              // controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56,)));

              // try {
              //   await controller.removeLastRoad();

              //   ///selection geoPoint
              //   GeoPoint point = await controller.selectPosition(
              //       icon: MarkerIcon(
              //     icon: Icon(
              //       Icons.location_history,
              //       color: Colors.amber,
              //       size: 48,
              //     ),
              //   ));

              //   // GeoPoint pointM1 = await controller.selectPosition();
              //   // GeoPoint pointM2 = await controller.selectPosition(
              //   //     imageURL:
              //   //         "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png");
              //   //
              //   GeoPoint point2 = await controller.selectPosition();
              //   RoadInfo roadInformation = await controller.drawRoad(
              //       point, point2,
              //       //interestPoints: [pointM1, pointM2],
              //       roadOption: RoadOption(
              //           roadWidth: 10,
              //           roadColor: Colors.blue,
              //           showMarkerOfPOI: false));
              //   print(
              //       "duration:${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}");
              //   print("distance:${roadInformation.distance}Km");
              // } on RoadException catch (e) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //         "${e.errorMessage()}",
              //       ),
              //     ),
              //   );
              // }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: OSMFlutter( 
        controller: controller,
        trackMyPosition: false,
        onGeoPointClicked: (GeoPoint value){
          print('The latitude is ${value.latitude}');
          print('The longitude is ${value.longitude}');
        },
        staticPoints: staticPoints,
        road: Road(startIcon: MarkerIcon(icon: Icon(Icons.person, size: 64, color: Colors.brown,),), roadColor: Colors.yellowAccent,),
        markerOption: MarkerOption(defaultMarker: MarkerIcon(icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56,),),),
      ),
    );
  }
}
