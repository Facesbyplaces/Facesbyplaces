import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_04_02_01_leave_page.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_02_03_unfollow_page.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_02_01_leave_page.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_02_02_follow_page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';

class MiscRegularManageMemorialTab extends StatefulWidget{
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;
  final bool follower;
  final bool famOrFriends;
  final String pageType;
  final String relationship;
  final bool isGuest;
  const MiscRegularManageMemorialTab({Key? key, this.memorialName = '', this.description = '', required this.image, required this.memorialId, required this.managed, required this.follower, required this.famOrFriends, required this.pageType, required this.relationship, required this.isGuest}) : super(key: key);

  @override
  MiscRegularManageMemorialTabState createState() => MiscRegularManageMemorialTabState();
}

class MiscRegularManageMemorialTabState extends State<MiscRegularManageMemorialTab>{
  ValueNotifier<bool> followButton = ValueNotifier<bool>(false);
  bool manageButton = false;

  @override
  void initState(){
    super.initState();
    followButton.value = widget.follower;
    manageButton = widget.managed;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: followButton,
      builder: (_, bool followButtonListener, __) => GestureDetector(
        onTap: () async{
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
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text(widget.memorialName, overflow: TextOverflow.fade, maxLines: 3, style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
            subtitle: Text(widget.description, maxLines: 5, overflow: TextOverflow.fade, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff888888),),),
            trailing: IgnorePointer(
              ignoring: widget.isGuest,
              child: ((){
                if(widget.managed == true || widget.famOrFriends == true){
                  return MaterialButton(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
                    child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                    splashColor: const Color(0xff4EC9D4),
                    textColor: const Color(0xffffffff),
                    color: const Color(0xff04ECFF),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    height: 35,
                    onPressed: () async{
                      bool confirmResult = await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: 'Confirm',
                          description: 'Are you sure you want to leave this page?',
                          includeOkButton: true,
                          includeCancelButton: true,
                        ),
                      );

                      if(confirmResult == true){
                        context.loaderOverlay.show();
                        String result = 'Failed';
                        if(widget.pageType == 'Memorial'){
                          result = await apiRegularLeavePage(memorialId: widget.memorialId);
                        }else{
                          result = await apiBLMLeavePage(memorialId: widget.memorialId);
                        }
                        context.loaderOverlay.hide();

                        // if(result != 'Failed'){
                        if(result == 'Success'){
                          followButton.value = false;

                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Success',
                              description: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
                              okButtonColor: const Color(0xff4caf50), // GREEN
                              includeOkButton: true,
                            ),
                          );
                        }else{
                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Error',
                              description: result,
                              okButtonColor: const Color(0xfff44336), // RED
                              includeOkButton: true,
                            ),
                          );
                        }
                      }
                    },
                  );
                }else if(followButtonListener == true){
                  return MaterialButton(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
                    child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                    splashColor: const Color(0xff4EC9D4),
                    textColor: const Color(0xffffffff),
                    color: const Color(0xff04ECFF),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    height: 35,
                    onPressed: () async{
                      bool confirmResult = await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: 'Confirm',
                          description: 'Are you sure you want to leave this page?',
                          includeOkButton: true,
                          includeCancelButton: true,
                        ),
                      );

                      if(confirmResult == true){
                        context.loaderOverlay.show();
                        bool result = await apiRegularModifyUnfollowPage(pageType: widget.pageType, pageId: widget.memorialId);
                        context.loaderOverlay.hide();

                        if(result){
                          followButton.value = false;

                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Success',
                              description: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
                              okButtonColor: const Color(0xff4caf50), // GREEN
                              includeOkButton: true,
                            ),
                          );
                        }else{
                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Error',
                              description: 'Something went wrong. Please try again.',
                              okButtonColor: const Color(0xfff44336), // RED
                              includeOkButton: true,
                            ),
                          );
                        }
                      }
                    },
                  );
                }else{
                  return MaterialButton(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff4EC9D4)),),
                    child: const Text('Join', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold'),),
                    splashColor: const Color(0xff4EC9D4),
                    textColor: const Color(0xff4EC9D4),
                    color: const Color(0xffffffff),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    height: 35,
                    onPressed: () async{
                      context.loaderOverlay.show();
                      bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId);
                      context.loaderOverlay.hide();

                      if(result){
                        followButton.value = true;

                        await showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: 'Success',
                            description: 'Successfully followed the page. You will receive notifications from this page.',
                            okButtonColor: const Color(0xff4caf50), // GREEN
                            includeOkButton: true,
                          ),
                        );
                      }else{
                        await showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: 'Error',
                            description: 'Something went wrong. Please try again.',
                            okButtonColor: const Color(0xfff44336), // RED
                            includeOkButton: true,
                          ),
                        );
                      }
                    },
                  );
                }
              }()),
            ),
            // trailing: ((){
            //   if(widget.managed == true || widget.famOrFriends == true){
            //     return MaterialButton(
            //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
            //       child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
            //       splashColor: const Color(0xff4EC9D4),
            //       textColor: const Color(0xffffffff),
            //       color: const Color(0xff04ECFF),
            //       padding: EdgeInsets.zero,
            //       elevation: 0,
            //       height: 35,
            //       onPressed: () async{
            //         bool confirmResult = await showDialog(
            //           context: context,
            //           builder: (context) => CustomDialog(
            //             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //             title: 'Confirm',
            //             description: 'Are you sure you want to leave this page?',
            //             includeOkButton: true,
            //             includeCancelButton: true,
            //           ),
            //         );

            //         if(confirmResult == true){
            //           context.loaderOverlay.show();
            //           String result = 'Failed';
            //           if(widget.pageType == 'Memorial'){
            //             result = await apiRegularLeavePage(memorialId: widget.memorialId);
            //           }else{
            //             result = await apiBLMLeavePage(memorialId: widget.memorialId);
            //           }
            //           context.loaderOverlay.hide();

            //           if(result != 'Failed'){
            //             followButton.value = false;

            //             await showDialog(
            //               context: context,
            //               builder: (context) => CustomDialog(
            //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //                 title: 'Success',
            //                 description: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
            //                 okButtonColor: const Color(0xff4caf50), // GREEN
            //                 includeOkButton: true,
            //               ),
            //             );
            //           }else{
            //             await showDialog(
            //               context: context,
            //               builder: (context) => CustomDialog(
            //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //                 title: 'Error',
            //                 description: 'Something went wrong. Please try again.',
            //                 okButtonColor: const Color(0xfff44336), // RED
            //                 includeOkButton: true,
            //               ),
            //             );
            //           }
            //         }
            //       },
            //     );
            //   }else if(followButtonListener == true){
            //     return MaterialButton(
            //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
            //       child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
            //       splashColor: const Color(0xff4EC9D4),
            //       textColor: const Color(0xffffffff),
            //       color: const Color(0xff04ECFF),
            //       padding: EdgeInsets.zero,
            //       elevation: 0,
            //       height: 35,
            //       onPressed: () async{
            //         bool confirmResult = await showDialog(
            //           context: context,
            //           builder: (context) => CustomDialog(
            //             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //             title: 'Confirm',
            //             description: 'Are you sure you want to leave this page?',
            //             includeOkButton: true,
            //             includeCancelButton: true,
            //           ),
            //         );

            //         if(confirmResult == true){
            //           context.loaderOverlay.show();
            //           bool result = await apiRegularModifyUnfollowPage(pageType: widget.pageType, pageId: widget.memorialId);
            //           context.loaderOverlay.hide();

            //           if(result){
            //             followButton.value = false;

            //             await showDialog(
            //               context: context,
            //               builder: (context) => CustomDialog(
            //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //                 title: 'Success',
            //                 description: 'Successfully unfollowed the page. You will no longer receive notifications from this page.',
            //                 okButtonColor: const Color(0xff4caf50), // GREEN
            //                 includeOkButton: true,
            //               ),
            //             );
            //           }else{
            //             await showDialog(
            //               context: context,
            //               builder: (context) => CustomDialog(
            //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //                 title: 'Error',
            //                 description: 'Something went wrong. Please try again.',
            //                 okButtonColor: const Color(0xfff44336), // RED
            //                 includeOkButton: true,
            //               ),
            //             );
            //           }
            //         }
            //       },
            //     );
            //   }else{
            //     return MaterialButton(
            //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff4EC9D4)),),
            //       child: const Text('Join', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold'),),
            //       splashColor: const Color(0xff4EC9D4),
            //       textColor: const Color(0xff4EC9D4),
            //       color: const Color(0xffffffff),
            //       padding: EdgeInsets.zero,
            //       elevation: 0,
            //       height: 35,
            //       onPressed: () async{
            //         context.loaderOverlay.show();
            //         bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId);
            //         context.loaderOverlay.hide();

            //         if(result){
            //           followButton.value = true;

            //           await showDialog(
            //             context: context,
            //             builder: (context) => CustomDialog(
            //               image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //               title: 'Success',
            //               description: 'Successfully followed the page. You will receive notifications from this page.',
            //               okButtonColor: const Color(0xff4caf50), // GREEN
            //               includeOkButton: true,
            //             ),
            //           );
            //         }else{
            //           await showDialog(
            //             context: context,
            //             builder: (context) => CustomDialog(
            //               image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            //               title: 'Error',
            //               description: 'Something went wrong. Please try again.',
            //               okButtonColor: const Color(0xfff44336), // RED
            //               includeOkButton: true,
            //             ),
            //           );
            //         }
            //       },
            //     );
            //   }
            // }()),
          ),
        ),
      ),
    );
  }
}