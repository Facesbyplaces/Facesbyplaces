import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-search-regular-02-search-extended.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as Location;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class HomeRegularSearch extends StatelessWidget{

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
                Expanded(
                  flex: 2,
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),
                Container(
                  width: SizeConfig.screenWidth / 1.3,
                  child: TextFormField(
                    controller: controller,
                    onFieldSubmitted: (String keyword) async{
                      Location.Location location = new Location.Location();

                      bool serviceEnabled = await location.serviceEnabled();
                      if (!serviceEnabled) {
                        serviceEnabled = await location.requestService();
                        if (!serviceEnabled) {
                          return;
                        }
                      }

                      Location.PermissionStatus permissionGranted = await location.hasPermission();
                      if (permissionGranted == Location.PermissionStatus.denied) {
                        permissionGranted = await location.requestPermission();
                        if (permissionGranted != Location.PermissionStatus.granted) {
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('FacesbyPlaces needs to access the location. Turn on the access on the settings.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.red,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }
                      }

                      context.showLoaderOverlay();
                      Location.LocationData locationData = await location.getLocation();
                      List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);
                      context.hideLoaderOverlay();

                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));
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
                          if (!serviceEnabled) {
                            serviceEnabled = await location.requestService();
                            if (!serviceEnabled) {
                              return;
                            }
                          }

                          Location.PermissionStatus permissionGranted = await location.hasPermission();
                          if (permissionGranted == Location.PermissionStatus.denied) {
                            permissionGranted = await location.requestPermission();
                            if (permissionGranted != Location.PermissionStatus.granted) {
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('FacesbyPlaces needs to access the location. Turn on the access on the settings.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                  onlyOkButton: true,
                                  buttonOkColor: Colors.red,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
                              );
                            }
                          }

                          context.showLoaderOverlay();
                          Location.LocationData locationData = await location.getLocation();
                          List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);
                          context.hideLoaderOverlay();

                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));
                        },
                        icon: Icon(Icons.search, color: Color(0xff888888),),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ), 
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight - kToolbarHeight) / 3.5,),

                  Icon(Icons.search, color: Color(0xff4EC9D4), size: 240),

                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                  SizedBox(height: (SizeConfig.screenHeight - kToolbarHeight) / 3.5,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
