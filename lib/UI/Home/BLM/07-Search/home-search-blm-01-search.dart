import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'home-search-blm-02-search-extended.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class HomeBLMSearch extends StatefulWidget{
  const HomeBLMSearch();

  HomeBLMSearchState createState() => HomeBLMSearchState();
}

class HomeBLMSearchState extends State<HomeBLMSearch>{
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context){
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              leading: Container(),
              backgroundColor: const Color(0xff04ECFF),
              flexibleSpace: Column(
                children: [
                  const Spacer(),

                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25),),),
                            focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25),),),
                            border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25),),),
                            hintStyle: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                            contentPadding: const EdgeInsets.all(15.0),
                            fillColor: const Color(0xffffffff),
                            focusColor: const Color(0xffffffff),
                            hintText: 'Search a Post',
                            filled: true,
                          ),
                          style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (String keyword) async{
                            Location.Location location = new Location.Location();
                            bool serviceEnabled = await location.serviceEnabled();

                            print('The value of serviceEnabled $serviceEnabled');

                            if(!serviceEnabled){
                              serviceEnabled = await location.requestService();
                              if(!serviceEnabled){
                                return;
                              }
                            }

                            Location.PermissionStatus permissionGranted = await location.hasPermission();

                            print('The permissionGranted is $permissionGranted');

                            if(permissionGranted != Location.PermissionStatus.granted){
                              print('Here 1');
                              bool confirmation = await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                  title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  onlyOkButton: false,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                  onCancelButtonPressed: (){
                                    Navigator.pop(context, false);
                                  },
                                ),
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
                              print('Here 2');
                              context.loaderOverlay.show();
                              print('lkjasdflkjasdf');
                              Location.LocationData locationData = await location.getLocation();
                              print('The latitude is ${locationData.latitude}');
                              print('The latitude is ${locationData.longitude}');
                              List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                              context.loaderOverlay.hide();

                              print('The latitude is ${locationData.latitude}');
                              print('The latitude is ${locationData.longitude}');

                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,),),);
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 20,),
                    ],
                  ),

                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          body: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(color: Colors.white, image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  Icon(Icons.search, color: const Color(0xff4EC9D4), size: 240),

                  const SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff6B6B6B)),),
                  ),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}