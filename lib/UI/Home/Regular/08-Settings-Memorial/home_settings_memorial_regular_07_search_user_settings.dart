import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_05_search_users.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_11_add_family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_12_add_friends.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_regular_05_page_family.dart';
import 'home_settings_memorial_regular_06_page_friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

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
  const HomeRegularSearchUser({Key? key, required this.isFamily, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers}) : super(key: key);

  @override
  HomeRegularSearchUserState createState() => HomeRegularSearchUserState();
}

class HomeRegularSearchUserState extends State<HomeRegularSearchUser>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<RegularSearchUsers> users = [];
  int itemRemaining = 1;
  String keywords = '';
  int page = 1;

  @override
  void initState(){
    super.initState();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more users to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
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
      var newValue = await apiRegularSearchUsers(keywords: keywords, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Error: $error.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
            okButton: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            }
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almSearchUsers.length;

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
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: count,
          builder: (_, int countListener, __) => Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: AppBar(
                leading: const SizedBox(),
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
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                              contentPadding: const EdgeInsets.all(15.0),
                              focusColor: const Color(0xffffffff),
                              fillColor: const Color(0xffffffff),
                              hintText: 'Search User',
                              filled: true,
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search, color: Color(0xff888888), size: 35,),
                                onPressed: (){
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

                    const Text('Search a user to add on the list', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

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
                        maxRadius: 40,
                        backgroundColor: const Color(0xff888888),
                        foregroundImage: NetworkImage(users[index].image),
                      )
                      : const CircleAvatar(
                        maxRadius: 40,
                        backgroundColor: Color(0xff888888),
                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                      ),
                      title: Text('${users[index].firstName} ${users[index].lastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                      subtitle: Text(users[index].email, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                      onTap: () async{
                        if(widget.isFamily){
                          String choice = await showDialog(context: (context), builder: (build) => const MiscRelationshipFromDialog()) ?? '';

                          if(choice != ''){
                            context.loaderOverlay.show();
                            String result = await apiRegularAddFamily(memorialId: widget.memorialId, userId: users[index].userId, relationship: choice, accountType: users[index].accountType);
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers:widget.switchFollowers)),);
                            }
                          }
                        }else{
                          context.loaderOverlay.show();
                          String result = await apiRegularAddFriends(memorialId: widget.memorialId, userId: users[index].userId, accountType: users[index].accountType);
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)),);
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