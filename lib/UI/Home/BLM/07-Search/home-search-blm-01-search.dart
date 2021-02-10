import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'home-search-blm-02-search-extended.dart';
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
                Expanded(
                  flex: 2,
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),
                Container(
                  width: SizeConfig.screenWidth / 1.3,
                  child: TextFormField(
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
                          return;
                        }
                      }

                      context.showLoaderOverlay();
                      Location.LocationData locationData = await location.getLocation();
                      List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);
                      context.hideLoaderOverlay();

                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Color(0xffffffff),
                      focusColor: Color(0xffffffff),
                      hintText: 'Search a Memorial',
                      hintStyle: TextStyle(
                        // fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        fontSize: 14,
                      ),
                      // prefixIcon: Icon(Icons.search, color: Colors.grey),
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

                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: controller.text, newToggle: 0, latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));
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
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              height: SizeConfig.screenHeight,
              child: Column(
                children: [

                  Expanded(child: Container(),),

                  GestureDetector(onTap: (){}, child: Center(child: CircleAvatar(maxRadius: 80, backgroundColor: Color(0xffEFFEFF), child: Icon(Icons.search, color: Color(0xff4EC9D4), size: 120),),),),

                  // SizedBox(height: ScreenUtil().setHeight(20)),
                  SizedBox(height: 20,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                  Expanded(child: Container(),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}