import 'package:facesbyplaces/API/Regular/api-77-regular-follow-page.dart';
import 'package:facesbyplaces/UI/Home/BLM/View-Memorial/home-08-blm-view-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-19-regular-leave-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'misc-08-regular-dialog.dart';

class MiscRegularManageMemorialTab extends StatefulWidget{
  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final String pageType;

  MiscRegularManageMemorialTab({
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

  MiscRegularManageMemorialTabState createState() => MiscRegularManageMemorialTabState(index: index, tab: tab, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed, follower: follower, pageType: pageType);
}

class MiscRegularManageMemorialTabState extends State<MiscRegularManageMemorialTab>{

  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final String pageType;

  MiscRegularManageMemorialTabState({
    this.index, 
    this.tab,
    this.memorialName,
    this.description,
    this.image,
    this.memorialId,
    this.managed,
    this.follower,
    this.pageType,
  });

  bool manageButton;
  bool followButton;

  void initState(){
    super.initState();
    followButton = follower;
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
        print('The memorial type is $pageType');
        print('The memorial id is $memorialId');

        if(managed == true){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,)));
        }else{
          if(pageType == 'Memorial'){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: follower,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, newJoin: follower,)));
          }
          
        }

        // print('hehehehe');


        // Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryPage()));

        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserDonate()));
      },
      child: Container(
        // height: SizeConfig.blockSizeVertical * 15,
        height: ScreenUtil().setHeight(80),
        color: Color(0xffffffff),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0), 
              child: CircleAvatar(
                radius: SizeConfig.blockSizeVertical * 5, 
                backgroundColor: Color(0xff888888), 
                backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/icons/app-icon.png'),),
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
              child: managed == true
              ? MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: manageButton ? Color(0xffffffff) : Color(0xff4EC9D4),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{
                  bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                  if(confirmResult){
                    String result = await apiRegularLeavePage(memorialId);

                    if(result != 'Success'){
                      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: result));
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
              )
              : MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: followButton ? Color(0xffffffff) : Color(0xff4EC9D4),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{

                  setState(() {
                    followButton = !followButton;
                  });

                  await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: followButton);


                  // bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Are you sure you want to unfollow this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                  // if(confirmResult){
                  //   String result = await apiRegularLeavePage(memorialId);

                  //   if(result != 'Success'){
                  //     await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: result));
                  //   }
                  // }

                  // setState(() {
                  //   followButton = !followButton;
                  // });

                  print('The page id is $memorialId');
                  print('The page type is $pageType');

                  // apiRegularModifyFollowPage




                },
                child: followButton ? Text('Unfollow', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),) : Text('Follow', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),),
                // height: SizeConfig.blockSizeVertical * 5,
                height: ScreenUtil().setHeight(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: followButton ? BorderSide(color: Color(0xff04ECFF)) : BorderSide(color: Color(0xff4EC9D4)),
                ),
                color: followButton ? Color(0xff04ECFF) : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
