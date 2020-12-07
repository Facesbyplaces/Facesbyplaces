import 'package:facesbyplaces/API/BLM/api-21-blm-leave-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:facesbyplaces/UI/Home/BLM/home-12-blm-profile.dart';
// import 'package:facesbyplaces/Bloc/bloc-03-bloc-blm-misc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'misc-02-blm-dialog.dart';

// class MiscBLMManageMemorialTab extends StatelessWidget{

class MiscBLMManageMemorialTab extends StatefulWidget{
  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;

  MiscBLMManageMemorialTab({
    this.index, 
    this.memorialName = '',
    this.description = '',
    this.image = 'assets/icons/graveyard.png',
    this.memorialId,
  });


  MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId);
}

class MiscBLMManageMemorialTabState extends State<MiscBLMManageMemorialTab>{

  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;

  MiscBLMManageMemorialTabState({
    this.index, 
    this.memorialName,
    this.description,
    this.image,
    this.memorialId,
  });

  bool manageButton = true;

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{

        // Navigator.pushNamed(context, '/home/blm/home-12-blm-profile', arguments: memorialId);


        // Navigator.pushNamed(context, '/home/blm/home-12-blm-profile', arguments: memorialId);
        print('The memorial id is $memorialId');

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));

        // HomeBLMProfile
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 15,
        color: Color(0xffffffff),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0), child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 5, backgroundColor: Color(0xff4EC9D4), backgroundImage: AssetImage(image),),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(memorialName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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
                        child: Text(description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
            ),
            Container(
              padding: EdgeInsets.only(right: 15.0),
              child: MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: manageButton ? Color(0xffffffff) : Color(0xff4EC9D4),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{
                  // setState(() {
                  //   manageButton = !manageButton;
                  // });

                  // if(!manageButton){
                  //   bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));
                  // }

                  bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                  if(confirmResult){
                    String result = await apiBLMLeavePage(memorialId);

                    if(result != 'Success'){
                      await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: result));
                    }
                  }


                },
                child: manageButton ? Text('Leave', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),) : Text('Manage', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),),
                height: SizeConfig.blockSizeVertical * 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: manageButton ? BorderSide(color: Color(0xff04ECFF)) : BorderSide(color: Color(0xff4EC9D4)),
                ),
                color: manageButton ? Color(0xff04ECFF) : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiscBLMManageMemoriaWithButton extends StatelessWidget{

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

  MiscBLMManageMemoriaWithButton({
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
        print('The memorial id in manage is $memorialId');

        // final sharedPrefs = await SharedPreferences.getInstance();
        // sharedPrefs.setInt('blm-user-memorial-id', memorialId);

        Navigator.pushNamed(context, '/home/blm/home-08-blm-memorial', arguments: memorialId);
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
                    case 1: context.bloc<BlocHomeBLMUpdateListSuggested>().updateList(index); break;
                    case 2: context.bloc<BlocHomeBLMUpdateListNearby>().updateList(index); break;
                    case 3: context.bloc<BlocHomeBLMUpdateListBLM>().updateList(index); break;
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
                        case 1: context.bloc<BlocHomeBLMUpdateListSuggested>().updateList(index); break;
                        case 2: context.bloc<BlocHomeBLMUpdateListNearby>().updateList(index); break;
                        case 3: context.bloc<BlocHomeBLMUpdateListBLM>().updateList(index); break;
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