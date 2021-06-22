import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-04-show-family-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularPageFamily extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularPageFamily({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers,});

  HomeRegularPageFamilyState createState() => HomeRegularPageFamilyState();
}

class HomeRegularPageFamilyState extends State<HomeRegularPageFamily>{
  ScrollController scrollController = ScrollController();
  int familyItemsRemaining = 1;
  List<Widget> family = [];
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(familyItemsRemaining != 0){
          setState((){
            onLoading();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more users to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState((){
      onLoading();
    });
  }

  void onLoading() async{
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowFamilySettings(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: Text('Error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Error: $error.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        family.add(
          ListTile(
            leading: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage != ''
            ? CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage}',),
            )
            : const CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: const AssetImage('assets/icons/user-placeholder.png',),
            ),
            title: Text('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName} ${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName}',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.64,
                fontFamily: 'NexaBold',
                color: const Color(0xff000000),
              ),
            ),
            subtitle: Text('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsEmail}',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.11,
                fontFamily: 'NexaRegular',
                color: const Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: const Color(0xffffffff),
              splashColor: const Color(0xff04ECFF),
              child: Text('Remove', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xffffffff),),),
              height: 40,
              shape: const StadiumBorder(side: const BorderSide(color: const Color(0xffE74C3C),),),
              color: Color(0xffE74C3C),
              onPressed: () async {
                bool confirmation = await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: Text('Are you sure you want to remove this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                    onlyOkButton: false,
                    onOkButtonPressed: () async{
                      Navigator.pop(context, true);
                    },
                    onCancelButtonPressed: (){
                      Navigator.pop(context, false);
                    },
                  ),
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId, accountType: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Error: $result.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                        onlyOkButton: true,
                        buttonOkColor: const Color(0xffff0000),
                        onOkButtonPressed: (){
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }else{
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Successfully removed the user from the list.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',)),
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          family = [];
                          familyItemsRemaining = 1;
                          page = 1;
                          onLoading();

                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff04ECFF),
        title: Row(
          children: [
            Text('Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
            
            Spacer(),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            child: Center(child: Text('Add Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: true, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
            },
          ),
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: family.length != 0
        ? RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (c, i) => family[i],
            itemCount: family.length,
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              Text('Family list is empty', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.52, fontFamily: 'NexaBold', color: const Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}