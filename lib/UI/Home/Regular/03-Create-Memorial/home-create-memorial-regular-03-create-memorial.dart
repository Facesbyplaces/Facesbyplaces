import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/04-Create-Memorial/api-create-memorial-regular-01-create-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
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

class HomeRegularCreateMemorial3 extends StatefulWidget{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;

  HomeRegularCreateMemorial3({required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country, required this.description, required this.memorialName, required this.imagesOrVideos});

  HomeRegularCreateMemorial3State createState() => HomeRegularCreateMemorial3State(relationship: relationship, birthplace: birthplace, dob: dob, rip: rip, cemetery: cemetery, country: country, description: description, memorialName: memorialName, imagesOrVideos: imagesOrVideos);
}

class HomeRegularCreateMemorial3State extends State<HomeRegularCreateMemorial3>{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;

  HomeRegularCreateMemorial3State({required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country, required this.description, required this.memorialName, required this.imagesOrVideos});

  File backgroundImage = File('');
  File profileImage = File('');
  final picker = ImagePicker();
  List<String> backgroundImages = ['assets/icons/alm-background1.png', 'assets/icons/alm-background3.png', 'assets/icons/alm-background4.png', 'assets/icons/alm-background5.png'];
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
        title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
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

          MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

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
                      image: backgroundImage != File('')
                      ? AssetImage(backgroundImage.path)
                      : AssetImage('assets/icons/alm-background1.png'),
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
                              child: profileImage.path != ''
                              ? CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(profileImage),
                              )
                              : CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage('assets/icons/cover-icon.png'),
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
                              final file = await new File('${tempDir.path}/regular-background-image-$index.png').create();
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
                      return SizedBox(width: 25,);
                    },
                    itemCount: 5,
                  ),
                ),

                SizedBox(height: 20,),

                Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: 80,),

                MiscRegularButtonTemplate(
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
                      }
                    }else{
                      if(profileImage.path == ''){
                        final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                        final Uint8List list = bytes.buffer.asUint8List();

                        final tempDir = await getTemporaryDirectory();
                        final file = await new File('${tempDir.path}/regular-profile-image.png').create();
                        file.writeAsBytesSync(list);

                        setState(() {
                          profileImage = file;
                        });
                      }

                      Location.LocationData locationData = await location.getLocation();

                      APIRegularCreateMemorial memorial = APIRegularCreateMemorial(
                        almRelationship: relationship,
                        almBirthPlace: birthplace,
                        almDob: dob,
                        almRip: rip,
                        almCemetery: cemetery,
                        almCountry: country,
                        almMemorialName: memorialName,
                        almDescription: description,
                        almBackgroundImage: backgroundImage,
                        almProfileImage: profileImage,
                        almImagesOrVideos: imagesOrVideos,
                        almLatitude: '${locationData.latitude}',
                        almLongitude: '${locationData.longitude}',
                      );

                      context.loaderOverlay.show();
                      int result = await apiRegularCreateMemorial(memorial: memorial);
                      context.loaderOverlay.hide();

                      Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: result, managed: true, newlyCreated: true, relationship: relationship,));
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




