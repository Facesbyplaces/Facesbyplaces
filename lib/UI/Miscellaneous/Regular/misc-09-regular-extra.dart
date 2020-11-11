import 'package:facesbyplaces/Bloc/bloc-05-bloc-regular-misc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class MiscRegularStoryType extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.blockSizeVertical * 8,
      child: DefaultTabController(
        length: 3,
        child: TabBar(
          isScrollable: false,
          labelColor: Color(0xff04ECFF),
          unselectedLabelColor: Color(0xff000000),
          indicatorColor: Colors.transparent,
          onTap: (int number){
            context.bloc<BlocHomeRegularStoryType>().updateToggle(number);
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
    );
  }
}

class MiscRegularMemorialSettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      alignment: Alignment.centerLeft,
      width: SizeConfig.screenWidth,
      height: SizeConfig.blockSizeVertical * 8,

      child: DefaultTabController(
        length: 2,
        child: TabBar(
          isScrollable: true,
          labelColor: Color(0xff04ECFF),
          unselectedLabelColor: Color(0xff000000),
          indicatorColor: Color(0xff04ECFF),
          onTap: (int number){
            context.bloc<BlocHomeRegularUpdateMemorialToggle>().updateToggle(number);
          },
          tabs: [

            Center(
              child: Text('Page',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Center(child: Text('Privacy',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class MiscRegularToggleSwitchTemplate extends StatefulWidget {

  @override
  MiscRegularToggleSwitchTemplateState createState() => MiscRegularToggleSwitchTemplateState();
}

class MiscRegularToggleSwitchTemplateState extends State<MiscRegularToggleSwitchTemplate> {
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


class MiscRegularUserProfileDraggableTabsList extends StatelessWidget{

  final int index;
  final int tab;

  MiscRegularUserProfileDraggableTabsList({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscRegularJoinMemorialButton(),
      child: BlocBuilder<BlocMiscRegularJoinMemorialButton, bool>(
        builder: (context, joinButton){
          return GestureDetector(
            onTap: (){},
            child: Container(
              height: SizeConfig.blockSizeVertical * 15,
              color: Color(0xffffffff),
              child: Row(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      maxRadius: SizeConfig.blockSizeVertical * 5,
                      backgroundImage: AssetImage('assets/icons/profile2.png'),
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
                        // bool value;
                        
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
                            context.bloc<BlocMiscRegularJoinMemorialButton>().modify(!joinButton);
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
        },
      ),
    );
    // return 
  }
}
