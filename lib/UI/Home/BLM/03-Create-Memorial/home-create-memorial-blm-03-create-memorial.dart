import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api-create-memorial-blm-01-create-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
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
  final String latitude;
  final String longitude;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;
  const HomeBLMCreateMemorial3({required this.relationship, required this.locationOfIncident, required this.precinct, required this.dob, required this.rip, required this.country, required this.latitude, required this.longitude,  required this.state, required this.description, required this.memorialName, required this.imagesOrVideos,});

  HomeBLMCreateMemorial3State createState() => HomeBLMCreateMemorial3State();
}

class HomeBLMCreateMemorial3State extends State<HomeBLMCreateMemorial3>{
  List<String> backgroundImages = ['assets/icons/blm-memorial-cover-1.jpeg', 'assets/icons/blm-memorial-cover-2.jpeg'];
  ValueNotifier<File> backgroundImage = ValueNotifier<File>(File(''));
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  ValueNotifier<int> backgroundImageToggle = ValueNotifier<int>(0);
  final picker = ImagePicker();

  Future getProfileImage() async{
    try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        profileImage.value = File(pickedFile.path);
      }
    }catch (error){
      print('Error: ${error.toString()}');
    }
  }

  Future getBackgroundImage() async{
    try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        backgroundImage.value = File(pickedFile.path);
      }
    }catch(error){
      print('Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: backgroundImage,
      builder: (_, File backgroundImageListener, __) => ValueListenableBuilder(
        valueListenable: profileImage,
        builder: (_, File profileImageListener, __) => ValueListenableBuilder(
          valueListenable: backgroundImageToggle,
          builder: (_, int backgroundImageToggleListener, __) => Scaffold(
            appBar: AppBar(
              title: Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
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

                      Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                      const SizedBox(height: 20,),

                      Container(
                        height: 200,
                        width: SizeConfig.screenWidth,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            backgroundImageListener.path != ''
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(backgroundImageListener, fit: BoxFit.cover,),
                            )
                            : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(fit: BoxFit.cover, image: const AssetImage('assets/icons/blm-memorial-cover-1.jpeg'),),
                              ),
                            ),

                            GestureDetector(
                              child: Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: const Color(0xffffffff),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: profileImageListener.path != ''
                                    ? CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Color(0xff888888),
                                      foregroundImage: FileImage(profileImageListener),
                                      backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                    )
                                    : const CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Color(0xff888888),
                                      foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async{
                                await getProfileImage();
                              },
                            ),

                            Positioned(
                              bottom: 40,
                              left: SizeConfig.screenWidth! / 2,
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: const Color(0xffffffff),
                                child: const CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),),
                              ),
                            ),

                            const Positioned(
                              top: 10,
                              right: 10,
                              child: const CircleAvatar(radius: 25, backgroundColor: const Color(0xffffffff), child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),

                      const SizedBox(height: 40,),

                      Text('Choose Background', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                      const SizedBox(height: 20,),

                      Container(
                        height: 100,
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index){
                            return const SizedBox(width: 25);
                          },
                          itemCount: 3,
                          itemBuilder: (context, index){
                            return ((){
                              if(index == 2){
                                return GestureDetector(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: const Icon(Icons.add_rounded, color: const Color(0xff000000), size: 60,),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                                  ),
                                  onTap: () async{
                                    backgroundImageToggle.value = index;
                                    await getBackgroundImage();
                                  },
                                );
                              }else{
                                return GestureDetector(
                                  onTap: () async{
                                    final ByteData bytes = await rootBundle.load(backgroundImages[index]);
                                    final Uint8List list = bytes.buffer.asUint8List();

                                    final tempDir = await getTemporaryDirectory();
                                    final file = await new File('${tempDir.path}/blm-background-image-$index.png').create();
                                    file.writeAsBytesSync(list);

                                    backgroundImageToggle.value = index;
                                    backgroundImage.value = file;
                                  },
                                  child: backgroundImageToggleListener == index
                                  ? Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                    ),
                                  )
                                  : Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                    ),
                                  ),
                                );
                              }
                            }());
                          },
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),

                      const SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffFFFFFF),),
                        buttonText: 'Create my Memorial Page',
                        width: 150,
                        height: 45,
                        onPressed: () async{
                          if(backgroundImageToggle.value == 0 || backgroundImageToggle.value == 1){
                            final ByteData bytes = await rootBundle.load(backgroundImages[backgroundImageToggle.value]);
                            final Uint8List list = bytes.buffer.asUint8List();

                            final tempDir = await getTemporaryDirectory();
                            final file = await new File('${tempDir.path}/blm-background-image-$backgroundImageToggle.png').create();
                            file.writeAsBytesSync(list);

                            backgroundImage.value = file;
                          }

                          if(profileImage.value.path == ''){
                            final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                            final Uint8List list = bytes.buffer.asUint8List();

                            final tempDir = await getTemporaryDirectory();
                            final file = await new File('${tempDir.path}/blm-profile-image.png').create();
                            file.writeAsBytesSync(list);

                            profileImage.value = file;
                          }

                          APIBLMCreateMemorial memorial = APIBLMCreateMemorial(
                            blmMemorialName: widget.memorialName,
                            blmDescription: widget.description,
                            blmLocationOfIncident: widget.locationOfIncident,
                            blmDob: widget.dob,
                            blmRip: widget.rip,
                            blmState: widget.state,
                            blmCountry: widget.country,
                            blmPrecinct: widget.precinct,
                            blmRelationship: widget.relationship,
                            blmBackgroundImage: backgroundImage.value,
                            blmProfileImage: profileImage.value,
                            blmImagesOrVideos: widget.imagesOrVideos,
                            blmLatitude: widget.latitude,
                            blmLongitude: widget.longitude,
                          );

                          context.loaderOverlay.show();
                          int result = await apiBLMCreateMemorial(blmMemorial: memorial);
                          context.loaderOverlay.hide();

                          Route newRoute = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: result, managed: true, newlyCreated: true, relationship: widget.relationship,),);
                          Navigator.pushReplacement(context, newRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}