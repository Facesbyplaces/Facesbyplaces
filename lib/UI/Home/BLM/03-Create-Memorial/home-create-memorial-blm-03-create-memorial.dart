import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api-create-memorial-blm-01-create-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeBLMCreateMemorial3 extends StatefulWidget{
  final String relationship;
  final String locationOfIncident;
  final String precinct;
  final String dob;
  final String rip;
  final String country;
  final String state;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;

  HomeBLMCreateMemorial3({
    required this.relationship, 
    required this.locationOfIncident, 
    required this.precinct, 
    required this.dob, 
    required this.rip, 
    required this.country, 
    required this.state,
    required this.description,
    required this.memorialName,
    required this.imagesOrVideos,
  });

  HomeBLMCreateMemorial3State createState() => HomeBLMCreateMemorial3State(relationship: relationship, locationOfIncident: locationOfIncident, precinct: precinct, dob: dob, rip: rip, country: country, state: state, description: description, memorialName: memorialName, imagesOrVideos: imagesOrVideos);
}

class HomeBLMCreateMemorial3State extends State<HomeBLMCreateMemorial3>{

  final String relationship;
  final String locationOfIncident;
  final String precinct;
  final String dob;
  final String rip;
  final String country;
  final String state;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;

  HomeBLMCreateMemorial3State({
    required this.relationship, 
    required this.locationOfIncident, 
    required this.precinct, 
    required this.dob, 
    required this.rip, 
    required this.country, 
    required this.state,
    required this.description,
    required this.memorialName,
    required this.imagesOrVideos,
  });

  File? backgroundImage;
  File? profileImage;
  final picker = ImagePicker();
  List<String> backgroundImages = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
  int backgroundImageToggle = 0;

  Future getProfileImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future getBackgroundImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        backgroundImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
        centerTitle: true,
        backgroundColor: Color(0xff04ECFF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [

          MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [

                SizedBox(height: 20,),

                Text('Upload or Select an Image', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                SizedBox(height: 20,),

                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: backgroundImage != null
                      ? AssetImage(backgroundImage!.path)
                      : AssetImage('assets/icons/profile_post1.png'),
                    ),
                  ),
                  child: Stack(
                    children: [

                      GestureDetector(
                        onTap: () async{
                          await getProfileImage();
                        },
                        child: Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xffffffff),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage != null
                                ? AssetImage(profileImage!.path)
                                : AssetImage('assets/icons/cover-icon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 40,
                        left: SizeConfig.screenWidth! / 2,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xffffffff),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xffffffff),
                          child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: 40,),

                Text('Choose Background', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                SizedBox(height: 20,),

                Container(
                  height: 100,
                  child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return ((){
                        if(index == 4){
                          return GestureDetector(
                            onTap: () async{
                              setState(() {
                                backgroundImageToggle = index;
                              });

                              await getBackgroundImage();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffcccccc),
                                border: Border.all(color: Color(0xff000000),),
                              ),
                            ),
                          );
                        }else{
                          return GestureDetector(
                            onTap: () async{

                              final ByteData bytes = await rootBundle.load(backgroundImages[index]);
                              final Uint8List list = bytes.buffer.asUint8List();

                              final tempDir = await getTemporaryDirectory();
                              final file = await new File('${tempDir.path}/blm-background-image-$index.png').create();
                              file.writeAsBytesSync(list);                              

                              setState(() {
                                backgroundImageToggle = index;
                                backgroundImage = file;
                              });
                            },
                            child: backgroundImageToggle == index
                            ? Container(
                              padding: EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xff04ECFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(backgroundImages[index]),
                                  ),
                                ),
                              ),
                            )
                            : Container(
                              padding: EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(backgroundImages[index]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }());
                    }, 
                    separatorBuilder: (context, index){
                      return SizedBox(width: 25);
                    },
                    itemCount: 5,
                  ),
                ),

                SizedBox(height: 20,),

                Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: 80,),

                MiscBLMButtonTemplate(
                  width: 150,
                  height: 45,
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

                    if (permissionGranted != Location.PermissionStatus.granted) {
                      // await showOkAlertDialog(
                      //   context: context,
                      //   title: 'Error',
                      //   message: 'FacesbyPlaces needs to access the location. Turn on the access on the settings.',
                      // );
                      var confirmation = await showOkCancelAlertDialog(
                        context: context,
                        title: 'Confirm',
                        message: 'FacesbyPlaces needs to access the location to locate for memorials. Do you wish to turn it on?',
                        okLabel: 'Yes',
                        cancelLabel: 'No',
                      );

                      if(confirmation == OkCancelResult.ok){
                        permissionGranted = await location.requestPermission();

                        // context.showLoaderOverlay();
                        // Location.LocationData locationData = await location.getLocation();
                        // List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
                        // context.hideLoaderOverlay();

                        // Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPost(keyword: keyword, newToggle: 0, latitude: locationData.latitude!, longitude: locationData.longitude!, currentLocation: placemarks[0].name!,)));
                      }
                    }else{

                      if(profileImage == null){
                        final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                        final Uint8List list = bytes.buffer.asUint8List();

                        final tempDir = await getTemporaryDirectory();
                        final file = await new File('${tempDir.path}/blm-profile-image.png').create();
                        file.writeAsBytesSync(list);

                        setState(() {
                          profileImage = file;
                        });
                      }

                      Location.LocationData locationData = await location.getLocation();

                      // String blmMemorialName;
                      // String blmDescription;
                      // String blmLocationOfIncident;
                      // String blmDob;
                      // String blmRip;
                      // String blmState;
                      // String blmCountry;
                      // String blmPrecinct;
                      // String blmRelationship;
                      // dynamic blmBackgroundImage;
                      // dynamic blmProfileImage;
                      // List<dynamic> blmImagesOrVideos;
                      // String blmLatitude;
                      // String blmLongitude;


                      APIBLMCreateMemorial memorial = APIBLMCreateMemorial(
                        blmMemorialName: memorialName,
                        blmDescription: description,
                        blmLocationOfIncident: locationOfIncident,
                        blmDob: dob,
                        blmRip: rip,
                        blmState: state,
                        blmCountry: country,
                        blmPrecinct: precinct,
                        blmRelationship: relationship,
                        blmBackgroundImage: backgroundImage,
                        blmProfileImage: profileImage,
                        blmImagesOrVideos: imagesOrVideos,
                        blmLatitude: '${locationData.latitude}',
                        blmLongitude: '${locationData.longitude}',
                      );

                      // APIBLMCreateMemorial memorial = APIBLMCreateMemorial(
                      //   blmRelationship: newValue.relationship,
                      //   blmLocationOfIncident: newValue.location,
                      //   blmPrecinct: newValue.precinct,
                      //   blmDob: convertDate(newValue.dob),
                      //   blmRip: convertDate(newValue.rip),
                      //   blmCountry: newValue.country,
                      //   blmState: newValue.state,
                      //   blmMemorialName: newValue.blmName,
                      //   blmDescription: newValue.description,
                      //   blmBackgroundImage: backgroundImage,
                      //   blmProfileImage: profileImage,
                      //   blmImagesOrVideos: newValue.imagesOrVideos,
                      //   blmLatitude: locationData.latitude.toString(),
                      //   blmLongitude: locationData.longitude.toString()
                      // );

                      context.showLoaderOverlay();
                      int result = await apiBLMCreateMemorial(blmMemorial: memorial);
                      print('The result is $result');
                      context.hideLoaderOverlay();

                      Route newRoute = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: result, managed: true, newlyCreated: true, relationship: relationship,));
                      Navigator.pushReplacement(context, newRoute);
                      
                    }
                    
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}