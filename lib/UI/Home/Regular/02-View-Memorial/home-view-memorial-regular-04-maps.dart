import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/material.dart';

class HomeRegularMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  final bool isMemorial;
  const HomeRegularMaps({required this.latitude, required this.longitude, required this.isMemorial});

  HomeRegularMapsState createState() => HomeRegularMapsState();
}

class HomeRegularMapsState extends State<HomeRegularMaps>{
  List<StaticPositionGeoPoint> staticPoints = [];
  MapController controller = MapController();

  void initState(){
    super.initState();
    controller = MapController(initMapWithUserPosition: false, initPosition: GeoPoint(latitude: widget.latitude, longitude: widget.longitude),);
    staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: widget.isMemorial == true ? Icon(MdiIcons.graveStone, color: Colors.blue,) : Icon(MdiIcons.human, color: Colors.blue,)), [GeoPoint(latitude: widget.latitude, longitude: widget.longitude)],),);
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
