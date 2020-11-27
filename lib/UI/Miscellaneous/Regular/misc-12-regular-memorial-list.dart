import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularManageMemoriaWithButton extends StatelessWidget{

  final int index;
  final int tab;
  final String iconImage;
  final String title;
  final String content;
  final String frontTextButton;
  final String backTextButton;
  final Color frontTextColorButton;
  final Color backTextColorButton;
  final int memorialId;

  MiscRegularManageMemoriaWithButton({
    this.index, 
    this.tab,
    this.iconImage = 'assets/icons/profile1.png',
    this.title = 'Memorial',
    this.content = 'Memorial content',
    this.frontTextButton = 'Leave', 
    this.backTextButton = 'Join',
    this.frontTextColorButton = const Color(0xffffffff),
    this.backTextColorButton = const Color(0xff4EC9D4),
    this.memorialId,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{
        final sharedPrefs = await SharedPreferences.getInstance();
        sharedPrefs.setInt('regular-user-memorial-id', memorialId);

        Navigator.pushNamed(context, 'home/regular/home-13-regular-memorial');
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 15,
        color: Color(0xffffffff),
        child: Row(
          children: [
            Expanded(
              child: CircleAvatar(
                maxRadius: SizeConfig.blockSizeVertical * 5,
                backgroundImage: AssetImage(iconImage),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(title,
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
                      child: Text(content,
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
                    case 1: value = context.bloc<BlocHomeRegularUpdateListSuggested>().state[index]; break;
                    case 2: value = context.bloc<BlocHomeRegularUpdateListNearby>().state[index]; break;
                    case 3: value = context.bloc<BlocHomeRegularUpdateListBLM>().state[index]; break;
                  }
                  
                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,

                    textColor: ((){
                      if(value == true){
                        return frontTextColorButton;
                      }else{
                        return backTextColorButton;
                      }
                    }()),
                    splashColor: backTextColorButton,
                    onPressed: (){
                      switch(tab){
                        case 1: context.bloc<BlocHomeRegularUpdateListSuggested>().updateList(index); break;
                        case 2: context.bloc<BlocHomeRegularUpdateListNearby>().updateList(index); break;
                        case 3: context.bloc<BlocHomeRegularUpdateListBLM>().updateList(index); break;
                      }
                    },
                    child: ((){
                      if(value == true){
                        return Text(frontTextButton,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                          ),
                        );
                      }else{
                        return Text(backTextButton,
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
                          return BorderSide(color: backTextColorButton);
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