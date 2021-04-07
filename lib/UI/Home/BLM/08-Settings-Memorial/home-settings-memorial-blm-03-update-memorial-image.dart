import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-08-update-page-image.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-02-show-page-images.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeBLMMemorialPageImage extends StatefulWidget{

  final int memorialId;
  HomeBLMMemorialPageImage({required this.memorialId});

  HomeBLMMemorialPageImageState createState() => HomeBLMMemorialPageImageState(memorialId: memorialId);
}

class HomeBLMMemorialPageImageState extends State<HomeBLMMemorialPageImage>{

  final int memorialId;
  HomeBLMMemorialPageImageState({required this.memorialId});

  final List<String> backgroundImages = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
  int backgroundImageToggle  = 0;
  final picker = ImagePicker();
  File backgroundImage = File('');
  File profileImage = File('');
  Future<APIBLMShowPageImagesMain>? futureMemorialSettings;

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

  Future<APIBLMShowPageImagesMain> getMemorialSettings(int memorialId) async{
    return await apiBLMShowPageImages(memorialId: memorialId);
  }

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Memorial Settings', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<APIBLMShowPageImagesMain>(
        future: futureMemorialSettings,
        builder: (context, memorialImageSettings){
          if(memorialImageSettings.hasData){
            return Stack(
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
                            image: CachedNetworkImageProvider('${memorialImageSettings.data!.blmMemorial.showPageImagesBackgroundImage}')
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
                                  radius: 50,
                                  backgroundColor: Color(0xffffffff),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: profileImage.path != ''
                                    ? CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xff888888),
                                      backgroundImage: CachedNetworkImageProvider('${memorialImageSettings.data!.blmMemorial.showPageImagesProfileImage}'),
                                    )
                                    : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xff888888),
                                      backgroundImage: AssetImage('assets/icons/cover-icon.png'),
                                    )
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
                            return SizedBox(width: 25,);
                          },
                          itemCount: 5,
                        ),
                      ),

                      SizedBox(height: 20,),

                      Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Update', 
                        buttonTextStyle: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        onPressed: () async{

                          if(profileImage.path != '' || backgroundImage.path != ''){
                            context.showLoaderOverlay();
                            bool result = await apiBLMUpdatePageImages(memorialId: memorialId, backgroundImage: backgroundImage, profileImage: profileImage);
                            context.hideLoaderOverlay();

                            if(result){
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Successfully updated the memorial image.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                  onlyOkButton: true,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
                              );
                              Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, managed: true, newlyCreated: false, relationship: memorialImageSettings.data!.blmMemorial.showPageImagesRelationship,));
                              Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
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
                          }

                        }, 
                        width: 150,
                        height: 45,
                        buttonColor: Color(0xff04ECFF),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }else if(memorialImageSettings.hasError){
            return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        }
      ),
    );
  }
}

