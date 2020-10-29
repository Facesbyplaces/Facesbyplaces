import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiscBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeUpdateToggle, List<bool>>(
      builder: (context, state){
        return Container(
          height: SizeConfig.blockSizeVertical * 10,
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
                    Icon(MdiIcons.fire, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Feed', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.graveStone, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Memorials', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.post, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.heart, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Notification', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

            ],
            onPressed: (int index){
              context.bloc<BlocHomeUpdateToggle>().updateToggle(index);
              switch(index){
                case 0: context.bloc<BlocHomeUpdateCubit>().modify(0); break;
                case 1: context.bloc<BlocHomeUpdateCubit>().modify(1); break;
                case 2: context.bloc<BlocHomeUpdateCubit>().modify(2); break;
                case 3: context.bloc<BlocHomeUpdateCubit>().modify(3); break;
              }
            },
            isSelected: context.bloc<BlocHomeUpdateToggle>().state,
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

class MiscTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeUpdateToggleFeed, int>(
      builder: (context, state){
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8,
          color: Color(0xffffffff),
          child: DefaultTabController(
            length: 4,
            child: TabBar(
              isScrollable: true,
              labelColor: Color(0xff04ECFF),
              unselectedLabelColor: Color(0xff000000),
              indicatorColor: Color(0xff04ECFF),
              onTap: (int number){
                context.bloc<BlocHomeUpdateToggleFeed>().updateToggle(number);
              },
              tabs: [

                Center(
                  child: Text('Post',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(child: Text('Suggested',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(
                  child: Text('Nearby',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(
                  child: Text('BLM',
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
      },
    );
  }
}

class MiscMemorialSettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeUpdateMemorialToggle, int>(
      builder: (context, state){
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
                context.bloc<BlocHomeUpdateMemorialToggle>().updateToggle(number);
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
      },
    );
  }
}


class MiscMainAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget appBar;
  const MiscMainAppBar({this.appBar});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return appBar;
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

}

// class MiscAppBarTemplate extends StatelessWidget implements PreferredSizeWidget{

//   final AppBar appBar;
//   final Widget title;
//   final List<Widget> actions;
//   final Color color;
//   final Color backgroundColor;
//   final Widget leading;

//   const MiscAppBarTemplate({this.appBar, this.title, this.actions, this.backgroundColor, this.color, this.leading});

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return AppBar(
//       leading: Builder(
//         builder: (context) => leading,
//       ),
//       title: title,
//       actions: actions,
//       backgroundColor: backgroundColor,
//       centerTitle: true,
//     );
//   }

//   @override
//   Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
// }

class MiscJoinButton extends StatelessWidget{

  final int index;
  final int tab;

  MiscJoinButton({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        // context.bloc<BlocHomeUpdateCubit>().modify(3);
        Navigator.pushNamed(context, 'home/home-06-memorial');
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
                  bool value;

                  switch(tab){
                    case 0: value = context.bloc<BlocHomeUpdateListSuggested>().state[index]; break;
                    case 1: value = context.bloc<BlocHomeUpdateListNearby>().state[index]; break;
                    case 2: value = context.bloc<BlocHomeUpdateListBLM>().state[index]; break;
                  }

                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,

                    textColor: ((){
                      if(value == true){
                        return Color(0xffffffff);
                      }else{
                        return Color(0xff4EC9D4);
                      }
                    }()),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: (){
                      switch(tab){
                        case 0: context.bloc<BlocHomeUpdateListSuggested>().updateList(index); break;
                        case 1: context.bloc<BlocHomeUpdateListNearby>().updateList(index); break;
                        case 2: context.bloc<BlocHomeUpdateListBLM>().updateList(index); break;
                      }
                    },
                    child: ((){
                      if(value == true){
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
                        if(value == true){
                          return BorderSide(color: Color(0xff04ECFF));
                        }else{
                          return BorderSide(color: Color(0xff4EC9D4));
                        }
                      }())
                    ),
                    color: ((){
                      if(value == true){
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
}

class MiscManageButton extends StatelessWidget{

  final int index;
  final int tab;

  MiscManageButton({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
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
                  bool value;

                  // switch(tab){
                  //   case 0: value = context.bloc<BlocHomeUpdateListSuggested>().state[index]; break;
                  //   case 1: value = context.bloc<BlocHomeUpdateListNearby>().state[index]; break;
                  //   case 2: value = context.bloc<BlocHomeUpdateListBLM>().state[index]; break;
                  // }

                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,

                    textColor: ((){
                      if(value == true){
                        return Color(0xffffffff);
                      }else{
                        return Color(0xff4EC9D4);
                      }
                    }()),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: (){
                      // switch(tab){
                      //   case 0: context.bloc<BlocHomeUpdateListSuggested>().updateList(index); break;
                      //   case 1: context.bloc<BlocHomeUpdateListNearby>().updateList(index); break;
                      //   case 2: context.bloc<BlocHomeUpdateListBLM>().updateList(index); break;
                      // }
                    },
                    child: ((){
                      if(value == true){
                        return Text('Leave',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                          ),
                        );
                      }else{
                        return Text('Manage',
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
                        if(value == true){
                          return BorderSide(color: Color(0xff04ECFF));
                        }else{
                          return BorderSide(color: Color(0xff4EC9D4));
                        }
                      }())
                    ),
                    color: ((){
                      if(value == true){
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
}

class MiscUserProfileDraggableTabsList extends StatelessWidget{

  final int index;
  final int tab;

  MiscUserProfileDraggableTabsList({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
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
                  bool value;

                  // switch(tab){
                  //   case 0: value = context.bloc<BlocHomeUpdateListSuggested>().state[index]; break;
                  //   case 1: value = context.bloc<BlocHomeUpdateListNearby>().state[index]; break;
                  //   case 2: value = context.bloc<BlocHomeUpdateListBLM>().state[index]; break;
                  // }

                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,

                    textColor: ((){
                      if(value == true){
                        return Color(0xffffffff);
                      }else{
                        return Color(0xff4EC9D4);
                      }
                    }()),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: (){
                      // switch(tab){
                      //   case 0: context.bloc<BlocHomeUpdateListSuggested>().updateList(index); break;
                      //   case 1: context.bloc<BlocHomeUpdateListNearby>().updateList(index); break;
                      //   case 2: context.bloc<BlocHomeUpdateListBLM>().updateList(index); break;
                      // }
                    },
                    child: ((){
                      if(value == true){
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
                        if(value == true){
                          return BorderSide(color: Color(0xff04ECFF));
                        }else{
                          return BorderSide(color: Color(0xff4EC9D4));
                        }
                      }())
                    ),
                    color: ((){
                      if(value == true){
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
}

class MiscToggleSwitchTemplate extends StatefulWidget {

  @override
  MiscToggleSwitchTemplateState createState() => MiscToggleSwitchTemplateState();
}

class MiscToggleSwitchTemplateState extends State<MiscToggleSwitchTemplate> {
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



class MiscStoryType extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeStoryType, int>(
      builder: (context, state){
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
                print('The value of number is $number');
                context.bloc<BlocHomeStoryType>().updateToggle(number);
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
    );
  }
}