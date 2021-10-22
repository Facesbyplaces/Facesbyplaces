import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

Future<APIBLMConvertCoordinates> apiBLMConvertCoordinates({required LatLng latLng}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg',);

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMConvertCoordinates.fromJson(newData);
  }else{
    throw Exception('Error occurred in convert coordinates: ${response.statusMessage}');
  }
}

class APIBLMConvertCoordinates{
  List<APIBLMConvertCoordinatesExtended> result;
  APIBLMConvertCoordinates({required this.result});

  factory APIBLMConvertCoordinates.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['results'] as List;
    List<APIBLMConvertCoordinatesExtended> newList = list.map((i) => APIBLMConvertCoordinatesExtended.fromJson(i)).toList();

    return APIBLMConvertCoordinates(
      result: newList,
    );
  }
}

class APIBLMConvertCoordinatesExtended{
  String formatttedAddress;
  APIBLMConvertCoordinatesExtended({required this.formatttedAddress});

  factory APIBLMConvertCoordinatesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConvertCoordinatesExtended(  
      formatttedAddress: parsedJson['formatted_address'] ?? '',
    );
  }
}