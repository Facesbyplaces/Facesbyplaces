import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api_create_memorial_blm_02_convert_name.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';

class HomeBLMCreateMemorialLocateMap extends StatefulWidget{
  const HomeBLMCreateMemorialLocateMap({Key? key}) : super(key: key);

  @override
  HomeBLMCreateMemorialLocateMapState createState() => HomeBLMCreateMemorialLocateMapState();
}

class HomeBLMCreateMemorialLocateMapState extends State<HomeBLMCreateMemorialLocateMap>{
  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  CameraPosition? initialCameraPosition;
  Set<Marker> markers = {};
  bool pinned = false;
  LatLng? memorial;

  @override
  void initState(){
    super.initState();
    initialCameraPosition = const CameraPosition(target: LatLng(37.78583400000001, -122.406417), zoom: 14.4746,);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Maps', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
        actions: [
          IconButton(
            onPressed: (){
              setState((){
                markers.clear();
                pinned = false;
              });
            },
            icon: const Icon(Icons.delete),
          ),

          IconButton(
            onPressed: () async{
              if(!pinned){
                await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Error',
                    description: 'Pin the location of the cemetery first before proceeding by long pressing the location of the memorial on the map.',
                    okButtonColor: const Color(0xfff44336), // RED
                    includeOkButton: true,
                  ),
                );
              }else{
                APIBLMConvertCoordinates location = await apiBLMConvertCoordinates(latLng: memorial!);
                Navigator.pop(context, [memorial, location.result[0].formatttedAddress]);
              }
            },
            icon: const Icon(Icons.send_outlined),
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
    if(markers.isEmpty){
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