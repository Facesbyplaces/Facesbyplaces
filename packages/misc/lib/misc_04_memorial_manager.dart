part of misc;

class MiscManageMemorialTab extends StatefulWidget{
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
  final VoidCallback memorialOnPressed;
  final Widget followOnPressed;
  const MiscManageMemorialTab({Key? key, required this.index, this.memorialName = '', this.description = '', required this.image, required this.memorialId, required this.managed, required this.follower, required this.famOrFriends, required this.pageType, required this.relationship, required this.memorialOnPressed, required this.followOnPressed}) : super(key: key);

  @override
  MiscManageMemorialTabState createState() => MiscManageMemorialTabState();
}

class MiscManageMemorialTabState extends State<MiscManageMemorialTab>{
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
    return ValueListenableBuilder(
      valueListenable: followButton,
      builder: (_, bool followButtonListener, __) => ListTile(
        tileColor: const Color(0xffffffff),
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
        title: Text(widget.memorialName, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
        subtitle: Text(widget.description, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff888888),),),
        onTap: widget.memorialOnPressed,
        trailing: widget.followOnPressed,
        // onTap: () async{
        //   if(widget.pageType == 'Memorial'){
        //     if(widget.managed == true || widget.famOrFriends == true){
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
        //     }else{
        //       followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
        //     }
        //   }else{
        //     if(widget.managed == true || widget.famOrFriends == true){
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
        //     }else{
        //       followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
        //     }
        //   }
        // }
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
        //           builder: (_) => AssetGiffyDialog(
        //             description: const Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
        //             title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
        //             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //             entryAnimation: EntryAnimation.DEFAULT,
        //             onlyOkButton: false,
        //             onOkButtonPressed: (){
        //               Navigator.pop(context, true);
        //             },
        //             onCancelButtonPressed: (){
        //               Navigator.pop(context, false);
        //             },
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
        //               builder: (_) => AssetGiffyDialog(
        //                 description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
        //                 title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
        //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                 entryAnimation: EntryAnimation.DEFAULT,
        //                 onlyOkButton: true,
        //                 onOkButtonPressed: (){
        //                   Navigator.pop(context, true);
        //                 },
        //               ),
        //             );
        //           }else{
        //             await showDialog(
        //               context: context,
        //               builder: (_) => AssetGiffyDialog(
        //                 description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
        //                 title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
        //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                 entryAnimation: EntryAnimation.DEFAULT,
        //                 buttonOkColor: const Color(0xffff0000),
        //                 onlyOkButton: true,
        //                 onOkButtonPressed: (){
        //                   Navigator.pop(context, true);
        //                 },
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
        //           builder: (_) => AssetGiffyDialog(
        //             description: const Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
        //             title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
        //             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //             entryAnimation: EntryAnimation.DEFAULT,
        //             onlyOkButton: false,
        //             onOkButtonPressed: (){
        //               Navigator.pop(context, true);
        //             },
        //             onCancelButtonPressed: (){
        //               Navigator.pop(context, false);
        //             },
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
        //               builder: (_) => AssetGiffyDialog(
        //                 description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
        //                 title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
        //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                 entryAnimation: EntryAnimation.DEFAULT,
        //                 onlyOkButton: true,
        //                 onOkButtonPressed: (){
        //                   Navigator.pop(context, true);
        //                 },
        //               ),
        //             );
        //           }else{
        //             await showDialog(
        //               context: context,
        //               builder: (_) => AssetGiffyDialog(
        //                 description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
        //                 title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
        //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                 entryAnimation: EntryAnimation.DEFAULT,
        //                 buttonOkColor: const Color(0xffff0000),
        //                 onlyOkButton: true,
        //                 onOkButtonPressed: (){
        //                   Navigator.pop(context, true);
        //                 },
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
        //             builder: (_) => AssetGiffyDialog(
        //               description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle( fontSize: 24, fontFamily: 'NexaRegular', ),),
        //               title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
        //               image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //               entryAnimation: EntryAnimation.DEFAULT,
        //               onlyOkButton: true,
        //               onOkButtonPressed: (){
        //                 Navigator.pop(context, true);
        //               },
        //             ),
        //           );
        //         }else{
        //           await showDialog(
        //             context: context,
        //             builder: (_) => AssetGiffyDialog(
        //               description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
        //               title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
        //               image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //               entryAnimation: EntryAnimation.DEFAULT,
        //               buttonOkColor: const Color(0xffff0000),
        //               onlyOkButton: true,
        //               onOkButtonPressed: (){
        //                 Navigator.pop(context, true);
        //               },
        //             ),
        //           );
        //         }
        //       },
        //     );
        //   }
        // }()),
      ),
    );

    // return ValueListenableBuilder(
    //   valueListenable: followButton,
    //   builder: (_, bool followButtonListener, __) => GestureDetector(
    //     // onTap: () async{
    //     //   if(widget.pageType == 'Memorial'){
    //     //     if(widget.managed == true || widget.famOrFriends == true){
    //     //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
    //     //     }else{
    //     //       followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
    //     //     }
    //     //   }else{
    //     //     if(widget.managed == true || widget.famOrFriends == true){
    //     //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
    //     //     }else{
    //     //       followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
    //     //     }
    //     //   }
    //     // },
    //     child: Container(
    //       color: const Color(0xffffffff),
    //       child: ListTile(
    //         leading: widget.image != ''
    //         ? CircleAvatar(
    //           radius: 30,
    //           backgroundColor: const Color(0xff888888),
    //           foregroundImage: NetworkImage(widget.image),
    //           backgroundImage: const AssetImage('assets/icons/app-icon.png'),
    //         )
    //         : const CircleAvatar(
    //           radius: 30,
    //           backgroundColor: Color(0xff888888),
    //           foregroundImage: AssetImage('assets/icons/app-icon.png'),
    //         ),
    //         title: Text(widget.memorialName, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
    //         subtitle: Text(widget.description, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff888888),),),
    //         trailing: ((){
    //           if(widget.managed == true || widget.famOrFriends == true){
    //             return MaterialButton(
    //               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
    //               child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
    //               splashColor: const Color(0xff4EC9D4),
    //               textColor: const Color(0xffffffff),
    //               color: const Color(0xff04ECFF),
    //               padding: EdgeInsets.zero,
    //               elevation: 0,
    //               height: 35,
    //               onPressed: () async{
    //                 // bool confirmResult = await showDialog(
    //                 //   context: context,
    //                 //   builder: (_) => AssetGiffyDialog(
    //                 //     description: const Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
    //                 //     title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
    //                 //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //     entryAnimation: EntryAnimation.DEFAULT,
    //                 //     onlyOkButton: false,
    //                 //     onOkButtonPressed: (){
    //                 //       Navigator.pop(context, true);
    //                 //     },
    //                 //     onCancelButtonPressed: (){
    //                 //       Navigator.pop(context, false);
    //                 //     },
    //                 //   ),
    //                 // );

    //                 // if(confirmResult == true){
    //                 //   context.loaderOverlay.show();
    //                 //   String result = 'Failed';
    //                 //   if(widget.pageType == 'Memorial'){
    //                 //     result = await apiRegularLeavePage(memorialId: widget.memorialId);
    //                 //   }else{
    //                 //     result = await apiBLMLeavePage(memorialId: widget.memorialId);
    //                 //   }
    //                 //   context.loaderOverlay.hide();

    //                 //   if(result != 'Failed'){
    //                 //     followButton.value = false;

    //                 //     await showDialog(
    //                 //       context: context,
    //                 //       builder: (_) => AssetGiffyDialog(
    //                 //         description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
    //                 //         title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
    //                 //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //         entryAnimation: EntryAnimation.DEFAULT,
    //                 //         onlyOkButton: true,
    //                 //         onOkButtonPressed: (){
    //                 //           Navigator.pop(context, true);
    //                 //         },
    //                 //       ),
    //                 //     );
    //                 //   }else{
    //                 //     await showDialog(
    //                 //       context: context,
    //                 //       builder: (_) => AssetGiffyDialog(
    //                 //         description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
    //                 //         title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
    //                 //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //         entryAnimation: EntryAnimation.DEFAULT,
    //                 //         buttonOkColor: const Color(0xffff0000),
    //                 //         onlyOkButton: true,
    //                 //         onOkButtonPressed: (){
    //                 //           Navigator.pop(context, true);
    //                 //         },
    //                 //       ),
    //                 //     );
    //                 //   }
    //                 // }
    //               },
    //             );
    //           }else if(followButtonListener == true){
    //             return MaterialButton(
    //               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff04ECFF)),),
    //               child: const Text('Leave', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
    //               splashColor: const Color(0xff4EC9D4),
    //               textColor: const Color(0xffffffff),
    //               color: const Color(0xff04ECFF),
    //               padding: EdgeInsets.zero,
    //               elevation: 0,
    //               height: 35,
    //               onPressed: () async{
    //                 // bool confirmResult = await showDialog(
    //                 //   context: context,
    //                 //   builder: (_) => AssetGiffyDialog(
    //                 //     description: const Text('Are you sure you want to leave this page?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
    //                 //     title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
    //                 //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //     entryAnimation: EntryAnimation.DEFAULT,
    //                 //     onlyOkButton: false,
    //                 //     onOkButtonPressed: (){
    //                 //       Navigator.pop(context, true);
    //                 //     },
    //                 //     onCancelButtonPressed: (){
    //                 //       Navigator.pop(context, false);
    //                 //     },
    //                 //   ),
    //                 // );

    //                 // if(confirmResult == true){
    //                 //   context.loaderOverlay.show();
    //                 //   bool result = await apiRegularModifyUnfollowPage(pageType: widget.pageType, pageId: widget.memorialId);
    //                 //   context.loaderOverlay.hide();

    //                 //   if(result){
    //                 //     followButton.value = false;

    //                 //     await showDialog(
    //                 //       context: context,
    //                 //       builder: (_) => AssetGiffyDialog(
    //                 //         description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
    //                 //         title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
    //                 //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //         entryAnimation: EntryAnimation.DEFAULT,
    //                 //         onlyOkButton: true,
    //                 //         onOkButtonPressed: (){
    //                 //           Navigator.pop(context, true);
    //                 //         },
    //                 //       ),
    //                 //     );
    //                 //   }else{
    //                 //     await showDialog(
    //                 //       context: context,
    //                 //       builder: (_) => AssetGiffyDialog(
    //                 //         description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
    //                 //         title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
    //                 //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //         entryAnimation: EntryAnimation.DEFAULT,
    //                 //         buttonOkColor: const Color(0xffff0000),
    //                 //         onlyOkButton: true,
    //                 //         onOkButtonPressed: (){
    //                 //           Navigator.pop(context, true);
    //                 //         },
    //                 //       ),
    //                 //     );
    //                 //   }
    //                 // }
    //               },
    //             );
    //           }else{
    //             return MaterialButton(
    //               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)), side: BorderSide(color: Color(0xff4EC9D4)),),
    //               child: const Text('Join', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold'),),
    //               splashColor: const Color(0xff4EC9D4),
    //               textColor: const Color(0xff4EC9D4),
    //               color: const Color(0xffffffff),
    //               padding: EdgeInsets.zero,
    //               elevation: 0,
    //               height: 35,
    //               onPressed: () async{
    //                 // context.loaderOverlay.show();
    //                 // bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId);
    //                 // context.loaderOverlay.hide();

    //                 // if(result){
    //                 //   followButton.value = true;

    //                 //   await showDialog(
    //                 //     context: context,
    //                 //     builder: (_) => AssetGiffyDialog(
    //                 //       description: const Text('Successfully followed the page. You will receive notifications from this page.', textAlign: TextAlign.center, style: TextStyle( fontSize: 24, fontFamily: 'NexaRegular', ),),
    //                 //       title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
    //                 //       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //       entryAnimation: EntryAnimation.DEFAULT,
    //                 //       onlyOkButton: true,
    //                 //       onOkButtonPressed: (){
    //                 //         Navigator.pop(context, true);
    //                 //       },
    //                 //     ),
    //                 //   );
    //                 // }else{
    //                 //   await showDialog(
    //                 //     context: context,
    //                 //     builder: (_) => AssetGiffyDialog(
    //                 //       description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
    //                 //       title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
    //                 //       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //                 //       entryAnimation: EntryAnimation.DEFAULT,
    //                 //       buttonOkColor: const Color(0xffff0000),
    //                 //       onlyOkButton: true,
    //                 //       onOkButtonPressed: (){
    //                 //         Navigator.pop(context, true);
    //                 //       },
    //                 //     ),
    //                 //   );
    //                 // }
    //               },
    //             );
    //           }
    //         }()),
    //       ),
    //     ),
    //   ),
    // );
  }
}