import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-03-create-memorial.dart';
import 'package:better_player/better_player.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
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

  const HomeRegularCreateMemorial2({required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country});

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
            title: const Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff))),
            centerTitle: true,
            backgroundColor: const Color(0xff04ECFF),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(height: SizeConfig.screenHeight, child: const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [

                    MiscRegularInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

                    const SizedBox(height: 40,),

                    Row(
                      children: [
                        const Text('Share your Story', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),

                        const SizedBox(height: 40,),

                        Expanded(
                          child: DefaultTabController(
                            length: 3,
                            child: TabBar(
                              isScrollable: false,
                              labelColor: const Color(0xff04ECFF),
                              unselectedLabelColor: const Color(0xff000000),
                              indicatorColor: Colors.transparent,
                              onTap: (int number){
                                setState(() {
                                  toggle = number;
                                });
                              },
                              tabs: [

                                const Center(
                                  child: const Text('Text',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                const Center(
                                  child: const Text('Video',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                const Center(
                                  child: const Text('Slide',
                                    style: const TextStyle(
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

                    const SizedBox(height: 20,),

                    Container(
                      child: ((){
                        switch(toggle){
                          case 0: return shareStory1();
                          case 1: return shareStory2();
                          case 2: return shareStory3();
                        }
                      }()),
                    ),

                    const SizedBox(height: 20,),

                    const Text('Describe the events that happened to your love one.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),

                    const SizedBox(height: 80,),

                    MiscRegularButtonTemplate(
                      width: 150,
                      height: 45,
                      onPressed: () async{
                        if(_key1.currentState!.controller.text == ''){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: const Text('Please complete the form before submitting.',
                                textAlign: TextAlign.center,
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
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
      cursorColor: const Color(0xff000000),
      maxLines: 10,
      keyboardType: TextInputType.text,
      readOnly: false,
      decoration: const InputDecoration(
        fillColor: const Color(0xffffffff),
        filled: true,
        alignLabelWithHint: true,
        labelText: '',
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xff888888)),
        border: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              betterPlayerConfiguration: const BetterPlayerConfiguration(
                controlsConfiguration: const BetterPlayerControlsConfiguration(
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
                icon: const CircleAvatar(
                  backgroundColor: const Color(0xff000000),
                  child: const Icon(Icons.close, color: const Color(0xffffffff),),
                ),
              ),
            ),
          ],
        )
        : Container(
          height: 260,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: const Color(0xffcccccc),
            border: Border.all(color: const Color(0xff000000),),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              physics: const ClampingScrollPhysics(),
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
                        child: const Icon(Icons.add_rounded, color: const Color(0xff000000), size: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffcccccc),
                          border: Border.all(color: const Color(0xff000000),),
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
                      onTap: (){
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Dialog',
                          transitionDuration: const Duration(milliseconds: 0),
                          pageBuilder: (_, __, ___) {
                            return Scaffold(
                              backgroundColor: Colors.black12.withOpacity(0.7),
                              body: SizedBox.expand(
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                            child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      Expanded(
                                        child: Image.asset(slideImages[index].path, fit: BoxFit.cover, scale: 1.0,),
                                      ),

                                      const SizedBox(height: 80,),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffcccccc),
                          border: Border.all(color: const Color(0xff000000),),
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
                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xffffffff),
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

        const SizedBox(height: 5,),

        Align(
          alignment: Alignment.centerLeft,
          child: const Text('Double tap to remove images.', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),
        ),
      ],
    );
  }
}