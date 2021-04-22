import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-search-regular-02-search-extended.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as Location;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class HomeRegularSearch extends StatefulWidget{

  HomeRegularSearchState createState() => HomeRegularSearchState();
}

class HomeRegularSearchState extends State<HomeRegularSearch>{

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
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),

                Expanded(
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: controller,
                      onFieldSubmitted: (String keyword) async{
                        Location.Location location = new Location.Location();
                        bool serviceEnabled = await location.serviceEnabled();

                        print('The value of serviceEnabled $serviceEnabled');

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
                              title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
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

                            context.showLoaderOverlay();
                            Location.LocationData locationData = await location.getLocation();
                            List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                            context.hideLoaderOverlay();

                            print('The latitude is ${locationData.latitude}');
                            print('The latitude is ${locationData.longitude}');

                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                          }
                        }else{
                          context.showLoaderOverlay();
                          Location.LocationData locationData = await location.getLocation();
                          List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                          context.hideLoaderOverlay();

                          print('The latitude is ${locationData.latitude}');
                          print('The latitude is ${locationData.longitude}');

                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        focusColor: Color(0xffffffff),
                        hintText: 'Search a Memorial',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                  title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
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

                                context.showLoaderOverlay();
                                Location.LocationData locationData = await location.getLocation();
                                List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                                context.hideLoaderOverlay();

                                print('The latitude is ${locationData.latitude}');
                                print('The latitude is ${locationData.longitude}');

                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                              }
                            }else{
                              context.showLoaderOverlay();
                              Location.LocationData locationData = await location.getLocation();
                              List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                              context.hideLoaderOverlay();

                              print('The latitude is ${locationData.latitude}');
                              print('The latitude is ${locationData.longitude}');

                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                            }
                          },
                          icon: Icon(Icons.search, color: Color(0xff888888),),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 20,),
              ],
            ), 
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight! - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  Icon(Icons.search, color: Color(0xff4EC9D4), size: 240),

                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

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