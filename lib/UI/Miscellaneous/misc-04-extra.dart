import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'misc-03-icons.dart';

class MiscBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<HomeUpdateToggle, List<bool>>(
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

              MiscIconToggle(icon: MdiIcons.fire, text: 'Feed',),

              MiscIconToggle(icon: MdiIcons.graveStone, text: 'Memorials',),

              MiscIconToggle(icon: MdiIcons.post, text: 'Post',),

              MiscIconToggle(icon: MdiIcons.heart, text: 'Notification',),

            ],
            onPressed: (int index){
              context.bloc<HomeUpdateToggle>().updateToggle(index);

              switch(index){
                case 0: context.bloc<HomeUpdateCubit>().modify(0); break;
                case 1: context.bloc<HomeUpdateCubit>().modify(10); break;
                case 2: context.bloc<HomeUpdateCubit>().modify(2); break;
                case 3: context.bloc<HomeUpdateCubit>().modify(11); break;
              }

            },
            isSelected: context.bloc<HomeUpdateToggle>().state,
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
    return BlocBuilder<HomeUpdateToggleFeed, int>(
      builder: (context, state){
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8,

          child: DefaultTabController(
            length: 4,
            child: TabBar(
              isScrollable: true,
              labelColor: Color(0xff04ECFF),
              unselectedLabelColor: Color(0xff000000),
              indicatorColor: Color(0xff04ECFF),
              onTap: (int number){
                context.bloc<HomeUpdateToggleFeed>().updateToggle(number);
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
    return BlocBuilder<HomeUpdateMemorialToggle, int>(
      builder: (context, state){
        return Container(
          // alignment: Alignment.center,
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
                context.bloc<HomeUpdateMemorialToggle>().updateToggle(number);
                print('The value is ${context.bloc<HomeUpdateMemorialToggle>().state}');
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

class MiscAppBar1 extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;

  const MiscAppBar1({this.appBar});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AppBar(
      leading: Builder(builder: (context) => IconButton(icon: Image.asset('assets/icons/profile1.png'), onPressed: (){},)),
      title: Text('FacesByPlaces.com',
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: Color(0xffffffff),
        ),
      ),
      backgroundColor: Color(0xff4EC9D4),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), onPressed: (){
          context.bloc<HomeUpdateCubit>().modify(1);
        },)
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class MiscAppBar2 extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;

  const MiscAppBar2({this.appBar});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            context.bloc<HomeUpdateCubit>().modify(0);
          },
        ),
      ),
      title: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          filled: true,
          fillColor: Color(0xffffffff),
          focusColor: Color(0xffffffff),
          hintText: 'Search a Post',
          hintStyle: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffffffff)),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffffffff)),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffffffff)),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
      backgroundColor: Color(0xff04ECFF),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class MiscAppBar3 extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;
  // final int position;
  final Widget leading;

  // const MiscAppBar3({this.appBar, this.position});
  const MiscAppBar3({this.appBar, this.leading});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AppBar(
      // leading: Builder(
      //   builder: (context) => IconButton(
      //     icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
      //     onPressed: () {
      //       context.bloc<HomeUpdateCubit>().modify(position);
      //     },
      //   ),
      // ),
      leading: Builder(
        builder: (context) => leading,
      ),
      title: Text('Cry out for the Victims',
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 5,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      ),
      backgroundColor: Color(0xff04ECFF),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class MiscAppBarTemplate extends StatelessWidget implements PreferredSizeWidget{

  final AppBar appBar;
  final int position;
  final String title;
  final List<Widget> actions;
  final Color color;
  final Color backgroundColor;

  const MiscAppBarTemplate({this.appBar, this.position, this.title, this.actions, this.backgroundColor, this.color});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: color,), 
          onPressed: (){
            context.bloc<HomeUpdateCubit>().modify(position);
            context.bloc<HomeUpdateMemorialToggle>().updateToggle(0);
            context.bloc<HomeUpdateToggle>().reset();
          },
        ),
      ),
      title: Text(title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      actions: actions,
      backgroundColor: backgroundColor,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class MiscJoinButton extends StatelessWidget{

  final int index;
  final int tab;

  MiscJoinButton({this.index, this.tab});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        // print('lkjasdfoiuweqroiu');
        context.bloc<HomeUpdateCubit>().modify(3);
        // context.bloc<HomeUpdateMemorial>().modify(0);
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
                    case 0: value = context.bloc<HomeUpdateListSuggested>().state[index]; break;
                    case 1: value = context.bloc<HomeUpdateListNearby>().state[index]; break;
                    case 2: value = context.bloc<HomeUpdateListBLM>().state[index]; break;
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
                          case 0: context.bloc<HomeUpdateListSuggested>().updateList(index); break;
                          case 1: context.bloc<HomeUpdateListNearby>().updateList(index); break;
                          case 2: context.bloc<HomeUpdateListBLM>().updateList(index); break;
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
      onTap: (){
        // print('lkjasdfoiuweqroiu');
        // context.bloc<HomeUpdateCubit>().modify(3);
        // context.bloc<HomeUpdateMemorial>().modify(0);
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
                    case 0: value = context.bloc<HomeUpdateListSuggested>().state[index]; break;
                    case 1: value = context.bloc<HomeUpdateListNearby>().state[index]; break;
                    case 2: value = context.bloc<HomeUpdateListBLM>().state[index]; break;
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
                          case 0: context.bloc<HomeUpdateListSuggested>().updateList(index); break;
                          case 1: context.bloc<HomeUpdateListNearby>().updateList(index); break;
                          case 2: context.bloc<HomeUpdateListBLM>().updateList(index); break;
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

class MiscToggleSwitch extends StatefulWidget {

  @override
  _MiscToggleSwitchState createState() => _MiscToggleSwitchState();
}

class _MiscToggleSwitchState extends State<MiscToggleSwitch> {
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
            print('isSwitched is $isSwitched');
          });
        },
        activeColor: Color(0xff2F353D),
        activeTrackColor: Color(0xff3498DB),
      ),
    );
  }
}