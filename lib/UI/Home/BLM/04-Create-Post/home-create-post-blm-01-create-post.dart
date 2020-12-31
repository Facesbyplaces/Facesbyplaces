import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-01-create-post.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMRelationshipItem{

  final String name;
  final String image;
  
  const BLMRelationshipItem({this.name, this.image});
}

class HomeBLMCreatePost extends StatefulWidget{

  @override
  HomeBLMCreatePostState createState() => HomeBLMCreatePostState();
}

class HomeBLMCreatePostState extends State<HomeBLMCreatePost>{

  final GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState>();

  File imageFile;
  File videoFile;
  final picker = ImagePicker();
  VideoPlayerController videoPlayerController;
  String newLocation;
  String person;

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        imageFile = File(pickedFile.path);
        videoFile = null;
      });
    }
  }

  Future getVideo() async{
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        videoFile = File(pickedFile.path);
        imageFile = null;
        videoPlayerController = VideoPlayerController.file(videoFile)
        ..initialize().then((_){
          setState(() {
            videoPlayerController.play();
          });
        });
      });
    }
  }

  List<BLMRelationshipItem> relationship = [
    const BLMRelationshipItem(name: 'Richard Nedd Memories', image: 'assets/icons/profile2.png'),
    const BLMRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png'),
  ];

  BLMRelationshipItem currentSelection = const BLMRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png');

  void initState(){
    super.initState();
    newLocation = '';
    person = '';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    BLMRelationshipItemPost newValue = ModalRoute.of(context).settings.arguments;
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
          appBar: AppBar(
            title: Text('Create Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            backgroundColor: Color(0xff04ECFF),
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            actions: [
              GestureDetector(
                onTap: () async{

                  File newFile;

                  if(imageFile != null){
                    newFile = imageFile;
                  }else if(videoFile != null){
                    newFile = videoFile;
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

                  APIBLMCreatePost post = APIBLMCreatePost(
                    pageType: 'Blm',
                    postBody: _key1.currentState.controller.text,
                    location: newLocation,
                    imagesOrVideos: newFile,
                    latitude: locationData.latitude.toString(),
                    longitude: locationData.longitude.toString(),
                    // tagPeople: '1'
                  );

                    context.showLoaderOverlay();
                    bool result = await apiBLMHomeCreatePost(post, newValue.memorialId);
                    context.hideLoaderOverlay();

                  if(result){
                    Navigator.popAndPushNamed(context, '/home/blm');
                  }else{
                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                  }
                }, 
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0), 
                  child: Center(
                    child: Text('Post', 
                    style: TextStyle(
                      color: Color(0xffffffff), 
                      fontSize: SizeConfig.safeBlockHorizontal * 5,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: SizeConfig.screenHeight - kToolbarHeight,
              child: Column(
                children: [

                  InputDecorator(
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<BLMRelationshipItem>(
                        value: currentSelection,
                        isDense: true,
                        onChanged: (BLMRelationshipItem newValue) {
                          setState(() {
                            currentSelection = newValue;
                          });
                        },
                        items: relationship.map((BLMRelationshipItem value) {
                          return DropdownMenuItem<BLMRelationshipItem>(
                            value: value,
                            child: Row(
                              children: [
                                CircleAvatar(backgroundImage: AssetImage(value.image),),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                Text(value.name),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscBLMInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),

                  Container(
                    child: ((){
                      if(imageFile != null){
                        return Container(height: SizeConfig.blockSizeVertical * 25, width: SizeConfig.screenWidth, padding: EdgeInsets.only(left: 20.0, right: 20.0,), child: Image.asset(imageFile.path, fit: BoxFit.cover),);
                      }else if(videoFile != null){
                        return Container(
                          height: SizeConfig.blockSizeVertical * 25, 
                          width: SizeConfig.screenWidth, 
                          padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
                          child: GestureDetector(
                            onTap: (){
                              if(videoPlayerController.value.isPlaying){
                                videoPlayerController.pause();
                              }else{
                                videoPlayerController.play();
                              }
                              
                            },
                            onDoubleTap: () async{
                              await getVideo();
                            },
                            child: AspectRatio(
                              aspectRatio: videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController),
                            ),
                          ),
                        );
                      }
                    }()),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Container(
                    child: Row(
                      children: [
                        newLocation != ''
                        ? Text('at')
                        : Text(''),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text(newLocation, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        person != ''
                        ? Text('with')
                        : Text(''),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text(person, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold),),
                      ],
                    ), 
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
                    alignment: Alignment.centerLeft,
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                    height: SizeConfig.blockSizeVertical * 20,
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              var result = await Navigator.pushNamed(context, '/home/blm/home-19-02-blm-create-post');

                              setState(() {});

                              if(result == null){
                                newLocation = '';
                              }else{
                                newLocation = result.toString();
                              }

                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Add a location'),),
                                  Icon(Icons.place, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              
                              var result = await Navigator.pushNamed(context, '/home/blm/home-19-03-blm-create-post');

                              setState(() {});

                              if(result == null){
                                person = '';
                              }else{
                                person = result.toString();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Tag a person you are with'),),
                                  Icon(Icons.person, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async{

                              var choice = await showDialog(context: (context), builder: (build) => MiscBLMUploadFromDialog(choice_1: 'Image', choice_2: 'Video',));

                              if(choice == null){
                                choice = 0;
                              }else{
                                if(choice == 1){
                                  await getImage();
                                }else{
                                  await getVideo();
                                }
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Upload a Video / Image'),),
                                  Icon(Icons.image, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

