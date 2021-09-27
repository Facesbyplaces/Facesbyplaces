import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api_create_memorial_blm_01_create_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:misc/misc.dart';
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
  const HomeBLMCreateMemorial3({Key? key, required this.relationship, required this.locationOfIncident, required this.precinct, required this.dob, required this.rip, required this.country, required this.latitude, required this.longitude,  required this.state, required this.description, required this.memorialName, required this.imagesOrVideos,}) : super(key: key);

  @override
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
      throw Exception('Error: $error');
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
      throw Exception('Error: $error');
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
              title: const Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const SizedBox(height: 20,),

                      const Text('Upload or Select an Image', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                      const SizedBox(height: 20,),

                      SizedBox(
                        width: SizeConfig.screenWidth,
                        height: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            backgroundImageListener.path != ''
                            ? ClipRRect(
                              child: Image.file(backgroundImageListener, fit: BoxFit.cover,),
                              borderRadius: BorderRadius.circular(10),
                            )
                            : Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/blm-memorial-cover-1.jpeg'),),
                                borderRadius: BorderRadius.circular(10),
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
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: FileImage(profileImageListener),
                                      backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                    )
                                    : const CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Color(0xff888888),
                                      foregroundImage: AssetImage('assets/icons/app-icon.png'),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async{
                                await getProfileImage();
                              },
                            ),

                            Positioned(
                              left: SizeConfig.screenWidth! / 2,
                              bottom: 40,
                              child: const CircleAvatar(
                                child: CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                                backgroundColor: Color(0xffffffff),
                                radius: 25,
                              ),
                            ),

                            const Positioned(
                              child: CircleAvatar(radius: 25, backgroundColor: Color(0xffffffff), child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                              right: 10,
                              top: 10,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20,),

                      const Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                      const SizedBox(height: 40,),

                      const Text('Choose Background', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                      const SizedBox(height: 20,),

                      SizedBox(
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
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                                    child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                                    height: 100,
                                    width: 100,
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
                                    final file = await File('${tempDir.path}/blm-background-image-$index.png').create();
                                    file.writeAsBytesSync(list);

                                    backgroundImageToggle.value = index;
                                    backgroundImage.value = file;
                                  },
                                  child: backgroundImageToggleListener == index
                                  ? Container(
                                    decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                                    padding: const EdgeInsets.all(5),
                                    height: 100,
                                    width: 100,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                      height: 100,
                                      width: 100,
                                    ),
                                  )
                                  : Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                    padding: const EdgeInsets.all(5),
                                    height: 100,
                                    width: 100,
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                );
                              }
                            }());
                          },
                        ),
                      ),

                      const SizedBox(height: 20,),

                      const Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                      const SizedBox(height: 80,),

                      MiscButtonTemplate(
                        buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                        buttonText: 'Create my Memorial Page',
                        width: 150,
                        height: 50,
                        onPressed: () async{
                          if(backgroundImageToggle.value == 0 || backgroundImageToggle.value == 1){
                            final ByteData bytes = await rootBundle.load(backgroundImages[backgroundImageToggle.value]);
                            final Uint8List list = bytes.buffer.asUint8List();

                            final tempDir = await getTemporaryDirectory();
                            final file = await File('${tempDir.path}/blm-background-image-$backgroundImageToggle.png').create();
                            file.writeAsBytesSync(list);

                            backgroundImage.value = file;
                          }

                          if(profileImage.value.path == ''){
                            final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                            final Uint8List list = bytes.buffer.asUint8List();

                            final tempDir = await getTemporaryDirectory();
                            final file = await File('${tempDir.path}/blm-profile-image.png').create();
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