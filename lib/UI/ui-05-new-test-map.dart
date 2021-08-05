import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class TestMap extends StatefulWidget{
  TestMapState createState() => TestMapState();
}

class TestMapState extends State<TestMap>{
  List<StaticPositionGeoPoint> staticPoints = [];
  MapController controller = MapController();
  // MapController controller2 = MapController();

  bool pos = false;
  // GeoPoint point1 = GeoPoint(latitude: 0, longitude: 0);
  // GeoPoint point2 = GeoPoint(latitude: 0, longitude: 0);
  // GeoPoint? point1;
  // GeoPoint? point2;

  void initState(){
    super.initState();
    controller = MapController(initMapWithUserPosition: false, initPosition: GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938),);
    // controller2 = MapController(initMapWithUserPosition: false, initPosition: GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938),);
    staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: Icon(Icons.person)), [GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938)],),);
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: OSMFlutter( 
        controller: controller,
        trackMyPosition: false,
        // trackMyPosition: true,
        onGeoPointClicked: (GeoPoint value){
          print('The latitude is ${value.latitude}');
          print('The longitude is ${value.longitude}');
        },
        staticPoints: staticPoints,
        road: Road(startIcon: MarkerIcon(icon: Icon(Icons.person, size: 64, color: Colors.brown,),), roadColor: Colors.yellowAccent,),
        markerOption: MarkerOption(defaultMarker: MarkerIcon(icon: Icon(Icons.person_pin_circle, color: Colors.blue, size: 56,),),),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //   child: Icon(Icons.delete),
          //   onPressed: () async{
          //     context.loaderOverlay.show();
          //     await controller.removeLastRoad();
          //     staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: Icon(Icons.person)), [GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938)],),);
          //     context.loaderOverlay.hide();
          //   },
          // ),

          // SizedBox(height: 10,),

          FloatingActionButton(
            child: Icon(Icons.select_all),
            onPressed: () async{
              

              // if(pos == true){
              //   point2 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.red, size: 48,),),);
              //   // pos = false;
              //   // RoadInfo roadInformation = await controller.drawRoad(point);
              // }else{
              //   await controller.removeLastRoad();
              //   // point1 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.blue, size: 48,),),);
              //   // point1 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.blue, size: 48,),),);
              //   pos = true;
              // }

              // if(pos == true){
              //   // RoadInfo roadInformation = await controller.drawRoad(point1!, point2!, roadOption: RoadOption(roadWidth: 10, roadColor: Colors.green, showMarkerOfPOI: false));
              //   RoadInfo roadInformation = await controller.drawRoad(point1, point2, roadOption: RoadOption(roadWidth: 10, roadColor: Colors.green, showMarkerOfPOI: false));
              //   pos = false;
              // }



              // await controller.removeLastRoad();
              // GeoPoint point1 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.blue, size: 48,),),);
              // GeoPoint point2 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.red, size: 48,),),);
              // RoadInfo roadInformation = await controller.drawRoad(point1, point2, roadOption: RoadOption(roadWidth: 10, roadColor: Colors.green, showMarkerOfPOI: false));

              // print('The distance is ${roadInformation.distance}');
              // print('The travel time in minutes is ${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}');





              context.loaderOverlay.show();
              await controller.removeLastRoad();
              context.loaderOverlay.hide();
              GeoPoint point1 = await controller.selectPosition(icon: MarkerIcon(icon: Icon(Icons.location_history, color: Colors.blue, size: 48,),),);
              RoadInfo roadInformation = await controller.drawRoad(point1, GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938), roadOption: RoadOption(roadWidth: 10, roadColor: Colors.green, showMarkerOfPOI: false));
              

              await showDialog(
                context: context,
                builder: (_) => AssetGiffyDialog(
                  description: Text('Approximately ${roadInformation.distance! * 0.62137} miles from the location.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                  title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                  entryAnimation: EntryAnimation.DEFAULT,
                  onlyOkButton: true,
                  onOkButtonPressed: (){
                    Navigator.pop(context, true);
                  },
                ),
              );

              // staticPoints.add(StaticPositionGeoPoint('Marker', MarkerIcon(icon: Icon(Icons.person)), [GeoPoint(latitude: 37.78556405447126, longitude: -122.40161667090938)],),);
              print('The distance is ${roadInformation.distance}');
              print('The distance is ${roadInformation.distance! * 0.62137}');
              print('The travel time in minutes is ${Duration(seconds: roadInformation.duration!.toInt()).inMinutes}');

              
            },  
          ),

          SizedBox(height: 10,),

          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async{
              await controller.zoomIn();
            },
          ),

          SizedBox(height: 10,),

          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () async{
              await controller.zoomOut();
            },
          ),

          SizedBox(height: 10,),
        ],
      ),
      // floatingActionButton: IconButton(
      //       icon: Icon(Icons.add),
      //       onPressed: (){

      //       },
      //     ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
