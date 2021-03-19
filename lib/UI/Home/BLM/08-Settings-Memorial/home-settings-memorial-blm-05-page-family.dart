import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-04-show-family-settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-blm-07-search-user-settings.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMPageFamily extends StatefulWidget{
  final int memorialId;
  HomeBLMPageFamily({required this.memorialId});

  HomeBLMPageFamilyState createState() => HomeBLMPageFamilyState(memorialId: memorialId);
}

class HomeBLMPageFamilyState extends State<HomeBLMPageFamily>{
  final int memorialId;
  HomeBLMPageFamilyState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  List<Widget> family = [];
  int familyItemsRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    onLoading1();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(familyItemsRemaining != 0){
          setState(() {
            onLoading1();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more users to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading1();
    });
  }

  void onLoading1() async{
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowFamilySettings(memorialId: memorialId, page: page);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        family.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage}'),),
            title: Text('${newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName} ${newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName}'),
            subtitle: Text('${newValue.blmFamilyList[i].showFamilySettingsRelationship}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: Color(0xffffffff),
              splashColor: Color(0xff04ECFF),
              onPressed: () async{
                context.showLoaderOverlay();
                bool result = await apiBLMDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId, accountType: newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType);
                context.hideLoaderOverlay();

                if(result == true){
                  await showOkAlertDialog(
                    context: context,
                    title: 'Success',
                    message: 'Successfully removed a user from Family list.'
                  );
                }else{
                  await showOkAlertDialog(
                    context: context,
                    title: 'Error',
                    message: 'Something went wrong. Please try again.'
                  );
                }

                familyItemsRemaining = 1;
                page = 1;
                onLoading1();
              },
              child: Text('Remove', style: TextStyle(fontSize: 14,),),
              height: 40,
              shape: StadiumBorder(
                side: BorderSide(color: Color(0xffE74C3C)),
              ),
                color: Color(0xffE74C3C),
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
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Page Family', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMSearchUser(isFamily: true, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Family', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: ClampingScrollPhysics(),
            itemCount: family.length,
            separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => family[i],
          )
        ),
      ),
    );
  }
}