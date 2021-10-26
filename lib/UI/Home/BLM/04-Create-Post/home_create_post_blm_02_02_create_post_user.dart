import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_05_search_users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home_create_post_blm_01_create_post.dart';
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
  const HomeBLMCreatePostSearchUser({Key? key, required this.taggedUsers}) : super(key: key);

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

  @override
  void initState(){
    super.initState();
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

      if(widget.taggedUsers.isNotEmpty){
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
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              focusColor: const Color(0xffffffff),
                              fillColor: const Color(0xffffffff),
                              hintText: 'Search User',
                              filled: true,
                              hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search, color: Color(0xff888888),),
                                onPressed: (){
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
                    
                    const SizedBox(height: 5,),
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
                      backgroundColor: Color(0xff888888),
                      foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                    ),
                    title: Text(users[i].firstName + ' ' + users[i].lastName, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                    subtitle: Text(users[i].email, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                    onTap: (){
                      Navigator.pop(context, BLMTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
                    },
                  );
                },
              ),
            )
            : SizedBox(
              width: SizeConfig.screenWidth,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                    Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

                    const SizedBox(height: 20,),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Search a location to add on your post', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                    ),

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