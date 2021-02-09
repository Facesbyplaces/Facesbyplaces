import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-02-follow-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class MiscRegularManageMemorialTab extends StatefulWidget{
  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final bool famOrFriends;
  final String pageType;
  final String relationship;

  MiscRegularManageMemorialTab({
    this.index, 
    this.memorialName = '',
    this.description = '',
    this.image,
    this.memorialId,
    this.managed,
    this.follower,
    this.famOrFriends,
    this.pageType,
    this.relationship,
  });

  MiscRegularManageMemorialTabState createState() => MiscRegularManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed, follower: follower, famOrFriends: famOrFriends, pageType: pageType, relationship: relationship);
}

class MiscRegularManageMemorialTabState extends State<MiscRegularManageMemorialTab>{

  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final bool famOrFriends;
  final String pageType;
  final String relationship;

  MiscRegularManageMemorialTabState({
    this.index, 
    this.memorialName,
    this.description,
    this.image,
    this.memorialId,
    this.managed,
    this.follower,
    this.famOrFriends,
    this.pageType,
    this.relationship,
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
    // ResponsiveWidgets.init(context,
    //   height: SizeConfig.screenHeight,
    //   width: SizeConfig.screenWidth,
    // );
    return GestureDetector(
      onTap: () async{
        if(pageType == 'Memorial'){
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
          }
        }else{
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
          }
        }
      },
      child: Container(
        // height: ScreenUtil().setHeight(80),
        height: 80,
        color: Color(0xffffffff),
        child: Row(
          children: [
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
                            // fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                            fontSize: 14,
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
                            // fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
                            fontSize: 12,
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
              child: ((){
                if(managed == true || famOrFriends == true){
                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    textColor: Color(0xffffffff),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: () async{

                      bool confirmResult = await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Are you sure you want to leave this page?',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          onlyOkButton: false,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                          onCancelButtonPressed: () {
                            Navigator.pop(context, false);
                          },
                        )
                      );

                      if(confirmResult){

                        context.showLoaderOverlay();
                        bool result = await apiRegularLeavePage(memorialId: memorialId);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.popAndPushNamed(context, '/home/regular');
                        }else{
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Something went wrong. Please try again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.red,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }
                      }
                    },
                    child: Text('Leave', style: TextStyle(fontSize: 14,),),
                    // height: ScreenUtil().setHeight(35),
                    height: 35,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(color: Color(0xff04ECFF)),
                    ),
                    color: Color(0xff04ECFF),
                  );
                }else if(follower == true){
                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    textColor: Color(0xffffffff),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: () async{

                      bool confirmResult = await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Are you sure you want to leave this page?',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          onlyOkButton: false,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                          onCancelButtonPressed: () {
                            Navigator.pop(context, false);
                          },
                        )
                      );

                      if(confirmResult){

                        context.showLoaderOverlay();
                        bool result = await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: false);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.popAndPushNamed(context, '/home/regular');
                        }else{
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Something went wrong. Please try again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.red,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }
                      }
                    },
                    child: Text('Leave', style: TextStyle(fontSize: 14,),),
                    // height: ScreenUtil().setHeight(35),
                    height: 35,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(color: Color(0xff04ECFF)),
                    ),
                    color: Color(0xff04ECFF),
                  );
                }else{
                  return MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    textColor: Color(0xff4EC9D4),
                    splashColor: Color(0xff4EC9D4),
                    onPressed: () async{
                      context.showLoaderOverlay();
                      bool result = await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: true);
                      context.hideLoaderOverlay();

                      if(result){
                        Navigator.popAndPushNamed(context, '/home/regular');
                      }else{
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Something went wrong. Please try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                            onlyOkButton: true,
                            buttonOkColor: Colors.red,
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          )
                        );
                      }
                    },
                    child: Text('Join', style: TextStyle(fontSize: 14,),),
                    // height: ScreenUtil().setHeight(35),
                    height: 35,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      side: BorderSide(color: Color(0xff4EC9D4)),
                    ),
                    color: Color(0xffffffff),
                  );
                }
              }()),
            ),
          ],
        ),
      ),
    );
  }
}