import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-05-maps.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-06-directions.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';

class HomeRegularMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  final bool isMemorial;
  final String memorialName;
  final String memorialImage;
  const HomeRegularMaps({required this.latitude, required this.longitude, required this.isMemorial, required this.memorialName, required this.memorialImage});

  HomeRegularMapsState createState() => HomeRegularMapsState();
}

class HomeRegularMapsState extends State<HomeRegularMaps>{
  CameraPosition? initialCameraPosition;
  GoogleMapController? googleMapController;
  Marker? origin;
  Marker? destination;
  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  Set<Marker> markers = {};
  RegularDirections? info;

  void initState(){
    super.initState();
    initialCameraPosition = CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 14.4746,);
    markers.add(Marker(
      markerId: const MarkerId('origin'), 
      position: LatLng(widget.latitude, widget.longitude),
      onTap: (){
        print('print hehehehe');
        customInfoWindowController.addInfoWindow!(
          ClipPath(
            clipper: MessageClipper(borderRadius: 10),
            // clipper: MiscRegularMessageClipper(),
            child: Container(
              color: const Color(0xffffffff),
              child: Column(
                children: [
                  Text('Here Lies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                  ListTile(
                    leading: widget.memorialImage != ''
                    ? CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xff888888),
                      foregroundImage: NetworkImage(widget.memorialImage),
                      backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                    )
                    : const CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xff888888),
                      foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                    ),
                    title: Text('${widget.memorialName}', maxLines: 2,),
                    subtitle: Text('${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}'),
                  ),

                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),

          LatLng(widget.latitude, widget.longitude),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('${widget.memorialName}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
        actions: [
          IconButton(
            onPressed: (){

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

    if(markers.length == 1){
      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Chosen location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: position,
        ));
      });

      final directions = await RegularDirectionsRepository().getDirections(
        origin: LatLng(widget.latitude, widget.longitude), 
        destination: position
      );

      setState(() {
        info = directions;
      });
    }
  }
}