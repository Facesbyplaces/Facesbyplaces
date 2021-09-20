// ignore_for_file: file_names
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegularDirections{
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const RegularDirections({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory RegularDirections.fromMap(Map<String, dynamic> map){
    print('The map is $map');
    if((map['routes'] as List).isNotEmpty){
      final data = Map<String, dynamic>.from(map['routes'][0]);

      print('The data is $data');


      final northeast = data['bounds']['northeast'];
      final southwest = data['bounds']['southwest'];

      print('The northeast is $northeast');
      print('The southwest is $southwest');

      final bounds = LatLngBounds(
        northeast: LatLng(northeast['lat'], northeast['lng']),
        southwest: LatLng(southwest['lat'], southwest['lng']),
      );

      String distance = '';
      String duration = '';
      if((data['legs'] as List).isNotEmpty){
        final leg = data['legs'][0];
        print('The leg is $leg');
        
        distance = leg['distance']['text'];
        duration = leg['duration']['text'];
      }

      print('The distance is $distance');
      print('The duration is $duration');

      return RegularDirections(
        bounds: bounds,
        polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration,
      ); 
    }else{
      throw Exception('Something went wrong on Google Directions');
    }

  }
}