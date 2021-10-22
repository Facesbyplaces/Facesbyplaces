import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

Future<APIRegularConvertCoordinates> apiRegularConvertCoordinates({required LatLng latLng}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg',);

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularConvertCoordinates.fromJson(newData);
  }else{
    throw Exception('Error occurred in convert coordinates: ${response.statusMessage}');
  }
}

class APIRegularConvertCoordinates{
  List<APIRegularConvertCoordinatesExtended> result;
  APIRegularConvertCoordinates({required this.result});

  factory APIRegularConvertCoordinates.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['results'] as List;
    List<APIRegularConvertCoordinatesExtended> newList = list.map((i) => APIRegularConvertCoordinatesExtended.fromJson(i)).toList();

    return APIRegularConvertCoordinates(
      result: newList,
    );
  }
}

class APIRegularConvertCoordinatesExtended{
  String formatttedAddress;
  APIRegularConvertCoordinatesExtended({required this.formatttedAddress});

  factory APIRegularConvertCoordinatesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConvertCoordinatesExtended(  
      formatttedAddress: parsedJson['formatted_address'] ?? '',
    );
  }
}