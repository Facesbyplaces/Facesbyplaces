import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeBLMMaps extends StatefulWidget {
  final double latitude;
  final double longitude;

  const HomeBLMMaps({required this.latitude, required this.longitude});

  HomeBLMMapsState createState() => HomeBLMMapsState();
}

class HomeBLMMapsState extends State<HomeBLMMaps> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _kGooglePlex;

  void initState(){
    super.initState();
    _kGooglePlex = CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 14.4746,);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps',
          style: TextStyle(
            fontSize: SizeConfig.blockSizeVertical! * 2.74,
            fontFamily: 'NexaBold',
            color: const Color(0xffffffff),
          ),
        ),
        backgroundColor: const Color(0xff04ECFF),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}