import 'package:facesbyplaces/Configurations/size_configuration.dart';
// ignore: library_prefixes
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'home_search_blm_02_search_extended.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class HomeBLMSearch extends StatefulWidget{
  const HomeBLMSearch({Key? key}) : super(key: key);

  @override
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
            preferredSize: const Size.fromHeight(70.0),
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
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25),),),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25),),),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25),),),
                            hintStyle: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                            contentPadding: EdgeInsets.all(15.0),
                            fillColor: Color(0xffffffff),
                            focusColor: Color(0xffffffff),
                            hintText: 'Search a Post',
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (String keyword) async{
                            Location.Location location = Location.Location();
                            bool serviceEnabled = await location.serviceEnabled();

                            if(!serviceEnabled){
                              serviceEnabled = await location.requestService();
                              if(!serviceEnabled){
                                return;
                              }
                            }

                            Location.PermissionStatus permissionGranted = await location.hasPermission();

                            if(permissionGranted != Location.PermissionStatus.granted){
                              bool confirmation = await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: const Text('FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                  title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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

                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                              }
                            }else{
                              context.loaderOverlay.show();
                              Location.LocationData locationData = await location.getLocation();
                              List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                              context.loaderOverlay.hide();

                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,),),);
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 20,),
                    ],
                  ),

                  const SizedBox(height: 5,),
                ],
              ),
            ),
          ),
          body: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: const BoxDecoration(color: Colors.white, image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  const Icon(Icons.search, color: Color(0xff4EC9D4), size: 240),

                  const SizedBox(height: 20),

                  const Padding(
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