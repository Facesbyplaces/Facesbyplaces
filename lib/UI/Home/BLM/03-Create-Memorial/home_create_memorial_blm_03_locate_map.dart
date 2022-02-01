import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api_create_memorial_blm_02_convert_name.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_place/google_place.dart';
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

  ValueNotifier<List<String>> places = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> descriptionPlaces = ValueNotifier<List<String>>([]);
  ValueNotifier<bool> empty = ValueNotifier<bool>(true);
  List<String> placeId = [];

  @override
  void initState(){
    super.initState();
    initialCameraPosition = const CameraPosition(target: LatLng(37.78583400000001, -122.406417), zoom: 14.4746,);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: places,
      builder: (_, List<String> placesListener, __) => ValueListenableBuilder(
        valueListenable: descriptionPlaces,
        builder: (_, List<String> descriptionPlacesListener, __) => ValueListenableBuilder(
          valueListenable: empty,
          builder: (_, bool emptyListener, __) => Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Maps', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xffffffff),),),
              backgroundColor: const Color(0xff04ECFF),
              actions: [
                IconButton(
                  onPressed: () async{
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Unsure',
                        description: 'If the person is not buried or if you are unsure, you can opt out on pinning on the maps.',
                        okButtonColor: const Color(0xff4caf50), // GREEN
                        includeOkButton: true,
                        okButton: (){
                          Navigator.pop(context);
                          Navigator.pop(context, 'Unavailable');
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.help),
                ),

                IconButton(
                  onPressed: (){
                    setState(() {
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

                Positioned(
                  top: 10,
                  right: 15,
                  left: 15,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              splashColor: Colors.grey,
                              icon: const Icon(Icons.menu),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: TextField(
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.go,
                                onChanged: (String newPlaces) async{
                                  if(newPlaces == ''){
                                    empty.value = true;
                                    places.value = [];
                                    descriptionPlaces.value = [];
                                  }else{
                                    GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                                    var result = await googlePlace.autocomplete.get(newPlaces);

                                    places.value = [];
                                    descriptionPlaces.value = [];
                                    placeId = [];

                                    if(result != null){
                                      for(int i = 0; i < result.predictions!.length; i++){
                                        places.value.add('${result.predictions![i].terms![0].value}, ${result.predictions![i].terms![1].value}');
                                        placeId.add('${result.predictions![i].placeId}');
                                        descriptionPlaces.value.add('${result.predictions![i].description}');
                                      }
                                      empty.value = false;
                                    }
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "Search..."
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      emptyListener
                      ? const SizedBox(height: 0)
                      : Container(
                        color: const Color(0xffffffff), 
                        height: SizeConfig.screenHeight! - 200,
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: placesListener.length,
                          separatorBuilder: (context, index){
                            return const Divider(thickness: 1, color: Color(0xff888888),);
                          },
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(placesListener[index], style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(descriptionPlacesListener[index], style: const TextStyle(fontSize: 14, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                  const SizedBox(height: 5,),

                                  const Text('Click to add on your post', style: TextStyle(fontSize: 12, fontFamily: 'NexaRegular', color: Color(0xff888888),),),
                                ],
                              ),
                              onTap: () async{
                                setState(() {
                                  markers.clear();
                                  pinned = false;
                                });

                                GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                                var newResult = await googlePlace.details.get(placeId[index]);

                                APIBLMConvertCoordinates location = await apiBLMConvertCoordinates(latLng: LatLng(newResult!.result!.geometry!.location!.lat!, newResult.result!.geometry!.location!.lng!));
                                Navigator.pop(context, [LatLng(newResult.result!.geometry!.location!.lat!, newResult.result!.geometry!.location!.lng!), location.result[0].formatttedAddress]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                CustomInfoWindow(
                  controller: customInfoWindowController,
                  height: 150,
                  width: 300,
                  offset: 50,
                ),
              ],
            ),
          )
        ),
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
          draggable: true,
        ));

        memorial = LatLng(position.latitude, position.longitude);
        pinned = true;
        customInfoWindowController.googleMapController!.moveCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
      });
    }
  }
}