

import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/API/Regular/api-09-regular-create-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';


// class HomeRegularCreatePost extends StatelessWidget{

class HomeRegularCreatePost extends StatefulWidget{

  @override
  HomeRegularCreatePostState createState() => HomeRegularCreatePostState();
}

class HomeRegularCreatePostState extends State<HomeRegularCreatePost>{

  final GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState>();
  final GlobalKey<MiscRegularInputFieldDropDownUserState> _key2 = GlobalKey<MiscRegularInputFieldDropDownUserState>();

  File imageFile;
  File videoFile;
  final picker = ImagePicker();
  VideoPlayerController videoPlayerController;
  String location = '';
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
    int memorialId = ModalRoute.of(context).settings.arguments;
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),)
          ],
          child: BlocBuilder<BlocShowLoading, bool>(
            builder: (context, loading){
              return ((){
                switch(loading){
                  case false: return Scaffold(
                    appBar: AppBar(
                      title: Text('Create Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
                      centerTitle: true,
                      backgroundColor: Color(0xff04ECFF),
                      leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                      actions: [
                        GestureDetector(
                          onTap: () async{

                            // print('The body is ${_key1.currentState.controller.text}');

                            File newFile;

                            if(imageFile != null){
                              newFile = imageFile;
                            }else if(videoFile != null){
                              newFile = videoFile;
                            }

                            APIRegularCreatePost post = APIRegularCreatePost(
                              pageType: 'Memorial',
                              postBody: _key1.currentState.controller.text,
                              location: location,
                              imagesOrVideos: newFile,
                              latitude: '0.2323232',
                              longitude: '0.2323232',
                              tagPeople: '1'
                            );
                            
                            context.bloc<BlocShowLoading>().modify(true);
                            bool result = await apiRegularHomeCreatePost(post, memorialId);
                            context.bloc<BlocShowLoading>().modify(false);

                            if(result){
                              Navigator.popAndPushNamed(context, '/home/regular');
                            }else{
                              await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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
                              child: MiscRegularInputFieldDropDownUser(key: _key2,),
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

                            // Expanded(child: Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),

                            Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscRegularInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),

                            // imageFile == null
                            // ? Container(height: 0,)
                            // : Container(height: SizeConfig.blockSizeVertical * 25, width: SizeConfig.screenWidth, padding: EdgeInsets.only(left: 20.0, right: 20.0,), child: Image.asset(imageFile.path, fit: BoxFit.cover),),

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                            Container(
                              child: Row(
                                children: [
                                  location != ''
                                  ? Text('at')
                                  : Text(''),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                  Text(location, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold),),

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
                                        var result = await Navigator.pushNamed(context, 'home/regular/home-09-02-regular-create-post');

                                        location = result.toString();
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
                                        
                                        var result = await Navigator.pushNamed(context, 'home/regular/home-09-03-regular-create-post');
                                        person = result.toString();
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

                                        var choice = await showDialog(context: (context), builder: (build) => MiscRegularUploadFromDialog(choice_1: 'Image', choice_2: 'Video',));

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
                  ); break;
                  case true: return Scaffold(body: Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)),); break;
                }
              }());
            }
          ),
        ),
      ),
    );
  }
}