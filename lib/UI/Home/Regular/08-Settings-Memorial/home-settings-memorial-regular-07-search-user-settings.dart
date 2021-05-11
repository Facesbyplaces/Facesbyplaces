import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-05-search-users.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-11-add-family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-12-add-friends.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-05-page-family.dart';
import 'home-settings-memorial-regular-06-page-friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String email;
  final int accountType;

  const RegularSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.image, required this.email, required this.accountType});
}

class HomeRegularSearchUser extends StatefulWidget{
  final bool isFamily;
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  const HomeRegularSearchUser({required this.isFamily, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

  @override
  HomeRegularSearchUserState createState() => HomeRegularSearchUserState(isFamily: isFamily, memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers);
}

class HomeRegularSearchUserState extends State<HomeRegularSearchUser>{
  final bool isFamily;
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  HomeRegularSearchUserState({required this.isFamily, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});
  
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<RegularSearchUsers> users = [];
  int itemRemaining = 1;
  String keywords = '';
  bool empty = true;
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(itemRemaining != 0){
          setState(() {
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
    setState(() {
      onLoading();
    });
  }
  
  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularSearchUsers(keywords: keywords, page: page);
      context.loaderOverlay.hide();
      
      itemRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almSearchUsers.length; i++){
        users.add(
          RegularSearchUsers(
            userId: newValue.almSearchUsers[i].searchUsersId,
            firstName: newValue.almSearchUsers[i].searchUsersFirstName,
            lastName: newValue.almSearchUsers[i].searchUsersLastName,
            email: newValue.almSearchUsers[i].searchUsersEmail,
            image: newValue.almSearchUsers[i].searchUsersImage,
            accountType: newValue.almSearchUsers[i].searchUsersAccountType,
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
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),

                Expanded(
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: controller,
                      onChanged: (newPlaces){
                        setState(() {
                          keywords = newPlaces;
                        });                

                        if(newPlaces != ''){
                          setState(() {
                            empty = false;
                            itemRemaining = 1;
                            page = 1;
                            keywords = '';
                          });
                        }else{
                          empty = true;
                          setState(() {
                            users = [];
                          });
                        }
                        
                      },
                      onFieldSubmitted: (newPlaces){
                        setState(() {
                          keywords = newPlaces;
                        });

                        if(newPlaces != ''){
                          onLoading();
                        }                
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        focusColor: const Color(0xffffffff),
                        hintText: 'Search User',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              keywords = controller.text;
                            });

                            if(controller.text != ''){
                              onLoading();
                            }
                          },
                          icon: const Icon(Icons.search, color: const Color(0xff888888)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: const BorderSide(color: const Color(0xffffffff)),
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: const Color(0xffffffff)),
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: const Color(0xffffffff)),
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20,),
              ],
            ), 
            leading: Container(),
            backgroundColor: const Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight! - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: empty
            ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

                  const SizedBox(height: 20,),

                  const Text('Search a location to add on your post', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
            : Container(
                width: SizeConfig.screenWidth,
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    physics: const ClampingScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                    itemBuilder: (c, index) => ListTile(
                      onTap: () async{
                        if(isFamily){
                          String choice = await showDialog(context: (context), builder: (build) => const MiscRegularRelationshipFromDialog()) ?? '';

                          if(choice != ''){
                            context.loaderOverlay.show();
                            String result = await apiRegularAddFamily(memorialId: memorialId, userId: users[index].userId, relationship: choice, accountType: users[index].accountType);
                            context.loaderOverlay.hide();

                            if(result != 'Success'){
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Error: $result.',
                                    textAlign: TextAlign.center,
                                  ),
                                  onlyOkButton: true,
                                  buttonOkColor: const Color(0xffff0000),
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
                              );
                            }else{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)),);
                            }
                          }
                        }else{
                          context.loaderOverlay.show();
                          String result = await apiRegularAddFriends(memorialId: memorialId, userId: users[index].userId, accountType: users[index].accountType);
                          context.loaderOverlay.hide();

                          if(result != 'Success'){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Error: $result.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }else{
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)),);
                          }
                        }
                      },
                      leading: users[index].image != ''
                      ? CircleAvatar(
                        backgroundColor: const Color(0xff888888), 
                        foregroundImage: NetworkImage('${users[index].image}'),
                        backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                      )
                      : const CircleAvatar(
                        backgroundColor: const Color(0xff888888), 
                        foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                      ),
                      title: Text('${users[index].firstName} ${users[index].lastName}'),
                      subtitle: Text('${users[index].email}',
                    ),
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}