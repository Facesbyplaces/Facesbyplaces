import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-02-follow-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class MiscBLMManageMemorialTab extends StatefulWidget{
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

  MiscBLMManageMemorialTab({
    required this.index, 
    this.memorialName = '',
    this.description = '',
    required this.image,
    required this.memorialId,
    required this.managed,
    required this.follower,
    required this.famOrFriends,
    required this.pageType,
    required this.relationship,
  });

  MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed, follower: follower, famOrFriends: famOrFriends, pageType: pageType, relationship: relationship);
}

class MiscBLMManageMemorialTabState extends State<MiscBLMManageMemorialTab>{

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

  MiscBLMManageMemorialTabState({
    required this.index, 
    required this.memorialName,
    required this.description,
    required this.image,
    required this.memorialId,
    required this.managed,
    required this.follower,
    required this.famOrFriends,
    required this.pageType,
    required this.relationship,
  });

  bool manageButton = false;
  bool followButton = false;

  void initState(){
    super.initState();
    followButton = follower;
    manageButton = managed;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{
        if(pageType == 'Blm'){
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
          }
        }else{
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
          }
        }
      },
      child: Container(
        height: 80,
        color: Color(0xffffffff),
        child: ListTile(
          leading: image != '' ? CircleAvatar(radius: 30, backgroundColor: Color(0xff888888), backgroundImage: NetworkImage(image)) : CircleAvatar(radius: 30, backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png')),
          title: Text(memorialName,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          subtitle: Text(description,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: Colors.grey,
            ),
          ),
          trailing: ((){
            if(managed == true || famOrFriends == true){
              return MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: Color(0xffffffff),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{

                  var confirmation = await showOkCancelAlertDialog(
                    context: context,
                    title: 'Confirm',
                    message: 'Are you sure you want to leave this page?',
                    okLabel: 'Yes',
                    cancelLabel: 'No',
                  );

                  if(confirmation == OkCancelResult.ok){

                    context.showLoaderOverlay();
                    bool result = await apiBLMLeavePage(memorialId: memorialId);
                    context.hideLoaderOverlay();

                    if(result){
                      setState(() {
                        followButton = false;
                      });

                      await showOkAlertDialog(
                        context: context,
                        title: 'Success',
                        message: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
                      );
                    }else{
                      await showOkAlertDialog(
                        context: context,
                        title: 'Error',
                        message: 'Something went wrong. Please try again.',
                      );
                    }
                  }

                },
                child: Text('Leave', style: TextStyle(fontSize: 14,),),
                height: 35,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: Color(0xff04ECFF)),
                ),
                color: Color(0xff04ECFF),
              );
            }else if(followButton == true){
              return MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: Color(0xffffffff),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{

                  var confirmation = await showOkCancelAlertDialog(
                    context: context,
                    title: 'Confirm',
                    message: 'Are you sure you want to leave this page?',
                    okLabel: 'Yes',
                    cancelLabel: 'No',
                  );

                  if(confirmation == OkCancelResult.ok){

                    context.showLoaderOverlay();
                    bool result = await apiBLMModifyFollowPage(pageType: pageType, pageId: memorialId, follow: false);
                    context.hideLoaderOverlay();

                    if(result){
                      setState(() {
                        followButton = false;
                      });

                      await showOkAlertDialog(
                        context: context,
                        title: 'Success',
                        message: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
                      );

                    }else{
                      await showOkAlertDialog(
                        context: context,
                        title: 'Error',
                        message: 'Something went wrong. Please try again.',
                      );
                    }
                  }
                },
                child: Text('Leave', style: TextStyle(fontSize: 14,),),
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
                  bool result = await apiBLMModifyFollowPage(pageType: pageType, pageId: memorialId, follow: true);
                  context.hideLoaderOverlay();

                  if(result){
                    setState(() {
                      followButton = true;
                    });

                    await showOkAlertDialog(
                      context: context,
                      title: 'Success',
                      message: 'Successfully followed the page. You will receive notifications from this page.',
                    );
                  }else{
                    await showOkAlertDialog(
                      context: context,
                      title: 'Error',
                      message: 'Something went wrong. Please try again.',
                    );
                  }
                },
                child: Text('Join', style: TextStyle(fontSize: 14,),),
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
      ),
    );
  }
}