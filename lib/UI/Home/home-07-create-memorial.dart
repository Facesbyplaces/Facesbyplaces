import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-12-appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCreateMemorial extends StatelessWidget{

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key3 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key4 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key7 = GlobalKey<MiscInputFieldTemplateState>();

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
          appBar: MiscAppBarTemplate(appBar: AppBar(), leadingAction: (){Navigator.pop(context);},),
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(height: SizeConfig.screenHeight, child: MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MiscInputFieldTemplate(key: _key1, labelText: 'Relationship'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key4, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key5, labelText: 'RIP'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key6, labelText: 'Country'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key7, labelText: 'State'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                    MiscButtonTemplate(
                      onPressed: () async{

                        if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                        _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
                          await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                        }else{
                          Navigator.pushNamed(context, 'home/home-07-02-create-memorial');
                        }

                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: SizeConfig.blockSizeVertical * 8
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
}

class HomeCreateMemorial2 extends StatelessWidget{

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscInputFieldMultiTextTemplateState>();

  final List<String> images = [
    'assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 
    'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeStoryType>(
          create: (context) => BlocHomeStoryType(),
        ),
      ],
      child: WillPopScope(
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
            appBar: MiscAppBarTemplate(appBar: AppBar(), leadingAction: (){Navigator.pop(context);},),
            body: Stack(
              children: [

                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(height: SizeConfig.screenHeight, child: MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [

                      MiscInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Row(
                        children: [
                          Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                          Expanded(child: MiscStoryType(),),
                        ],
                      ),

                      BlocBuilder<BlocHomeStoryType, int>(
                        builder: (context, state){
                          return ((){
                            switch(state){
                              case 0: return MiscInputFieldMultiTextTemplate(key: _key2,); break;
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
                          }());
                        },
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                      MiscButtonTemplate(
                        onPressed: () async{
                          if(_key1.currentState.controller.text == ''){
                            await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                          }else{
                            Navigator.pushNamed(context, 'home/home-07-03-create-memorial');
                          }
                        }, 
                        width: SizeConfig.screenWidth / 2, 
                        height: SizeConfig.blockSizeVertical * 8,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCreateMemorial3 extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: MiscAppBarTemplate(appBar: AppBar(), leadingAction: (){Navigator.pop(context);},),
      body: Stack(
        children: [

          MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              shrinkWrap: true,
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
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 13,
                            child: Image.asset('assets/icons/profile1.png'),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: SizeConfig.blockSizeVertical * 5,
                        left: SizeConfig.screenWidth / 2,
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 3,
                          backgroundColor: Color(0xffffffff),
                          child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5,),
                        ),
                      ),

                      Positioned(
                        top: SizeConfig.blockSizeVertical * 1,
                        right: SizeConfig.blockSizeVertical * 1,
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 3,
                          backgroundColor: Color(0xffffffff),
                          child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5,),
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
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return Container(
                        width: SizeConfig.blockSizeVertical * 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                          ),
                        ),
                      );
                    }, 
                    separatorBuilder: (context, index){
                      return SizedBox(width: SizeConfig.blockSizeHorizontal * 5,);
                    },
                    itemCount: 4,
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                MiscButtonTemplate(onPressed: (){Navigator.pushNamed(context, 'home/home-08-profile');}, width: SizeConfig.screenWidth / 2, height: SizeConfig.blockSizeVertical * 8),

              ],
            ),
          ),
        ],
      ),
    );
  }
}