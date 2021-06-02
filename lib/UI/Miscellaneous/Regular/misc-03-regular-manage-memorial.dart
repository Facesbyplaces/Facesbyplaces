import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-02-follow-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class MiscRegularManageMemorialTab extends StatefulWidget {
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
  const MiscRegularManageMemorialTab({required this.index, this.memorialName = '', this.description = '', required this.image, required this.memorialId, required this.managed, required this.follower, required this.famOrFriends, required this.pageType, required this.relationship,});

  MiscRegularManageMemorialTabState createState() => MiscRegularManageMemorialTabState();
}

class MiscRegularManageMemorialTabState extends State<MiscRegularManageMemorialTab> {
  bool manageButton = false;
  ValueNotifier<bool> followButton = ValueNotifier<bool>(false);

  void initState() {
    super.initState();
    followButton.value = widget.follower;
    manageButton = widget.managed;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: followButton,
      builder: (_, bool followButtonListener, __) => GestureDetector(
        onTap: () async {
          if(widget.pageType == 'Memorial'){
            if(widget.managed == true || widget.famOrFriends == true){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
            }else{
              followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
            }
          }else{
            if(widget.managed == true || widget.famOrFriends == true){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
            }else{
              followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
            }
          }
        },
        child: Container(
          color: const Color(0xffffffff),
          child: ListTile(
            leading: widget.image != ''
            ? CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(widget.image),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            )
            : const CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xff888888),
              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text(
              widget.memorialName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),
            ),
            subtitle: Text(
              widget.description,
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaBold', color: const Color(0xff888888),),
            ),
            trailing: (() {
              if(widget.managed == true || widget.famOrFriends == true){
                return MaterialButton(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  textColor: const Color(0xffffffff),
                  splashColor: const Color(0xff4EC9D4),
                  onPressed: () async {
                    bool confirmResult = await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                        onlyOkButton: false,
                        onOkButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                        onCancelButtonPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    );

                    if(confirmResult == true){
                      context.loaderOverlay.show();
                      String result = await apiRegularLeavePage(memorialId: widget.memorialId);
                      context.loaderOverlay.hide();

                      if(result != 'Failed'){
                        followButton.value = false;

                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Success', textAlign: TextAlign.center, 
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                            onlyOkButton: true,
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }else{
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Leave', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaBold', color: const Color(0xffFFFFFF),),),
                  height: 35,
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5)), side: const BorderSide(color: const Color(0xff04ECFF)),),
                  color: const Color(0xff04ECFF),
                );
              }else if (followButtonListener == true){
                return MaterialButton(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  textColor: const Color(0xffffffff),
                  splashColor: const Color(0xff4EC9D4),
                  onPressed: () async {
                    bool confirmResult = await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                        onlyOkButton: false,
                        onOkButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                        onCancelButtonPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    );

                    if(confirmResult == true){
                      context.loaderOverlay.show();
                      bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId,follow: false);
                      context.loaderOverlay.hide();

                      if(result){
                        followButton.value = false;

                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                            onlyOkButton: true,
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }else{
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Leave', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaBold', color: const Color(0xffFFFFFF),),),
                  height: 35,
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5)), side: const BorderSide(color: const Color(0xff04ECFF)),),
                  color: const Color(0xff04ECFF),
                );
              }else{
                return MaterialButton(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  textColor: const Color(0xff4EC9D4),
                  splashColor: const Color(0xff4EC9D4),
                  onPressed: () async {
                    context.loaderOverlay.show();
                    bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId,follow: true);
                    context.loaderOverlay.hide();

                    if(result){
                      followButton.value = true;

                      await showDialog(
                        context: context,
                        builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle( fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular', ),),
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }else{
                      await showDialog(
                        context: context,
                        builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                          onlyOkButton: true,
                          buttonOkColor: const Color(0xffff0000),
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }
                  },
                  child: Text('Join', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaBold'),),
                  height: 35,
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5)), side: const BorderSide(color: const Color(0xff4EC9D4)),),
                  color: const Color(0xffffffff),
                );
              }
            }()),
          ),
        ),
      ),
    );
  }
}