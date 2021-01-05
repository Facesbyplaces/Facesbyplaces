import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-05-leave-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'misc-02-blm-dialog.dart';

class MiscBLMManageMemorialTab extends StatefulWidget{
  // final int index;
  // final String memorialName;
  // final String description;
  // final String image;
  // final int memorialId;
  // final bool managed;

  // MiscBLMManageMemorialTab({
  //   this.index, 
  //   this.memorialName = '',
  //   this.description = '',
  //   this.image = 'assets/icons/graveyard.png',
  //   this.memorialId,
  //   this.managed,
  // });


  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final String pageType;

  MiscBLMManageMemorialTab({
    this.index, 
    this.tab,
    this.memorialName = '',
    this.description = '',
    this.image,
    this.memorialId,
    this.managed,
    this.follower,
    this.pageType,
  });

  MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, tab: tab, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed, follower: follower, pageType: pageType);
  // MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed);
}

class MiscBLMManageMemorialTabState extends State<MiscBLMManageMemorialTab>{

  // final int index;
  // final String memorialName;
  // final String description;
  // final String image;
  // final int memorialId;
  // final bool managed;

  // MiscBLMManageMemorialTabState({
  //   this.index, 
  //   this.memorialName,
  //   this.description,
  //   this.image,
  //   this.memorialId,
  //   this.managed,
  // });

  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final String pageType;

  MiscBLMManageMemorialTabState({
    this.index, 
    this.tab,
    this.memorialName = '',
    this.description = '',
    this.image,
    this.memorialId,
    this.managed,
    this.follower,
    this.pageType,
  });

  bool manageButton;

  void initState(){
    super.initState();
    manageButton = managed;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return GestureDetector(
      onTap: () async{
        print('The value of managed is $managed');
        print('The value of memorial id is $memorialId');
        print('The value of follower is $follower');
        print('The value of pageType is $pageType');

        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));

        if(managed == true){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));
        }else{
          if(pageType == 'Memorial'){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: follower,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, newJoin: follower,)));
          }
        }
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 15,
        color: Color(0xffffffff),
        child: Row(
          children: [
            // Padding(padding: EdgeInsets.only(left: 10.0), child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 5, backgroundColor: Color(0xff4EC9D4), backgroundImage: AssetImage(image),),),
            Padding(
              padding: EdgeInsets.only(left: 10.0), 
              child: CircleAvatar(
                radius: SizeConfig.blockSizeVertical * 5, 
                backgroundColor: Color(0xff888888), 
                backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/icons/app-icon.png'),
              ),
            ),
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 3,
                            fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
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

                  if(manageButton == true){
                    bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                    if(confirmResult){
                      String result = await apiBLMLeavePage(memorialId);

                      if(result != 'Success'){
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: result));
                      }
                    }
                  }

                },
                child: manageButton ? Text('Leave', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),) : Text('Manage', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),),
                // height: SizeConfig.blockSizeVertical * 5,
                height: ScreenUtil().setHeight(35),
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