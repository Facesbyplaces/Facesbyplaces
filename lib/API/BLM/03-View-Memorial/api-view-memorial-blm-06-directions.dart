import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BLMDirections{
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const BLMDirections({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory BLMDirections.fromMap(Map<String, dynamic> map){
    print('The map is $map');
    if((map['routes'] as List).isNotEmpty){
      final data = Map<String, dynamic>.from(map['routes'][0]);

      final northeast = data['bounds']['northeast'];
      final southwest = data['bounds']['southwest'];

      final bounds = LatLngBounds(
        northeast: LatLng(northeast['lat'], northeast['lng']),
        southwest: LatLng(southwest['lat'], southwest['lng']),
      );

      String distance = '';
      String duration = '';
      if((data['legs'] as List).isEmpty){
        final leg = data['legs'][0];
        distance = leg['distance']['text'];
        duration = leg['duration']['text'];
      }

      return BLMDirections(
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