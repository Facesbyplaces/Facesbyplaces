import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-02-follow-page.dart';
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

  const MiscRegularManageMemorialTab({
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
    return GestureDetector(
      onTap: () async{
        if(pageType == 'Memorial'){
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: followButton,)));
          }
        }else{
          if(managed == true || famOrFriends == true){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: followButton,)));
          }
        }
      },
      child: Container(
        height: 80,
        color: const Color(0xffffffff),
        child: ListTile(
          leading: image != '' 
          ? CircleAvatar(
            radius: 30, 
            backgroundColor: const Color(0xff888888), 
            foregroundImage: NetworkImage(image),
            backgroundImage: const AssetImage('assets/icons/app-icon.png'),
          ) 
          : const CircleAvatar(
            radius: 30, 
            backgroundColor: const Color(0xff888888), 
            foregroundImage: const AssetImage('assets/icons/app-icon.png'),
          ),
          title: Text(memorialName,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
            ),
          ),
          subtitle: Text(description,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: const Color(0xff888888),
            ),
          ),
          trailing: ((){
            if(managed == true || famOrFriends == true){
              return MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: const Color(0xffffffff),
                splashColor: const Color(0xff4EC9D4),
                onPressed: () async{

                  bool confirmResult = await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Confirm', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Are you sure you want to leave this page?',
                        textAlign: TextAlign.center,
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

                  if(confirmResult == true){

                    context.loaderOverlay.show();
                    String result = await apiRegularLeavePage(memorialId: memorialId);
                    context.loaderOverlay.hide();

                    if(result != 'Failed'){
                      setState(() {
                        followButton = false;
                      });

                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Successfully unfollowed the page. You will no longer receive notifications from this page.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }else{
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Something went wrong. Please try again.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          buttonOkColor: const Color(0xffff0000),
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }
                  }
                },
                child: const Text('Leave', style: const TextStyle(fontSize: 14,),),
                height: 35,
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: const BorderSide(color: const Color(0xff04ECFF)),
                ),
                color: const Color(0xff04ECFF),
              );
            }else if(followButton == true){
              return MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: const Color(0xffffffff),
                splashColor: const Color(0xff4EC9D4),
                onPressed: () async{

                  bool confirmResult = await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Confirm', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Are you sure you want to leave this page?',
                        textAlign: TextAlign.center,
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

                  if(confirmResult == true){

                    context.loaderOverlay.show();
                    bool result = await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: false);
                    context.loaderOverlay.hide();

                    if(result){
                      setState(() {
                        followButton = false;
                      });

                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Successfully unfollowed the page. You will no longer receive notifications from this page.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }else{
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Something went wrong. Please try again.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          buttonOkColor: const Color(0xffff0000),
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }
                  }
                },
                child: const Text('Leave', style: const TextStyle(fontSize: 14,),),
                height: 35,
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: const BorderSide(color: const Color(0xff04ECFF)),
                ),
                color: const Color(0xff04ECFF),
              );
            }else{
              return MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: const Color(0xff4EC9D4),
                splashColor: const Color(0xff4EC9D4),
                onPressed: () async{

                  context.loaderOverlay.show();
                  bool result = await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: true);
                  context.loaderOverlay.hide();

                  if(result){
                    setState(() {
                      followButton = true;
                    });

                    await showDialog(
                      context: context,
                      builder: (_) => 
                        AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: const Text('Successfully followed the page. You will receive notifications from this page.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        onOkButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                      )
                    );
                  }else{
                    await showDialog(
                      context: context,
                      builder: (_) => 
                        AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: const Text('Something went wrong. Please try again.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        buttonOkColor: const Color(0xffff0000),
                        onOkButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                      )
                    );
                  }
                },
                child: const Text('Join', style: const TextStyle(fontSize: 14,),),
                height: 35,
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: const BorderSide(color: const Color(0xff4EC9D4)),
                ),
                color: const Color(0xffffffff),
              );
            }
          }()),
        ),
      ),
    );
  }
}