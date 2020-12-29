import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:facesbyplaces/Bloc/bloc-03-bloc-blm-misc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class MiscBLMBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return BlocBuilder<BlocHomeBLMUpdateToggle, List<bool>>(
      builder: (context, state){
        return Container(
          // height: SizeConfig.blockSizeVertical * 10,
          height: ScreenUtil().setHeight(65),
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          child: ToggleButtons(
            borderWidth: 0,
            renderBorder: false,
            selectedColor: Color(0xff04ECFF),
            fillColor: Colors.transparent,
            color: Color(0xffB1B1B1),
            children: [

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.fire, size: ScreenUtil().setHeight(25),),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Feed', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.graveStone, size: ScreenUtil().setHeight(25),),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Memorials', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.post, size: ScreenUtil().setHeight(25),),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Post', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.heart, size: ScreenUtil().setHeight(25),),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Notification', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                  ],
                ),
              ),

            ],
            onPressed: (int index){
              context.bloc<BlocHomeBLMUpdateToggle>().updateToggle(index);
              switch(index){
                case 0: context.bloc<BlocHomeBLMToggleBottom>().modify(0); break;
                case 1: context.bloc<BlocHomeBLMToggleBottom>().modify(1); break;
                case 2: context.bloc<BlocHomeBLMToggleBottom>().modify(2); break;
                case 3: context.bloc<BlocHomeBLMToggleBottom>().modify(3); break;
              }
            },
            isSelected: context.bloc<BlocHomeBLMUpdateToggle>().state,
          ),
          
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 0)
              ),
            ],
          ),
        );
      },
    );
  }
}

class MiscBLMUserProfileDraggableTabsList extends StatelessWidget{

  final int index;
  final int tab;

  MiscBLMUserProfileDraggableTabsList({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMJoinMemorialButton(),
      child: BlocBuilder<BlocMiscBLMJoinMemorialButton, bool>(
        builder: (context, joinButton){
          return GestureDetector(
            onTap: (){
              
            },
            child: Container(
              height: SizeConfig.blockSizeVertical * 15,
              color: Color(0xffffffff),
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      maxRadius: SizeConfig.blockSizeVertical * 5,
                      backgroundImage: AssetImage('assets/icons/profile1.png'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Memorial',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Memorial',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3,
                                fontWeight: FontWeight.w200,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: ((){
                        return MaterialButton(
                          elevation: 0,
                          padding: EdgeInsets.zero,

                          textColor: ((){
                            if(joinButton == true){
                              return Color(0xffffffff);
                            }else{
                              return Color(0xff4EC9D4);
                            }
                          }()),
                          splashColor: Color(0xff4EC9D4),
                          onPressed: (){
                            context.bloc<BlocMiscBLMJoinMemorialButton>().modify(!joinButton);
                          },
                          child: ((){
                            if(joinButton == true){
                              return Text('Leave',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                ),
                              );
                            }else{
                              return Text('Join',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                ),
                              );
                            }
                          }()),
                          height: SizeConfig.blockSizeVertical * 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            side: ((){
                              if(joinButton == true){
                                return BorderSide(color: Color(0xff04ECFF));
                              }else{
                                return BorderSide(color: Color(0xff4EC9D4));
                              }
                            }())
                          ),
                          color: ((){
                            if(joinButton == true){
                              return Color(0xff04ECFF);
                            }else{
                              return Color(0xffffffff);
                            }
                          }()),
                        );  

                      }()),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class MiscBLMToggleSwitchTemplate extends StatefulWidget {

  @override
  MiscBLMToggleSwitchTemplateState createState() => MiscBLMToggleSwitchTemplateState();
}

class MiscBLMToggleSwitchTemplateState extends State<MiscBLMToggleSwitchTemplate> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Switch(
        value: isSwitched,
        onChanged: (value){
          setState(() {
            isSwitched = value;
          });
        },
        activeColor: Color(0xff2F353D),
        activeTrackColor: Color(0xff3498DB),
      ),
    );
  }
}
