import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-05-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-create-post-blm-01-create-post.dart';
import 'package:flutter/material.dart';

class BLMSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final int accountType;
  final String image;
  const BLMSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.email, required this.accountType, required this.image});
}

class HomeBLMCreatePostSearchUser extends StatefulWidget{
  final List<BLMTaggedUsers> taggedUsers;
  const HomeBLMCreatePostSearchUser({required this.taggedUsers});

  @override
  HomeBLMCreatePostSearchUserState createState() => HomeBLMCreatePostSearchUserState();
}

class HomeBLMCreatePostSearchUserState extends State<HomeBLMCreatePostSearchUser>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<BLMSearchUsers> users = [];
  int itemRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
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
    itemRemaining = 1;
    count.value = 0;
    users = [];
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchUsers(keywords: controller.text, page: page);
      context.loaderOverlay.hide();
      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmUsers.length;

      for(int i = 0; i < newValue.blmUsers.length; i++){
        users.add(BLMSearchUsers(
          userId: newValue.blmUsers[i].searchUsersUserId,
          firstName: newValue.blmUsers[i].searchUsersFirstName,
          lastName: newValue.blmUsers[i].searchUsersLastName,
          email: newValue.blmUsers[i].searchUsersEmail,
          accountType: newValue.blmUsers[i].searchUsersAccountType,
          image: newValue.blmUsers[i].searchUsersImage,
        ));
      }

      if(widget.taggedUsers.length > 0){
        List<BLMSearchUsers> filteredList = users.where((element){
          bool value = true;

          for(int j = 0; j < widget.taggedUsers.length; j++){
            if(element.userId == widget.taggedUsers[j].userId && element.accountType == widget.taggedUsers[j].accountType){
              value = false;
            }
          }

          return value;
        }).toList();

        users = filteredList;
      }
    }

    if(mounted) 
    page++;
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
              preferredSize: Size.fromHeight(70.0),
              child: AppBar(
                leading: Container(),
                backgroundColor: const Color(0xff04ECFF),
                flexibleSpace: Column(
                  children: [
                    Spacer(),
                    
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Expanded(
                          child: TextFormField(
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              focusColor: const Color(0xffffffff),
                              fillColor: const Color(0xffffffff),
                              hintText: 'Search User',
                              filled: true,
                              hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                              border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                              enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search, color: const Color(0xff888888),),
                                onPressed: () {
                                  print('Search!');
                                  onLoading();
                                },
                              ),
                            ),
                            onChanged: (newPlace){
                              if(newPlace == ''){
                                count.value = 0;
                                users = [];
                                itemRemaining = 1;
                                page = 1;
                              }
                            },
                            onFieldSubmitted: (newPlace){
                              controller.text = newPlace;
                              onLoading();
                            },
                          ),
                        ),

                        const SizedBox(width: 20,),
                      ],
                    ),
                    
                    SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            body: countListener != 0
            ? RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.separated(
                controller: scrollController,
                separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemCount: users.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: users[i].image != ''
                    ? CircleAvatar(
                      maxRadius: 40,
                      backgroundColor: const Color(0xff888888),
                      foregroundImage: NetworkImage(users[i].image),
                    )
                    : const CircleAvatar(
                      maxRadius: 40,
                      backgroundColor: const Color(0xff888888),
                      foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                    ),
                    title: Text(users[i].firstName + ' ' + users[i].lastName, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                    subtitle: Text(users[i].email, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                    onTap: (){
                      Navigator.pop(context, BLMTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
                    },
                  );
                },
              ),
            )
            : Container(
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                    Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

                    const SizedBox(height: 20,),

                    Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}