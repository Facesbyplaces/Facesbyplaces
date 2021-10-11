import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_04_show_family_settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_13_remove_friends_or_family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_regular_07_search_user_settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';

class HomeRegularPageFamily extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularPageFamily({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers,}) : super(key: key);

  @override
  HomeRegularPageFamilyState createState() => HomeRegularPageFamilyState();
}

class HomeRegularPageFamilyState extends State<HomeRegularPageFamily>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int familyItemsRemaining = 1;
  List<Widget> family = [];
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(familyItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more users to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
        }
      }
    });
  }

  Future<void> onRefresh() async{
    count.value = 0;
    familyItemsRemaining = 1;
    family = [];
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowFamilySettings(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        // showDialog(
        //   context: context,
        //   builder: (_) => AssetGiffyDialog(
        //     title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontFamily: 'NexaRegular'),),
        //     description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
        //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //     entryAnimation: EntryAnimation.DEFAULT,
        //     buttonOkColor: const Color(0xffff0000),
        //     onlyOkButton: true,
        //     onOkButtonPressed: (){
        //       Navigator.pop(context, true);
        //       Navigator.pop(context, true);
        //     },
        //   ),
        // );
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Error: $error.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almFamilyList.length;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        family.add(
          ListTile(
            leading: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage,),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png',),
            ),
            title: Text('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName} ${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
            subtitle: Text(newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsEmail, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            trailing: MaterialButton(
              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C),),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              padding: EdgeInsets.zero,
              color: const Color(0xffE74C3C),
              height: 40,
              onPressed: () async{
                // bool confirmation = await showDialog(
                //   context: context,
                //   builder: (_) => AssetGiffyDialog(
                //     title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                //     description: const Text('Are you sure you want to remove this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                //     entryAnimation: EntryAnimation.DEFAULT,
                //     onlyOkButton: false,
                //     onOkButtonPressed: () async{
                //       Navigator.pop(context, true);
                //     },
                //     onCancelButtonPressed: (){
                //       Navigator.pop(context, false);
                //     },
                //   ),
                // );
                bool confirmation = await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Confirm',
                    description: 'Are you sure you want to remove this user?',
                    includeOkButton: true,
                    includeCancelButton: true,
                  ),
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId, accountType: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    // await showDialog(
                    //   context: context,
                    //   builder: (_) => AssetGiffyDialog(
                    //     title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                    //     description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                    //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    //     entryAnimation: EntryAnimation.DEFAULT,
                    //     buttonOkColor: const Color(0xffff0000),
                    //     onlyOkButton: true,
                    //     onOkButtonPressed: (){
                    //       Navigator.pop(context, true);
                    //     },
                    //   ),
                    // );
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Error',
                        description: 'Error: $result.',
                        okButtonColor: const Color(0xfff44336), // RED
                        includeOkButton: true,
                      ),
                    );
                  }else{
                    // await showDialog(
                    //   context: context,
                    //   builder: (_) => AssetGiffyDialog(
                    //     title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                    //     description: const Text('Successfully removed the user from the list.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',)),
                    //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    //     entryAnimation: EntryAnimation.DEFAULT,
                    //     onlyOkButton: true,
                    //     onOkButtonPressed: (){
                    //       family = [];
                    //       familyItemsRemaining = 1;
                    //       page = 1;
                    //       count.value = 0;
                    //       onLoading();

                    //       Navigator.pop(context, true);
                    //     },
                    //   ),
                    // );
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Success',
                        description: 'Successfully removed the user from the list.',
                        okButtonColor: const Color(0xff4caf50), // GREEN
                        includeOkButton: true,
                        okButton: (){
                          family = [];
                          familyItemsRemaining = 1;
                          page = 1;
                          count.value = 0;
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
    }

    if(mounted){
      page++;
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          centerTitle: false,
          title: const Text('Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              child: const Center(child: Text('Add Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: true, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
              },
            ),
          ],
        ),
        body: SizedBox(
          width: SizeConfig.screenWidth,
          child: countListener != 0
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                const SizedBox(height: 45,),

                const Text('Family list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}