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
                print('The value of toggle is ${context.bloc<HomeUpdateToggleFeed>().state}');
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
      leading: Builder(builder: (context) => IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){},)),
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