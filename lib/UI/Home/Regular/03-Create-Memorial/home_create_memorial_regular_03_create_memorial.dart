import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/API/Regular/04-Create-Memorial/api_create_memorial_regular_01_create_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeRegularCreateMemorial3 extends StatefulWidget{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String latitude;
  final String longitude;
  final String description;
  final String memorialName;
  final List<dynamic> imagesOrVideos;
  const HomeRegularCreateMemorial3({Key? key, required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country, required this.latitude, required this.longitude, required this.description, required this.memorialName, required this.imagesOrVideos}) : super(key: key);

  @override
  HomeRegularCreateMemorial3State createState() => HomeRegularCreateMemorial3State();
}

class HomeRegularCreateMemorial3State extends State<HomeRegularCreateMemorial3>{
  List<String> backgroundImages = ['assets/icons/alm-memorial-cover-1.jpeg', 'assets/icons/alm-memorial-cover-2.jpeg'];
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
    }catch (error){
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
              title: const Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
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

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const SizedBox(height: 20,),
                      
                      const Text('Upload or Select an Image', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000))),

                      const SizedBox(height: 20,),

                      SizedBox(
                        height: 200,
                        width: SizeConfig.screenWidth,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            backgroundImageListener.path != ''
                            ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(backgroundImageListener, fit: BoxFit.cover,),)
                            : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/alm-memorial-cover-1.jpeg'),),
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 20,),

                      const Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                      const SizedBox(height: 40,),

                      const Text('Choose Background', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                      
                      const SizedBox(height: 20,),
                      
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index){
                            return const SizedBox(width: 25,);
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
                                  child: backgroundImageToggleListener == index
                                  ? Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                      height: 100,
                                      width: 100,
                                    ),
                                  )
                                  : Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  onTap: () async{
                                    final ByteData bytes = await rootBundle.load(backgroundImages[index]);
                                    final Uint8List list = bytes.buffer.asUint8List();

                                    final tempDir = await getTemporaryDirectory();
                                    final file = await File('${tempDir.path}/regular-background-image-$index.png').create();
                                    file.writeAsBytesSync(list);

                                    backgroundImageToggle.value = index;
                                    backgroundImage.value = file;
                                  },
                                );
                              }
                            }());
                          },
                        ),
                      ),

                      const SizedBox(height: 20,),

                      const Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

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
                            final file = await File('${tempDir.path}/regular-background-image-$backgroundImageToggle.png').create();
                            file.writeAsBytesSync(list);

                            backgroundImage.value = file;
                          }

                          if(profileImage.value.path == ''){
                            final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                            final Uint8List list = bytes.buffer.asUint8List();

                            final tempDir = await getTemporaryDirectory();
                            final file = await File('${tempDir.path}/regular-profile-image.png').create();
                            file.writeAsBytesSync(list);

                            profileImage.value = file;
                          }

                          APIRegularCreateMemorial memorial = APIRegularCreateMemorial(
                            almRelationship: widget.relationship,
                            almBirthPlace: widget.birthplace,
                            almDob: widget.dob,
                            almRip: widget.rip,
                            almCemetery: widget.cemetery,
                            almCountry: widget.country,
                            almMemorialName: widget.memorialName,
                            almDescription: widget.description,
                            almBackgroundImage: backgroundImage.value,
                            almProfileImage: profileImage.value,
                            almImagesOrVideos: widget.imagesOrVideos,
                            almLatitude: widget.latitude,
                            almLongitude: widget.longitude,
                          );

                          context.loaderOverlay.show(widget: const CustomLoaderTextLoader());
                          int result = await apiRegularCreateMemorial(memorial: memorial);
                          context.loaderOverlay.hide();

                          if(result != 0){
                            Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: result, managed: true, newlyCreated: true, relationship: widget.relationship,),);
                            Navigator.pushReplacement(context, newRoute); 
                          }else{
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Something went wrong. Please try again.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20,),
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