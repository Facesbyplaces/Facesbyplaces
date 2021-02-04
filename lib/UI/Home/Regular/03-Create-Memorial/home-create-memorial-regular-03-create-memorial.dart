import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/04-Create-Memorial/api-create-memorial-regular-01-create-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'home-create-memorial-regular-01-create-memorial.dart';
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

  HomeRegularCreateMemorial3State createState() => HomeRegularCreateMemorial3State();
}

class HomeRegularCreateMemorial3State extends State<HomeRegularCreateMemorial3>{

  File backgroundImage;
  File profileImage;
  final picker = ImagePicker();
  List<String> backgroundImages = ['assets/icons/alm-background1.png', 'assets/icons/alm-background3.png', 'assets/icons/alm-background4.png', 'assets/icons/alm-background5.png'];
  int backgroundImageToggle;

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
    RegularCreateMemorialValues newValue = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
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

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Container(
                  height: SizeConfig.blockSizeVertical * 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: backgroundImage != null
                      ? AssetImage(backgroundImage.path)
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
                            radius: SizeConfig.blockSizeVertical * 7,
                            backgroundColor: Color(0xffffffff),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: SizeConfig.blockSizeVertical * 7,
                                backgroundImage: profileImage != null
                                ? FileImage(profileImage)
                                : AssetImage('assets/icons/cover-icon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: SizeConfig.blockSizeVertical * 5,
                        left: SizeConfig.screenWidth / 2,
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 3,
                          backgroundColor: Color(0xffffffff),
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * 3,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
                          ),
                        ),
                      ),

                      Positioned(
                        top: SizeConfig.blockSizeVertical * 1,
                        right: SizeConfig.blockSizeVertical * 1,
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 3,
                          backgroundColor: Color(0xffffffff),
                          child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Text('Choose Background', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Container(
                  height: SizeConfig.blockSizeVertical * 12,
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
                              width: SizeConfig.blockSizeVertical * 12,
                              height: SizeConfig.blockSizeVertical * 12,    
                              child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
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
                              width: SizeConfig.blockSizeVertical * 12,
                              height: SizeConfig.blockSizeVertical * 12,
                              decoration: BoxDecoration(
                                color: Color(0xff04ECFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: SizeConfig.blockSizeVertical * 10,
                                height: SizeConfig.blockSizeVertical * 10,
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
                              width: SizeConfig.blockSizeVertical * 12,
                              height: SizeConfig.blockSizeVertical * 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: SizeConfig.blockSizeVertical * 10,
                                height: SizeConfig.blockSizeVertical * 10,
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
                      return SizedBox(width: SizeConfig.blockSizeHorizontal * 3,);
                    },
                    itemCount: 5,
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                MiscRegularButtonTemplate(
                  onPressed: () async{

                    if(profileImage == null){
                      final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                      final Uint8List list = bytes.buffer.asUint8List();

                      final tempDir = await getTemporaryDirectory();
                      final file = await new File('${tempDir.path}/regular-profile-image.png').create();
                      file.writeAsBytesSync(list);

                      setState(() {
                        profileImage = file;
                      });
                    }

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

                    Location.LocationData locationData = await location.getLocation();

                    APIRegularCreateMemorial memorial = APIRegularCreateMemorial(
                      almRelationship: newValue.relationship,
                      almBirthPlace: newValue.birthplace,
                      almDob: convertDate(newValue.dob),
                      almRip: convertDate(newValue.rip),
                      almCemetery: newValue.cemetery,
                      almCountry: newValue.country,
                      almMemorialName: newValue.memorialName,
                      almDescription: newValue.description,
                      almBackgroundImage: backgroundImage,
                      almProfileImage: profileImage,
                      almImagesOrVideos: newValue.imagesOrVideos,
                      almLatitude: locationData.latitude.toString(),
                      almLongitude: locationData.longitude.toString()
                    );

                    context.showLoaderOverlay();
                    int result = await apiRegularCreateMemorial(memorial: memorial);
                    context.hideLoaderOverlay();

                    if(result != 0){
                      Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: result,));
                      Navigator.pushReplacement(context, newRoute);
                    }else{
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Something went wrong. Please try again.',
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
                      
                  }, 
                  width: SizeConfig.screenWidth / 2, 
                  height: SizeConfig.blockSizeVertical * 7,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}




