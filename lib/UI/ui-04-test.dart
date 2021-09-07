import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class TestMap extends StatefulWidget{

  TestMapState createState() => TestMapState();
}

class TestMapState extends State<TestMap>{
  CameraPosition? initialCameraPosition;
  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  Set<Marker> markers = {};
  LatLng? memorial;
  bool pinned = false;

  void initState(){
    super.initState();
    initialCameraPosition = CameraPosition(target: LatLng(37.78583400000001, -122.406417), zoom: 14.4746,);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Test', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                markers.clear();
                pinned = false;
              });
              
              // setState(() {
              //   memorial = {};
              // });
            },
            icon: Icon(Icons.delete),
          ),

          IconButton(
            onPressed: () async{
              if(!pinned){
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: Text('Pin the location of the cemetery first before proceeding.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    entryAnimation: EntryAnimation.DEFAULT,
                    buttonOkColor: const Color(0xffff0000),
                    onlyOkButton: true,
                    onOkButtonPressed: (){
                      Navigator.pop(context, true);
                    },
                  ),
                );
              }else{
                print('heheheh');
              }
            },
            icon: Icon(Icons.send_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition!,
            markers: markers,
            onLongPress: _addMarker,
            onTap: (LatLng position){
              customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (CameraPosition position){
              customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller){
              customInfoWindowController.googleMapController = controller;
            },
          ),

          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 150,
            width: 300,
            offset: 50,
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng position) async{
    print('long press');

    print('The latitude is ${position.latitude}');
    print('The longitude is ${position.longitude}');

    if(markers.length == 0){
      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('Memorial'),
          infoWindow: const InfoWindow(title: 'Memorial'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: position,
        ));

        memorial = LatLng(position.latitude, position.longitude);
        pinned = true;
      });
    }
  }
}