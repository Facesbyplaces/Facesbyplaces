import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-01-create-post.dart';
import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-02-list-of-managed-pages.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as Location;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMTaggedUsers{
  String name;
  int userId;

  BLMTaggedUsers({this.name, this.userId,});
}

class BLMManagedPages{
  String name;
  int pageId;

  BLMManagedPages({this.name, this.pageId});
}

class HomeBLMCreatePost extends StatefulWidget{
  final String name;
  final int memorialId;
  HomeBLMCreatePost({this.name, this.memorialId});

  @override
  HomeBLMCreatePostState createState() => HomeBLMCreatePostState(name: name, memorialId: memorialId);
}

class HomeBLMCreatePostState extends State<HomeBLMCreatePost>{
  final String name;
  final int memorialId;
  HomeBLMCreatePostState({this.name, this.memorialId});

  final GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState>();

  List<BLMManagedPages> managedPages;
  String currentSelection;
  int currentIdSelected;
  Future listManagedPages;
  List<BLMTaggedUsers> users = [];

  void initState(){
    super.initState();
    managedPages = [];
    currentSelection = name;
    currentIdSelected = memorialId;
    getManagedPages();
  }

  void getManagedPages() async{
    context.showLoaderOverlay();
    var newValue = await apiBLMShowListOfManagedPages();
    context.hideLoaderOverlay();

    for(int i = 0; i < newValue.pagesList.length; i++){
      managedPages.add(BLMManagedPages(name: newValue.pagesList[i].name, pageId: newValue.pagesList[i].id));
    }
    setState(() {});
  }

  File imageFile;
  File videoFile;
  final picker = ImagePicker();
  VideoPlayerController videoPlayerController;
  String newLocation = '';
  String person = '';

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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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

                  context.showLoaderOverlay();

                  Location.LocationData locationData = await location.getLocation();

                  List<int> userIds = [];

                  if(users.length != 0){
                    for(int i = 0; i < users.length; i++){
                      userIds.add(users[i].userId);
                    }
                  }

                  print('The new user id is $userIds');

                  APIBLMCreatePost post = APIBLMCreatePost(
                    pageType: 'Blm',
                    postBody: _key1.currentState.controller.text,
                    pageId: currentIdSelected,
                    location: newLocation,
                    imagesOrVideos: newFile,
                    latitude: locationData.latitude,
                    longitude: locationData.longitude,
                    tagPeople: userIds,
                  );

                  
                  bool result = await apiBLMHomeCreatePost(post);
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

                  Container(
                    child: InputDecorator(
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
                        child: DropdownButton<int>(
                          value: currentIdSelected,
                          isDense: true,
                          onChanged: (int newValue) {
                            setState(() {
                              currentIdSelected = newValue;
                              print('The currentId selected is $currentIdSelected');
                            });
                          },
                          items: managedPages.map((BLMManagedPages value) {
                            return DropdownMenuItem<int>(
                              value: value.pageId,
                              
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundImage: AssetImage('assets/icons/app-icon.png'), backgroundColor: Color(0xff888888)),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text(value.name),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 0)
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscBLMInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Container(
                    child: Wrap(
                      spacing: 5.0,
                      children: List.generate(
                        users.length, 
                        (index) => Chip(
                          labelPadding: const EdgeInsets.only(left: 8.0),
                          label: Text(users[index].name),
                          deleteIcon: Icon(
                            Icons.close,
                            size: 18,
                          ),
                          onDeleted: () {
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
                    alignment: Alignment.centerLeft,
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

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

                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                    height: SizeConfig.blockSizeVertical * 20,
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              var result = await Navigator.pushNamed(context, '/home/blm/create-post-location');

                              newLocation = result.toString();
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
                              
                              var result = await Navigator.pushNamed(context, '/home/blm/create-post-user');

                              if(result != null){
                                users.add(result);
                              }

                              setState(() {});
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