import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_05_maps.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_06_directions.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';

class HomeBLMMaps extends StatefulWidget{
  final double latitude;
  final double longitude;
  final bool isMemorial;
  final String memorialName;
  final String memorialImage;
  const HomeBLMMaps({Key? key, required this.latitude, required this.longitude, required this.isMemorial, required this.memorialName, required this.memorialImage}) : super(key: key);

  @override
  HomeRegularMapsState createState() => HomeRegularMapsState();
}

class HomeRegularMapsState extends State<HomeBLMMaps>{
  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  GoogleMapController? googleMapController;
  CameraPosition? initialCameraPosition;
  Marker? origin;
  Marker? destination;
  Set<Marker> markers = {};
  RegularDirections? info;

  @override
  void initState(){
    super.initState();
    initialCameraPosition = CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 14.4746,);
    markers.add(Marker(
      markerId: const MarkerId('origin'), 
      position: LatLng(widget.latitude, widget.longitude),
      onTap: (){
        customInfoWindowController.addInfoWindow!(
          ClipPath(
            clipper: MessageClipper(borderRadius: 10),
            child: Container(
              color: const Color(0xffffffff),
              child: Column(
                children: [
                  const Text('Here Lies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

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
                      backgroundColor: Color(0xff888888),
                      foregroundImage:AssetImage('assets/icons/app-icon.png'),
                    ),
                    title: Text(widget.memorialName, maxLines: 2,),
                    subtitle: Text('${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}'),
                  ),

                  const SizedBox(height: 20,),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.memorialName, style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xffffffff),),),
        backgroundColor: const Color(0xff04ECFF),
        actions: [
          IconButton(
            onPressed: (){
              googleMapController!.animateCamera(
                info != null
                ? CameraUpdate.newLatLngBounds(info!.bounds, 100.0)
                : CameraUpdate.newCameraPosition(initialCameraPosition!),
              );
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
            polylines: {
              info != null
              ? Polyline(
                polylineId: const PolylineId('overview_polyline'),
                color: const Color(0xff04ECFF),
                width: 5,
                points: info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList()
              )
              : const Polyline(polylineId: PolylineId('blank'),),
            },
          ),

          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 150,
            width: 300,
            offset: 50,
          ),

          info != null
          ? Positioned(
            top: 20.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0,),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6.0,),
                ],
              ),
              child: Text('${info!.totalDistance}, ${info!.totalDuration}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
            ),
          )
          : const SizedBox(),
        ],
      ),
    );
  }

  void _addMarker(LatLng position) async{
    if(markers.length == 1){
      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Your chosen location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: position,
        ));
      });

      final directions = await RegularDirectionsRepository().getDirections(
        origin: LatLng(widget.latitude, widget.longitude), 
        destination: position
      );

      customInfoWindowController.addInfoWindow!(
        ClipPath(
          clipper: MessageClipper(borderRadius: 10),
          child: Container(
            color: const Color(0xffffffff),
            child: Column(
              children: [
                const Text('Here Lies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

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
                    backgroundColor: Color(0xff888888),
                    foregroundImage: AssetImage('assets/icons/app-icon.png'),
                  ),
                  title: Text(widget.memorialName, maxLines: 2,),
                  subtitle: Text('${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}'),
                ),

                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),

        LatLng(widget.latitude, widget.longitude),
      );

      setState(() {
        info = directions;
      });
    }
  }
}