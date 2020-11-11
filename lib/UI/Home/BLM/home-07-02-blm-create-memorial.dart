import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class HomeBLMCreateMemorial2 extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

  final List<String> images = [
    'assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 
    'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBLMStoryType>(
          create: (context) => BlocHomeBLMStoryType(),
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
            appBar: MiscBLMAppBarTemplate(appBar: AppBar(), leadingAction: (){Navigator.pop(context);},),
            body: Stack(
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

                      MiscBLMInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Row(
                        children: [
                          Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                          Expanded(child: MiscBLMStoryType(),),
                        ],
                      ),

                      BlocBuilder<BlocHomeBLMStoryType, int>(
                        builder: (context, state){
                          return ((){
                            switch(state){
                              case 0: return MiscBLMInputFieldMultiTextTemplate(key: _key2,); break;
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
                          }());
                        },
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                      MiscBLMButtonTemplate(
                        onPressed: () async{
                          if(_key1.currentState.controller.text == ''){
                            await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                          }else{
                            Navigator.pushNamed(context, '/home/blm/home-07-03-blm-create-memorial');
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
          ),
        ),
      ),
    );
  }
}