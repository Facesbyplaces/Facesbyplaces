import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_create_memorial_blm_03_create_memorial.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
import 'dart:io';

class HomeBLMCreateMemorial2 extends StatefulWidget{
  final String relationship;
  final String locationOfIncident;
  final String rip;
  final String country;
  final String state;
  final String latitude;
  final String longitude;
  const HomeBLMCreateMemorial2({Key? key, required this.relationship, required this.locationOfIncident, required this.rip, required this.country, required this.state, required this.latitude, required this.longitude}) : super(key: key);

  @override
  HomeBLMCreateMemorial2State createState() => HomeBLMCreateMemorial2State();
}

class HomeBLMCreateMemorial2State extends State<HomeBLMCreateMemorial2>{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  TextEditingController controllerStory = TextEditingController(text: '');
  ValueNotifier<List<XFile>> slideImages = ValueNotifier<List<XFile>>([]);
  ValueNotifier<File> videoFile = ValueNotifier<File>(File(''));
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future getVideo() async{
    try{
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        videoFile.value = File(pickedFile.path);
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getSlideImage() async{
    try{
      final pickedFile = await picker.pickMultiImage().then((picture){
        return picture;
      });

      if(pickedFile != null){
        slideImages.value.addAll(pickedFile);
        slideCount.value += pickedFile.length;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context){
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
        child: ValueListenableBuilder(
          valueListenable: toggle,
          builder: (_, int toggleListener, __) => Scaffold(
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
                SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        MiscInputFieldTemplate(
                          key: _key1, 
                          labelText: 'Name of your Memorial Page',
                        ),

                        const SizedBox(height: 40,),

                        Row(
                          children: [
                            const Text('Share your Story', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                            Expanded(
                              child: DefaultTabController(
                                length: 3,
                                child: TabBar(
                                  indicator: const BoxDecoration(border: Border(left: BorderSide(width: 1, color: Color(0xff000000)), right: BorderSide(width: 1, color: Color(0xff000000),),),),
                                  unselectedLabelColor: const Color(0xff000000),
                                  labelColor: const Color(0xff04ECFF),
                                  indicatorColor: Colors.transparent,
                                  isScrollable: false,
                                  tabs: const [
                                    Center(child: Text('Text', style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular',),),),

                                    Center(child: Text('Video', style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular',),),),

                                    Center(child: Text('Slide', style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular',),),),
                                  ],
                                  onTap: (int number){
                                    toggle.value = number;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20,),

                        SizedBox(
                          child: ((){
                            switch (toggleListener){
                              case 0: return shareStory1();
                              case 1: return shareStory2();
                              case 2: return shareStory3();
                            }
                          }()),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        const Text('Describe the events that happened to your love one.', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
                        
                        const SizedBox(height: 80,),
                        
                        MiscButtonTemplate(
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
                          width: 150,
                          height: 50,
                          onPressed: () async{
                            if(!(_formKey.currentState!.validate())){
                              await showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: 'Error',
                                  description: 'Please complete the form before submitting.',
                                  okButtonColor: const Color(0xfff44336), // RED
                                  includeOkButton: true,
                                ),
                              );
                            }else{
                              List<dynamic> newFiles = [];

                              if(videoFile.value.path != ''){
                                newFiles.add(videoFile.value);
                              }

                              if(slideImages.value != []){
                                newFiles.addAll(slideImages.value);
                              }

                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreateMemorial3(relationship: widget.relationship, locationOfIncident: widget.locationOfIncident, rip: widget.rip, country: widget.country, state: widget.state, latitude: widget.latitude, longitude: widget.longitude,  description: controllerStory.text, memorialName: _key1.currentState!.controller.text, imagesOrVideos: newFiles,),),);
                            }
                          },
                        ),

                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  shareStory1(){
    return TextFormField(
      controller: controllerStory,
      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
      keyboardType: TextInputType.text,
      cursorColor: const Color(0xff000000),
      readOnly: false,
      maxLines: 10,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
        fillColor: Color(0xffffffff),
        alignLabelWithHint: true,
        labelText: '',
        filled: true,
      ),
    );
  }

  shareStory2(){
    return ValueListenableBuilder(
      valueListenable: videoFile,
      builder: (_, File videoFileListener, __) => SizedBox(
        width: SizeConfig.screenWidth,
        child: GestureDetector(
          onTap: () async{
            await getVideo();
          },
          child: videoFileListener.path != ''
          ? Stack(
            children: [
              GestureDetector(
                onTap: (){
                  showGeneralDialog(
                    context: context,
                    barrierLabel: 'Dialog',
                    barrierDismissible: true,
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
                                    child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                Expanded(
                                  child: BetterPlayer.file(
                                    videoFileListener.path,
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                      aspectRatio: 16 / 9,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 85,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: BetterPlayer.file(videoFileListener.path,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const CircleAvatar(backgroundColor: Color(0xff000000), child: Icon(Icons.close, color: Color(0xffffffff),),),
                  iconSize: 25,
                  onPressed: (){
                    videoFile.value = File('');
                  },
                ),
              ),
            ],
          )
          : Container(
            decoration: BoxDecoration(color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),), borderRadius: const BorderRadius.all(Radius.circular(10)),),
            child: const Icon(Icons.file_upload, color: Color(0xff888888), size: 100,),
            width: SizeConfig.screenWidth,
            height: 260,
          ),
        ),
      ),
    );
  }

  shareStory3(){
    return ValueListenableBuilder(
      valueListenable: slideImages,
      builder: (_, List<XFile> slideImagesListener, __) => ValueListenableBuilder(
        valueListenable: slideCount,
        builder: (_, int slideCountListener, __) => Column(
          children: [
            SizedBox(
              width: SizeConfig.screenWidth,
              height: 260,
              child: SizedBox(
                height: 100,
                child: GridView.count(
                  physics: const ClampingScrollPhysics(),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 4,
                  children: List.generate(slideCountListener + 1, (index){
                    return ((){
                      if(index == slideCountListener){
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                            child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                            width: 80,
                          ),
                          onTap: () async{
                            await getSlideImage();
                          },
                        );
                      }else{
                        return GestureDetector(
                          child: SizedBox(
                            width: 80,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  // child: Image.file(slideImagesListener[index], fit: BoxFit.cover,),
                                  child: Image.file(File(slideImagesListener[index].path), fit: BoxFit.cover,),
                                ),

                                Stack(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 25, 
                                        backgroundColor: const Color(0xffffffff).withOpacity(.5), 
                                        child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onDoubleTap: (){
                            slideImages.value.removeAt(index);
                            slideCount.value--;
                          },
                          onTap: (){
                            showGeneralDialog(
                              context: context,
                              barrierLabel: 'Dialog',
                              barrierDismissible: true,
                              transitionDuration: const Duration(milliseconds: 0),
                              pageBuilder: (_, __, ___){
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
                                              child: CircleAvatar(
                                                child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                radius: 20,
                                              ),
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 20,),
                                          
                                          Expanded(child: Image.file(File(slideImagesListener[index].path), fit: BoxFit.contain,),),

                                          const SizedBox(height: 80,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    }());
                  }),
                ),
              ),
            ),

            const SizedBox(height: 5,),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Double tap to remove images.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
            ),
          ],
        ),
      ),
    );
  }
}