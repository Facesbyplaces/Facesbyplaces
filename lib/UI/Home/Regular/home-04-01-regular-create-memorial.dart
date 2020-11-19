import 'package:facesbyplaces/API/Regular/api-06-regular-create-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularCreateMemorial extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularCreateMemorial>(
          create: (BuildContext context) => BlocHomeRegularCreateMemorial(),
        ),
        BlocProvider<BlocHomeRegularStoryType>(
          create: (BuildContext context) => BlocHomeRegularStoryType(),
        ),
        BlocProvider<BlocHomeRegularBackgroundImage>(
          create: (context) => BlocHomeRegularBackgroundImage(),
        ),
        BlocProvider<BlocShowLoading>(
          create: (context) => BlocShowLoading(),
        ),
      ],
      child: HomeRegularCreateMemorialExtended()
    );
  }
}


class HomeRegularCreateMemorialExtended extends StatefulWidget{

  HomeRegularCreateMemorialExtendedState createState() => HomeRegularCreateMemorialExtendedState();
}

class HomeRegularCreateMemorialExtendedState extends State<HomeRegularCreateMemorialExtended>{

  GlobalKey<MiscRegularInputFieldDropDownState> _key1 = GlobalKey<MiscRegularInputFieldDropDownState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key3 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key7 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldMultiTextTemplateState> _key8 = GlobalKey<MiscRegularInputFieldMultiTextTemplateState>();

  List<Widget> children;

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',];

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

  @override
  Widget build(BuildContext context){
    return BlocBuilder<BlocHomeRegularCreateMemorial, int>(
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
                title: Text('Create a Memorial Page for friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                centerTitle: true,
                backgroundColor: Color(0xff04ECFF),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    switch(toggle){
                      case 0: return Navigator.popUntil(context, ModalRoute.withName('/home/regular')); break;
                      case 1: return context.bloc<BlocHomeRegularCreateMemorial>().modify(0); break;
                      case 2: return context.bloc<BlocHomeRegularCreateMemorial>().modify(1); break;
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
      }
    );
  }

  createMemorial1(){
    return Stack(
      children: [

        SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: SizeConfig.screenHeight,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: [

                MiscRegularInputFieldDropDown(key: _key1,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldDateTimeTemplate(key: _key3, labelText: 'DOB'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldDateTimeTemplate(key: _key4, labelText: 'RIP'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Expanded(child: Container(),),

                MiscRegularButtonTemplate(
                  onPressed: () async{

                    // print('The dob is ${_key3.currentState.controller.text}');
                    // print('The converted date is ${convertDate(_key3.currentState.controller.text)}');

                    if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                    _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                    }else{
                      context.bloc<BlocHomeRegularCreateMemorial>().modify(1);
                    }

                  }, 
                  width: SizeConfig.screenWidth, 
                  height: SizeConfig.blockSizeVertical * 7
                ),

                Expanded(child: Container(),),

              ],
            ),
          ),
        ),

      ],
    );
  }

  createMemorial2(){
    return BlocBuilder<BlocHomeRegularStoryType, int>(
      builder: (context, storyType){
        return Stack(
          children: [

            SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [

                  MiscRegularInputFieldTemplate(key: _key7, labelText: 'Name of your Memorial Page'),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Row(
                    children: [
                      Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                      Expanded(child: MiscRegularStoryType(),),
                    ],
                  ),

                  ((){
                    switch(storyType){
                      case 0: return MiscRegularInputFieldMultiTextTemplate(key: _key8,); break;
                      case 1: return Container(
                        height: SizeConfig.blockSizeVertical * 34.5,
                        child: Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,),
                        decoration: BoxDecoration(
                          color: Color(0xffcccccc),
                          border: Border.all(color: Color(0xff000000),),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ); break;
                      case 2: return Column(
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 32,
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 12,
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                children: List.generate(7, (index){
                                  return ((){
                                    if(index == images.length){
                                      return Container(
                                        width: SizeConfig.blockSizeVertical * 10,
                                        child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xffcccccc),
                                          border: Border.all(color: Color(0xff000000),),
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
                                            image: AssetImage(images[index]),
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

                  MiscRegularButtonTemplate(
                    buttonColor: Color(0xff04ECFF),
                    onPressed: () async{
                      if(_key7.currentState.controller.text == ''){
                        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                      }else{
                        context.bloc<BlocHomeRegularCreateMemorial>().modify(2);
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
        return ((){
          switch(loading){
            case false: return Stack(
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

                      BlocBuilder<BlocHomeRegularBackgroundImage, int>(
                        builder: (context, chooseBackgroundImage){
                          return Container(
                            height: SizeConfig.blockSizeVertical * 12,
                            child: ListView.separated(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return ((){
                                  if(index == 4){
                                    return GestureDetector(
                                      onTap: (){
                                        context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
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
                                        context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
                                      },
                                      child: chooseBackgroundImage == index
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
                                              image: AssetImage(images[index]),
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
                                              image: AssetImage(images[index]),
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
                          );
                        }
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                      MiscRegularButtonTemplate(
                        onPressed: () async{

                          APIRegularCreateMemorial newMemorial = APIRegularCreateMemorial(
                            memorialName: _key7.currentState.controller.text,
                            birthPlace: _key2.currentState.controller.text,
                            dob: convertDate(_key3.currentState.controller.text),
                            rip: convertDate(_key4.currentState.controller.text),
                            cemetery: _key5.currentState.controller.text,
                            country: _key6.currentState.controller.text,
                            description: _key8.currentState.controller.text,
                            relationship: _key1.currentState.currentSelection,
                          );

                          context.bloc<BlocShowLoading>().modify(true);
                          bool result = await apiRegularCreateMemorial(newMemorial);
                          context.bloc<BlocShowLoading>().modify(false);

                          if(result){
                            context.bloc<BlocHomeRegularCreateMemorial>().modify(0);
                            Navigator.pushReplacementNamed(context, '/home/regular/home-08-regular-memorial-profile');
                          }else{
                            await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                          }
                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: SizeConfig.blockSizeVertical * 7),

                    ],
                  ),
                ),
              ],
            ); break;
            case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),));
          }
        }());
      },
    );
  }
  
}


  // @override
  // Widget build(BuildContext context) {
  //   SizeConfig.init(context);
  //   return Stack(
  //     children: [

  //       SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

  //       SingleChildScrollView(
  //         physics: ClampingScrollPhysics(),
  //         child: Container(
  //           height: SizeConfig.screenHeight,
  //           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  //           child: Column(
  //             children: [

  //               MiscRegularInputFieldDropDown(key: _key1,),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 2,),

  //               MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 2,),

  //               MiscRegularInputFieldTemplate(key: _key3, labelText: 'DOB'),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 2,),

  //               MiscRegularInputFieldTemplate(key: _key4, labelText: 'RIP'),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 2,),

  //               MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 2,),

  //               MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

  //               SizedBox(height: SizeConfig.blockSizeVertical * 5,),

  //               Expanded(child: Container(),),

  //               MiscRegularButtonTemplate(
  //                 onPressed: () async{

  //                   if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
  //                   _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
  //                     await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
  //                   }else{
  //                     // Navigator.pushNamed(context, '/home/regular/home-04-02-regular-create-memorial');
  //                     context.bloc<BlocHomeRegularCreateMemorial>().modify(1);
  //                   }

  //                 }, 
  //                 width: SizeConfig.screenWidth, 
  //                 height: SizeConfig.blockSizeVertical * 7
  //               ),

  //               Expanded(child: Container(),),

  //             ],
  //           ),
  //         ),
  //       ),

  //     ],
  //   );
  // }