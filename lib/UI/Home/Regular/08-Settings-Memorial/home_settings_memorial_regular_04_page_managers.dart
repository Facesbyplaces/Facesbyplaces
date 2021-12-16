import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_03_show_admin_settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_09_add_admin.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_10_remove_admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';

class HomeRegularPageManagers extends StatefulWidget{
  final int memorialId;
  final bool managed;
  const HomeRegularPageManagers({Key? key, required this.memorialId, required this.managed}) : super(key: key);

  @override
  HomeRegularPageManagersState createState() => HomeRegularPageManagersState();
}

class HomeRegularPageManagersState extends State<HomeRegularPageManagers>{
  Future<List<Widget>>? showListOfAdmins;
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfAdmins = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  ValueNotifier<int> flag = ValueNotifier<int>(0);
  bool updatedAdminsData = false;
  int page1 = 1;
  bool added = false;

  @override
  void initState(){
    super.initState();
    showListOfAdmins = getListOfAdmins(page: page1);
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfAdmins = getListOfAdmins(page: page1);

          if(updatedAdminsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
                content: const Text('New admins available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more admins to show.'), elevation: 0, duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedAdminsData = false;
    lengthOfAdmins.value = 0;
    showListOfAdmins = getListOfAdmins(page: page1);
  }

  Future<List<Widget>> getListOfAdmins({required int page}) async{
    List<Widget> admins = [];
    APIRegularShowAdminsSettingsMain? newValue;

    admins.add(const Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Admin', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff9F9F9F),),),),);

    do{
      newValue = await apiRegularShowAdminSettings(memorialId: widget.memorialId, page: page1).onError((error, stackTrace){
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Something went wrong. Please try again.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
        throw Exception('$error');
      });

      for(int i = 0; i < newValue.almAdminList.length; i++){
        admins.add(
          ListTile(
            leading: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            title: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'NexaBold',
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'NexaRegular',
                color: Color(0xffBDC3C7),
              ),
            ),
            trailing: !newValue.almAdminList[i].showAdminsSettingsPageOwner
            ? MaterialButton(
              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C)),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              color: const Color(0xffE74C3C),
              padding: EdgeInsets.zero,
              height: 40,
              onPressed: () async{
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
                  String result = await apiRegularDeleteMemorialAdmin(pageType: 'Memorial', pageId: widget.memorialId, userId: newValue!.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
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
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Success',
                        description: 'Successfully removed the user from the list.',
                        okButtonColor: const Color(0xff4caf50), // GREEN
                        includeOkButton: true,
                        okButton: (){
                          onRefresh();

                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }
                }
              },
            ) 
            : const SizedBox(height: 0,),
          ),
        );
      }

      admins.add(const Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff9F9F9F),),),),);

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        admins.add(
          ListTile(
            leading: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            title: Text('${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}',
              style: const TextStyle(
                fontSize: 20, 
                fontFamily: 'NexaBold', 
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
              style: const TextStyle(
                fontSize: 16, 
                fontFamily: 'NexaRegular', 
                color: Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              child: const Text('Make Manager', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular',),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xff04ECFF)),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              color: const Color(0xff04ECFF),
              padding: EdgeInsets.zero,
              height: 40,
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Confirm',
                    description: 'Are you sure you want to make this user a manager?',
                    includeOkButton: true,
                    includeCancelButton: true,
                  ),
                );

                if(confirmation && widget.managed){
                  context.loaderOverlay.show();
                  String result = await apiRegularAddMemorialAdmin(pageType: 'Memorial', pageId: widget.memorialId, userId: newValue!.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
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
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Success',
                        description: 'Successfully added as a Manager.',
                        okButtonColor: const Color(0xff4caf50), // GREEN
                        includeOkButton: true,
                        okButton: (){
                          onRefresh();

                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }
                }else{
                  await showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Error',
                      description: 'You can\'t make this user a manager of the memorial page because you are not an administrator.',
                      okButtonColor: const Color(0xfff44336), // RED
                      includeOkButton: true,
                    ),
                  );
                }
              },
            ),
          ),
        );
      }

      if(newValue.almAdminItemsRemaining != 0 || newValue.almFamilyItemsRemaining != 0){
        page++;
      }else if(lengthOfAdmins.value > 0 && admins.length > lengthOfAdmins.value){
        updatedAdminsData = true;
      }
    }while(newValue.almAdminItemsRemaining != 0 || newValue.almFamilyItemsRemaining != 0
    );
    
    if(admins.length == 2){ // NO DATA FROM THE SERVER EXCEPT FOR THE TWO WIDGETS (MY FAMILY AND MY FRIENDS) AND NEEDS TO BE EMPTY
      lengthOfAdmins.value = 0;
    }else{
      lengthOfAdmins.value = admins.length;
    }

    page1 = page;
    loaded.value = true;
    
    return admins;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: lengthOfAdmins,
      builder: (_, int lengthOfAdminsListener, __) => ValueListenableBuilder(
        valueListenable: loaded,
        builder: (_, bool loadedListener, __) => ValueListenableBuilder(
          valueListenable: flag,
          builder: (_, int flagListener, __) => Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: false,
              title: const Text('Page Managers', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,size: 35,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: FutureBuilder<List<Widget>>(
                  future: showListOfAdmins,
                  builder: (context, admins){
                    if(admins.connectionState == ConnectionState.done){
                      if(loadedListener && lengthOfAdminsListener == 0){
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                                Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                                const SizedBox(height: 45,),

                                const Text('Managers list is empty', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          physics: const ClampingScrollPhysics(),
                          itemCount: admins.data!.length,
                          itemBuilder: (c, i){
                            return admins.data![i];
                          }
                        );
                      }
                    }else if(admins.connectionState == ConnectionState.none || admins.connectionState == ConnectionState.waiting){
                      return const Center(child: CustomLoaderThreeDots(),);
                    }
                    else if(admins.hasError){
                      return Center(
                        child: MaterialButton(
                          onPressed: (){
                            onRefresh();
                          },
                          child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                          color: const Color(0xff4EC9D4),
                        ),
                      );
                    }else{
                      return const SizedBox(height: 0,);
                    }
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}