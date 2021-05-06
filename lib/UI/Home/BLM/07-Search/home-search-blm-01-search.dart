import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'home-search-blm-02-search-extended.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class HomeBLMSearch extends StatefulWidget{

  HomeBLMSearchState createState() => HomeBLMSearchState();
}

class HomeBLMSearchState extends State<HomeBLMSearch>{
  
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),

                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    onFieldSubmitted: (String keyword) async{
                      Location.Location location = new Location.Location();
                      bool serviceEnabled = await location.serviceEnabled();

                      print('The serviceEnabled is $serviceEnabled');

                      if (!serviceEnabled) {
                        serviceEnabled = await location.requestService();
                        if (!serviceEnabled) {
                          return;
                        }
                      }

                      Location.PermissionStatus permissionGranted = await location.hasPermission();

                      print('The permissionGranted is $permissionGranted');

                      if (permissionGranted != Location.PermissionStatus.granted) {
                        bool confirmation = await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: const Text('Confirm', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: const Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?',
                              textAlign: TextAlign.center,
                            ),
                            onlyOkButton: false,
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                            onCancelButtonPressed: () {
                              Navigator.pop(context, false);
                            },
                          )
                        );

                        if(confirmation == true){
                          permissionGranted = await location.requestPermission();

                          context.loaderOverlay.show();
                          Location.LocationData locationData = await location.getLocation();
                          List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                          context.loaderOverlay.hide();

                          print('The latitude is ${locationData.latitude}');
                          print('The latitude is ${locationData.longitude}');

                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                        }
                      }else{
                        context.loaderOverlay.show();
                        Location.LocationData locationData = await location.getLocation();
                        List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                        context.loaderOverlay.hide();

                        print('The latitude is ${locationData.latitude}');
                        print('The latitude is ${locationData.longitude}');

                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      focusColor: const Color(0xffffffff),
                      hintText: 'Search a Memorial',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: const BorderSide(color: const Color(0xffffffff)),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      enabledBorder:  const OutlineInputBorder(
                        borderSide: const BorderSide(color: const Color(0xffffffff)),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      focusedBorder:  const OutlineInputBorder(
                        borderSide: const BorderSide(color: const Color(0xffffffff)),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async{
                          Location.Location location = new Location.Location();
                          bool serviceEnabled = await location.serviceEnabled();

                          print('The serviceEnabled is $serviceEnabled');

                          if (!serviceEnabled) {
                            serviceEnabled = await location.requestService();
                            if (!serviceEnabled) {
                              return;
                            }
                          }

                          Location.PermissionStatus permissionGranted = await location.hasPermission();

                          print('The permissionGranted is $permissionGranted');

                          if (permissionGranted != Location.PermissionStatus.granted) {
                            bool confirmation = await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Confirm', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: false,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                                onCancelButtonPressed: () {
                                  Navigator.pop(context, false);
                                },
                              )
                            );

                            if(confirmation == true){
                              permissionGranted = await location.requestPermission();

                              context.loaderOverlay.show();
                              Location.LocationData locationData = await location.getLocation();
                              List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                              context.loaderOverlay.hide();

                              print('The latitude is ${locationData.latitude}');
                              print('The latitude is ${locationData.longitude}');

                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                            }
                          }else{
                            context.loaderOverlay.show();
                            Location.LocationData locationData = await location.getLocation();
                            List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                            context.loaderOverlay.hide();

                            print('The latitude is ${locationData.latitude}');
                            print('The latitude is ${locationData.longitude}');

                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                          }
                        },
                        icon:const  Icon(Icons.search, color: const Color(0xff888888),),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 20,),
              ],
            ), 
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight! - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  const Icon(Icons.search, color: const Color(0xff4EC9D4), size: 240),

                  const SizedBox(height: 20,),

                  const Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0), child: const Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}