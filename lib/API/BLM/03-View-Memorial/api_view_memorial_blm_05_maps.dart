import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'api_view_memorial_blm_06_directions.dart';
import 'package:dio/dio.dart';

class RegularDirectionsRepository{
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;

  RegularDirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<BLMDirections> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async{
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg',
      },
    );

    if(response.statusCode == 200){
      return BLMDirections.fromMap(response.data);
    }else{
      throw Exception('Something went wrong on Google Maps');
    }
    
  }
}