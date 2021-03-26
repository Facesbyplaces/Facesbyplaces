import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-03-create-memorial.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeRegularCreateMemorial2 extends StatefulWidget{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;

  HomeRegularCreateMemorial2({required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country});

  HomeRegularCreateMemorial2State createState() => HomeRegularCreateMemorial2State(relationship: relationship, birthplace: birthplace, dob: dob, rip: rip, cemetery: cemetery, country: country);
}

class HomeRegularCreateMemorial2State extends State<HomeRegularCreateMemorial2>{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;

  HomeRegularCreateMemorial2State({required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  TextEditingController controllerStory = TextEditingController();
  List<File> slideImages = [];
  int toggle = 0;
  File videoFile = File('');
  File imageFile = File('');
  File newFile = File('');
  final picker = ImagePicker();

  Future getVideo() async{
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        videoFile = File(pickedFile.path);
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
            title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
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

                    SizedBox(height: 40,),

                    Row(
                      children: [
                        Text('Share your Story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                        SizedBox(height: 40,),

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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                Center(child: 
                                  Text('Video',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Text('Slide',
                                    style: TextStyle(
                                      fontSize: 14,
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

                    SizedBox(height: 20,),

                    Container(
                      child: ((){
                        switch(toggle){
                          case 0: return shareStory1();
                          case 1: return shareStory2();
                          case 2: return shareStory3();
                        }
                      }()),
                    ),

                    SizedBox(height: 20,),

                    Text('Describe the events that happened to your love one.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                    SizedBox(height: 80,),

                    MiscRegularButtonTemplate(
                      width: 150,
                      height: 45,
                      onPressed: () async{
                        if(_key1.currentState!.controller.text == ''){
                          await showOkAlertDialog(
                            context: context,
                            title: 'Error',
                            message: 'Please complete the form before submitting.',
                          );
                        }else{
                          List<File> newFiles = [];

                          if(videoFile.path != ''){
                            newFiles.add(videoFile);
                          }

                          if(slideImages != []){
                            newFiles.addAll(slideImages);
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              HomeRegularCreateMemorial3(
                                relationship: relationship,
                                birthplace: birthplace,
                                dob: dob,
                                rip: rip,
                                cemetery: cemetery,
                                country: country,
                                description: controllerStory.text,
                                memorialName: _key1.currentState!.controller.text,
                                imagesOrVideos: newFiles,
                              ),
                            )
                          );
                        }
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
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
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
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
        child: videoFile.path != ''
        ? Stack(
          children: [
            BetterPlayer.file(
              videoFile.path,
              betterPlayerConfiguration: BetterPlayerConfiguration(
                controlsConfiguration: BetterPlayerControlsConfiguration(
                  enableOverflowMenu: false,
                  enableMute: false,
                ),
                aspectRatio: 16 / 9,
              ),
            ),

            Positioned(
              right: 0,
              child: IconButton(
                iconSize: 25,
                onPressed: (){
                  setState(() {
                    videoFile = File('');  
                  });
                },
                icon: CircleAvatar(
                  backgroundColor: Color(0xff000000),
                  child: Icon(Icons.close, color: Color(0xffffffff),),
                ),
              ),
            ),
          ],
        )
        : Container(
          height: 260,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: Color(0xffcccccc),
            border: Border.all(color: Color(0xff000000),),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }

  shareStory3(){
    return Column(
      children: [
        Container(
          height: 260,
          width: SizeConfig.screenWidth,
          child: Container(
            height: 100,
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
                        width: 80,
                        child: Icon(Icons.add_rounded, color: Color(0xff000000), size: 60),
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
                        width: 80,
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
                                radius: 25,
                                backgroundColor: Color(0xffffffff).withOpacity(.5),
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                    fontSize: 40,
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

        SizedBox(height: 5,),

        Align(
          alignment: Alignment.centerLeft,
          child: Text('Double tap to remove images.',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),
        ),
      ],
    );
  }
}

