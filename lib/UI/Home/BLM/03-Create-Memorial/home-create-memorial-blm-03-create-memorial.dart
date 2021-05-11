import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api-create-memorial-blm-01-create-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
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

  const HomeBLMCreateMemorial3({
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

  File backgroundImage = File('');
  File profileImage = File('');
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
        title: const Text('Cry out for the Victims', maxLines: 2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff))),
        centerTitle: true,
        backgroundColor: Color(0xff04ECFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [

          const MiscBLMBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [

                const SizedBox(height: 20,),

                const Text('Upload or Select an Image', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: const Color(0xff000000),),),

                const SizedBox(height: 20,),

                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: backgroundImage != File('')
                      ? AssetImage(backgroundImage.path)
                      : const AssetImage('assets/icons/alm-background1.png'),
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
                            backgroundColor: const Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: profileImage.path != ''
                              ? CircleAvatar(
                                radius: 60,
                                foregroundImage: FileImage(profileImage),
                                backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                              )
                              : const CircleAvatar(
                                radius: 60,
                                foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 40,
                        left: SizeConfig.screenWidth! / 2,
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xffffffff),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),
                          ),
                        ),
                      ),

                      const Positioned(
                        top: 10,
                        right: 10,
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xffffffff),
                          child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                const Text('Upload the best photo of the person in the memorial page.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),

                const SizedBox(height: 40,),

                const Text('Choose Background', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: const Color(0xff000000),),),

                const SizedBox(height: 20,),

                Container(
                  height: 100,
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
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
                              child: const Icon(Icons.add_rounded, color: const Color(0xff000000), size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffcccccc),
                                border: Border.all(color: const Color(0xff000000),),
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
                              padding: const EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xff04ECFF),
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
                              padding: const EdgeInsets.all(5),
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
                      return const SizedBox(width: 25);
                    },
                    itemCount: 5,
                  ),
                ),

                const SizedBox(height: 20,),

                const Text('Upload your own or select from the pre-mades.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),

                const SizedBox(height: 80,),

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
                      }
                    }else{

                      if(profileImage.path == ''){
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

                      context.loaderOverlay.show();
                      int result = await apiBLMCreateMemorial(blmMemorial: memorial);
                      print('The result is $result');
                      context.loaderOverlay.hide();

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