import 'package:facesbyplaces/API/BLM/api-05-blm-create-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeBLMCreateMemorial extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBLMStoryType>(
          create: (context) => BlocHomeBLMStoryType(),
        ),
        BlocProvider<BlocHomeBLMBackgroundImage>(
          create: (context) => BlocHomeBLMBackgroundImage(),
        ),
        BlocProvider<BlocShowLoading>(
          create: (context) => BlocShowLoading(),
        ),
        BlocProvider<BlocBLMBLMCreateMemorial>(
          create: (context) => BlocBLMBLMCreateMemorial(),
        ),
      ],
      child: HomeBLMCreateMemorialExtended(),
    );
  }
}



class HomeBLMCreateMemorialExtended extends StatefulWidget{

  HomeBLMCreateMemorialExtendedState createState() => HomeBLMCreateMemorialExtendedState();
}

class HomeBLMCreateMemorialExtendedState extends State<HomeBLMCreateMemorialExtended>{

  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key5 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key9 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

  List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',];
  List<String> backgroundImages = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
  List<Widget> children;
  VideoPlayerController videoPlayerController;
  List<File> slideImages = [];

  void initState(){
    super.initState();
    children = [createMemorial1(), createMemorial2(), createMemorial3()];
  }
  
  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  File videoFile;
  File imageFile;
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

  // Future getSlideImage() async{
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if(pickedFile != null){
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //       // slideImages.add(imageFile);
  //     });
  //   }
  // }

  Future<File> getSlideImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return imageFile = File(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocBLMBLMCreateMemorial, int>(
      builder: (context, toggle){
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
                title: Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                centerTitle: true,
                backgroundColor: Color(0xff04ECFF),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    switch(toggle){
                      case 0: return Navigator.popUntil(context, ModalRoute.withName('/home/blm'),); break;
                      case 1: return context.bloc<BlocBLMBLMCreateMemorial>().modify(0); break;
                      case 2: return context.bloc<BlocBLMBLMCreateMemorial>().modify(1); break;
                    }
                  },
                ),
              ),
              body: IndexedStack(
                children: children,
                index: toggle,
              ),
            ),
          ),
        );
      },
    );
  }

  createMemorial1(){
    return Stack(
      children: [

        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
        ),

        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              MiscBLMInputFieldDropDown(key: _key1,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldDateTimeTemplate(key: _key4, labelText: 'DOB'),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldDateTimeTemplate(key: _key5, labelText: 'RIP'),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              MiscBLMButtonTemplate(
                onPressed: () async{

                  if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                  _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                  }else{
                    // Navigator.pushNamed(context, '/home/blm/home-07-02-blm-create-memorial');
                    context.bloc<BlocBLMBLMCreateMemorial>().modify(1);
                  }

                }, 
                width: SizeConfig.screenWidth / 2, 
                height: SizeConfig.blockSizeVertical * 7
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget createMemorial2(){
    return BlocBuilder<BlocHomeBLMStoryType, int>(
      builder: (context, storyType){
        return Stack(
          children: [

            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [

                  MiscBLMInputFieldTemplate(key: _key8, labelText: 'Name of your Memorial Page'),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Row(
                    children: [
                      Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                      Expanded(child: MiscBLMStoryType(),),
                    ],
                  ),

                  ((){
                    switch(storyType){
                      case 0: return MiscBLMInputFieldMultiTextTemplate(key: _key9,); break;
                      case 1: return GestureDetector(
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
                      ); break;
                      case 2: return Column(
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 32,
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
                                          // await getSlideImage();
                                          File newFile = await getSlideImage();

                                          setState(() {
                                            slideImages.add(newFile);
                                          });
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
                                      return Container(
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
                                      );
                                    }

                                    // if(index == images.length){
                                    //   return Container(
                                    //     width: SizeConfig.blockSizeVertical * 10,
                                    //     child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(10),
                                    //       color: Color(0xffcccccc),
                                    //       border: Border.all(color: Color(0xff000000),),
                                    //     ),
                                    //   );
                                    // }else{
                                    //   return Container(
                                    //     width: SizeConfig.blockSizeVertical * 10,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(10),
                                    //       color: Color(0xffcccccc),
                                    //       border: Border.all(color: Color(0xff000000),),
                                    //       image: DecorationImage(
                                    //         image: AssetImage(images[index]),
                                    //       ),
                                    //     ),
                                    //     child: Stack(
                                    //       children: [
                                    //         Center(
                                    //           child: CircleAvatar(
                                    //             radius: SizeConfig.blockSizeVertical * 3,
                                    //             backgroundColor: Color(0xffffffff).withOpacity(.5),
                                    //             child: Text(
                                    //               index.toString(),
                                    //               style: TextStyle(
                                    //                 fontSize: SizeConfig.safeBlockHorizontal * 7,
                                    //                 fontWeight: FontWeight.bold,
                                    //                 color: Color(0xffffffff),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   );
                                    // }
                                  }());
                                }),
                              ),
                            ),
                          ),
                          Text('Drag & drop to rearrange images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
                        ],
                      ); break;
                    }
                  }()),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  MiscBLMButtonTemplate(
                    onPressed: () async{
                      if(_key8.currentState.controller.text == ''){
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                      }else{
                        context.bloc<BlocBLMBLMCreateMemorial>().modify(2);
                      }
                    }, 
                    width: SizeConfig.screenWidth / 2, 
                    height: SizeConfig.blockSizeVertical * 7,
                  ),

                ],
              ),
            ),
          ],
        );
      },
    );
  }

  createMemorial3(){
    return BlocBuilder<BlocShowLoading, bool>(
      builder: (context, loading){
        return BlocBuilder<BlocHomeBLMBackgroundImage, int>( 
          builder: (context, backgroundImageToggle){
            return ((){
              switch(loading){
                case false: return Stack(
                  children: [

                    MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

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
                                image: AssetImage('assets/icons/upload_background.png'),
                              ),
                            ),
                            child: Stack(
                              children: [

                                Center(
                                  child: CircleAvatar(
                                    radius: SizeConfig.blockSizeVertical * 7,
                                    backgroundColor: Color(0xffffffff),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 7,
                                        backgroundImage: AssetImage('assets/icons/profile1.png'),
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
                                      onTap: (){
                                        context.bloc<BlocHomeBLMBackgroundImage>().updateToggle(index);
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
                                      onTap: (){
                                        context.bloc<BlocHomeBLMBackgroundImage>().updateToggle(index);
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

                          MiscBLMButtonTemplate(
                            onPressed: () async{

                              print('hehehehe');

                              APIBLMCreateMemorial memorial = APIBLMCreateMemorial(
                                relationship: _key1.currentState.currentSelection,
                                locationOfIncident: _key2.currentState.controller.text,
                                precinct: _key3.currentState.controller.text,
                                dob: convertDate(_key4.currentState.controller.text),
                                rip: convertDate(_key5.currentState.controller.text),
                                country: _key6.currentState.controller.text,
                                state: _key7.currentState.controller.text,
                                memorialName: _key8.currentState.controller.text,
                                description: _key9.currentState.controller.text,  
                              );

                              context.bloc<BlocShowLoading>().modify(true);
                              bool result = await apiBLMCreateMemorial(memorial);
                              context.bloc<BlocShowLoading>().modify(false);

                              if(result){
                                context.bloc<BlocBLMBLMCreateMemorial>().modify(0);
                                Navigator.pushReplacementNamed(context, '/home/blm/home-12-blm-profile');
                              }else{
                                await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                              }
                                
                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            height: SizeConfig.blockSizeVertical * 7,
                          ),

                        ],
                      ),
                    ),
                  ],
                ); break;
                case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),));
              }
            }());
          }
        );
      },
    );
  }
}
