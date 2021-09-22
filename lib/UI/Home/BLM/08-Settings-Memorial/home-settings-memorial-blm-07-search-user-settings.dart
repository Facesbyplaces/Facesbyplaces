// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_05_search_users.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_11_add_family.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_12_add_friends.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-blm-05-page-family.dart';
import 'home-settings-memorial-blm-06-page-friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String email;
  final int accountType;
  const BLMSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.image, required this.email, required this.accountType});
}

class HomeBLMSearchUser extends StatefulWidget{
  final bool isFamily;
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeBLMSearchUser({Key? key, required this.isFamily, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers}) : super(key: key);

  @override
  HomeBLMSearchUserState createState() => HomeBLMSearchUserState();
}

class HomeBLMSearchUserState extends State<HomeBLMSearchUser>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<BLMSearchUsers> users = [];
  int itemRemaining = 1;
  String keywords = '';
  bool empty = true;
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
    users = [];
    itemRemaining = 1;
    count.value = 0;
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchUsers(keywords: keywords, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontFamily: 'NexaRegular'),),
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmUsers.length;

      for(int i = 0; i < newValue.blmUsers.length; i++){
        users.add(
          BLMSearchUsers(
            userId: newValue.blmUsers[i].searchUsersUserId,
            firstName: newValue.blmUsers[i].searchUsersFirstName,
            lastName: newValue.blmUsers[i].searchUsersLastName,
            email: newValue.blmUsers[i].searchUsersEmail,
            image: newValue.blmUsers[i].searchUsersImage,
            accountType: newValue.blmUsers[i].searchUsersAccountType,
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
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: count,
          builder: (_, int countListener, __) => Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: AppBar(
                leading: Container(),
                backgroundColor: const Color(0xff04ECFF),
                flexibleSpace: Column(
                  children: [
                    const Spacer(),

                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              focusColor: const Color(0xffffffff),
                              hintText: 'Search User',
                              hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search, color: Color(0xff888888), size: 35,),
                                onPressed: () {
                                  keywords = controller.text;

                                  if(controller.text != ''){
                                    onLoading();
                                  }
                                },
                              ),
                            ),
                            onChanged: (newPlaces){
                              keywords = newPlaces;

                              if(newPlaces != ''){
                                itemRemaining = 1;
                                page = 1;
                                keywords = '';
                              }else{
                                itemRemaining = 1;
                                count.value = 0;
                                users = [];
                                page = 1;
                              }
                            },
                            onFieldSubmitted: (newPlaces){
                              keywords = newPlaces;

                              if(newPlaces != ''){
                                onLoading();
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 20,),
                      ],
                    ),

                    const SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            body: SizedBox(
              height: SizeConfig.screenHeight! - kToolbarHeight,
              width: SizeConfig.screenWidth,
              child: countListener == 0
              ? SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Column(
                  children: [

                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                    Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

                    const SizedBox(height: 20,),

                    const Text('Search to add users', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                  ],
                ),
              )
              : SizedBox(
                width: SizeConfig.screenWidth,
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    physics: const ClampingScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (c, index) => ListTile(
                      leading: users[index].image != ''
                      ? CircleAvatar(
                        backgroundColor: const Color(0xff888888),
                        foregroundImage: NetworkImage(users[index].image),
                      )
                      : const CircleAvatar(
                        backgroundColor: Color(0xff888888),
                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                      ),
                      title: Text('${users[index].firstName} ${users[index].lastName}'),
                      subtitle: Text(users[index].email),
                      onTap: () async{
                        if(widget.isFamily){
                          String choice = await showDialog(context: (context), builder: (build) => const MiscBLMRelationshipFromDialog()) ?? '';

                          if(choice != ''){
                            context.loaderOverlay.show();
                            String result = await apiBLMAddFamily(memorialId: widget.memorialId, userId: users[index].userId, relationship: choice, accountType: users[index].accountType);
                            context.loaderOverlay.hide();

                            if(result != 'Success'){
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                  title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  buttonOkColor: const Color(0xffff0000),
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }else{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)),);
                            }
                          }
                        }else{
                          context.loaderOverlay.show();
                          String result = await apiBLMAddFriends(memorialId: widget.memorialId, userId: users[index].userId, accountType: users[index].accountType);
                          context.loaderOverlay.hide();

                          if(result != 'Success'){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                entryAnimation: EntryAnimation.DEFAULT,
                                buttonOkColor: const Color(0xffff0000),
                                onlyOkButton: true,
                                onOkButtonPressed: (){
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers,),),);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}