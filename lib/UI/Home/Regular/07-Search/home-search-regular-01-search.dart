import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-search-regular-02-search-extended.dart';
import 'package:location/location.dart' as Location;
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class RegularArguments {
  final String title;
  final int tab;

  RegularArguments(this.title, this.tab);
}

class HomeRegularSearch extends StatelessWidget{

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
                  child:  TextFormField(
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
                          await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'FacesbyPlaces needs to access the location. Turn on the access on the settings.'));
                        }
                      }

                      Location.LocationData locationData = await location.getLocation();
                      List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Color(0xffffffff),
                      focusColor: Color(0xffffffff),
                      hintText: 'Search a Memorial',
                      hintStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
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
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              height: SizeConfig.screenHeight,
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 25,),

                  GestureDetector(onTap: (){}, child: Center(child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xffEFFEFF), child: Icon(Icons.search, color: Color(0xff4EC9D4), size: SizeConfig.blockSizeVertical * 15),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
