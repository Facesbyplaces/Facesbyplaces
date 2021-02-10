import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-01-create-memorial.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeRegularCreateMemorial2 extends StatefulWidget{

  HomeRegularCreateMemorial2State createState() => HomeRegularCreateMemorial2State();
}

class HomeRegularCreateMemorial2State extends State<HomeRegularCreateMemorial2>{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  TextEditingController controllerStory = TextEditingController();
  VideoPlayerController videoPlayerController;
  List<File> slideImages = [];
  int toggle = 0;
  File videoFile;
  File imageFile;
  File newFile;
  final picker = ImagePicker();

  Future getVideo() async{
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        videoFile = File(pickedFile.path);
        videoPlayerController = VideoPlayerController.file(videoFile)
        ..initialize().then((_){
          setState(() {
            videoPlayerController.play();
          });
        });
      });
    }
  }

  Future getSlideImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        slideImages.add(File(pickedFile.path));
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

          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [

                MiscRegularInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Row(
                  children: [
                    Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: TabBar(
                          isScrollable: false,
                          labelColor: Color(0xff04ECFF),
                          unselectedLabelColor: Color(0xff000000),
                          indicatorColor: Colors.transparent,
                          onTap: (int number){
                            setState(() {
                              toggle = number;
                            });
                          },
                          tabs: [

                            Center(
                              child: Text('Text',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Center(child: 
                              Text('Video',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Center(
                              child: Text('Slide',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Container(
                  child: ((){
                    switch(toggle){
                      case 0: return shareStory1(); break;
                      case 1: return shareStory2(); break;
                      case 2: return shareStory3(); break;
                    }
                  }()),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                MiscRegularButtonTemplate(
                  onPressed: () async{
                    if(_key1.currentState.controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Please complete the form before submitting.',
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
                    }else{
                      List<File> newFiles = [];

                      if(videoFile != null){
                        newFiles.add(videoFile);
                      }

                      if(slideImages != null){
                        newFiles.addAll(slideImages);
                      }

                      newValue.description = controllerStory.text;
                      newValue.memorialName = _key1.currentState.controller.text;
                      newValue.imagesOrVideos = newFiles;

                      Navigator.pushNamed(context, '/home/regular/create-memorial-3', arguments: newValue);
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

  shareStory1(){
    return TextFormField(
      controller: controllerStory,
      cursorColor: Color(0xff000000),
      maxLines: 10,
      keyboardType: TextInputType.text,
      readOnly: false,
      decoration: InputDecoration(
        fillColor: Color(0xffffffff),
        filled: true,
        alignLabelWithHint: true,
        labelText: '',
        labelStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  shareStory2(){
    return Container(
      width: SizeConfig.screenWidth,
      child: GestureDetector(
        onTap: () async{
          await getVideo();
        },
        child: Container(
          height: SizeConfig.blockSizeVertical * 34.5,
          decoration: BoxDecoration(
            color: Color(0xffcccccc),
            border: Border.all(color: Color(0xff000000),),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: videoFile == null 
          ? Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,)
          : GestureDetector(
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
        ),
      ),
    );
  }

  shareStory3(){
    return Column(
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 32,
          width: SizeConfig.screenWidth,
          child: Container(
            height: SizeConfig.blockSizeVertical * 12,
            child: GridView.count(
              physics: ClampingScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: List.generate(slideImages.length + 1, (index){
                return ((){
                  if(index == slideImages.length){
                    return GestureDetector(
                      onTap: () async{
                        await getSlideImage();
                      },
                      child: Container(
                        width: SizeConfig.blockSizeVertical * 10,
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
                      onDoubleTap: (){
                        setState(() {
                          slideImages.removeAt(index);
                        });
                      },
                      child: Container(
                        width: SizeConfig.blockSizeVertical * 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffcccccc),
                          border: Border.all(color: Color(0xff000000),),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(slideImages[index].path),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: SizeConfig.blockSizeVertical * 3,
                                backgroundColor: Color(0xffffffff).withOpacity(.5),
                                child: Text(
                                  index.toString(),
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 7,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }());
              }),
            ),
          ),
        ),

        Text('Double tap to remove images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
      ],
    );
  }
}

