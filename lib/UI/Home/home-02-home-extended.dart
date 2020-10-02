import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/home-03-feed.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-03-icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreenExtended extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
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
          IconButton(icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), onPressed: (){},)
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/icons/background2.png'),
            colorFilter: ColorFilter.srgbToLinearGamma(),
          ),
        ),

        child: BlocBuilder<HomeUpdateCubit, int>(
          builder: (context, state){
            return ((){
              switch(state){
                case 0: return HomeFeed(); break;
                default: return HomeFeed(); break;
              }
            }());
          },
        ),
      ),

      bottomSheet: BlocBuilder<HomeUpdateToggle, List<bool>>(
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
      ),

    );
  }
}