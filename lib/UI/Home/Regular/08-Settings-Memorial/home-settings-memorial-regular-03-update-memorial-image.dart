import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-07-show-images.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-08-update-images.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeRegularMemorialPageImage extends StatefulWidget{

  final int memorialId;
  HomeRegularMemorialPageImage({this.memorialId});

  HomeRegularMemorialPageImageState createState() => HomeRegularMemorialPageImageState(memorialId: memorialId);
}

class HomeRegularMemorialPageImageState extends State<HomeRegularMemorialPageImage>{

  final int memorialId;
  HomeRegularMemorialPageImageState({this.memorialId});

  final List<String> backgroundImages = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
  int backgroundImageToggle;
  final picker = ImagePicker();
  File backgroundImage;
  File profileImage;
  Future futureMemorialSettings;

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

  Future<APIRegularShowPageImagesMain> getMemorialSettings(int memorialId) async{
    return await apiRegularShowPageImages(memorialId);
  }

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
    backgroundImageToggle = 0;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: SizeConfig.screenHeight,
        child: FutureBuilder<APIRegularShowPageImagesMain>(
          future: futureMemorialSettings,
          builder: (context, memorialImageSettings){
            if(memorialImageSettings.hasData){
              return Stack(
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
                              : CachedNetworkImageProvider(
                                memorialImageSettings.data.backgroundImage.toString(),
                              ),
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
                                        backgroundColor: Color(0xff888888),
                                        backgroundImage: profileImage != null
                                        ? AssetImage(profileImage.path)
                                        : CachedNetworkImageProvider(
                                          memorialImageSettings.data.profileImage.toString()
                                        ),
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
                          buttonText: 'Update', 
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ),
                          onPressed: () async{

                            if(profileImage != null || backgroundImage != null){
                              context.showLoaderOverlay();
                              bool result = await apiRegularUpdatePageImages(memorialId, backgroundImage, profileImage);
                              context.hideLoaderOverlay();

                              if(result){

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),
                                );

                                Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                              }else{
                                await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                              }
                            }

                          }, 
                          width: SizeConfig.screenWidth / 2, 
                          height: SizeConfig.blockSizeVertical * 7, 
                          buttonColor: Color(0xff04ECFF),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }else if(memorialImageSettings.hasError){
              return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
            }else{
              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
            }
          }
        ),
      ),
    );
  }
}

