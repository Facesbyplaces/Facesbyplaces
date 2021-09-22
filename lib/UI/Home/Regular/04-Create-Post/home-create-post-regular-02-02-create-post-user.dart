// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_05_search_users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-post-regular-01-create-post.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final int accountType;
  final String image;
  const RegularSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.email, required this.accountType, required this.image});
}

class HomeRegularCreatePostSearchUser extends StatefulWidget{
  final List<RegularTaggedUsers> taggedUsers;
  const HomeRegularCreatePostSearchUser({Key? key, required this.taggedUsers}) : super(key: key);

  @override
  HomeRegularCreatePostSearchUserState createState() => HomeRegularCreatePostSearchUserState();
}

class HomeRegularCreatePostSearchUserState extends State<HomeRegularCreatePostSearchUser>{
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<RegularSearchUsers> users = [];
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
      var newValue = await apiRegularSearchUsers(keywords: controller.text, page: page);
      context.loaderOverlay.hide();
      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almSearchUsers.length;

      for(int i = 0; i < newValue.almSearchUsers.length; i++){
        users.add(RegularSearchUsers(
            userId: newValue.almSearchUsers[i].searchUsersId,
            firstName: newValue.almSearchUsers[i].searchUsersFirstName,
            lastName: newValue.almSearchUsers[i].searchUsersLastName,
            email: newValue.almSearchUsers[i].searchUsersEmail,
            accountType: newValue.almSearchUsers[i].searchUsersAccountType,
            image: newValue.almSearchUsers[i].searchUsersImage,
          ),
        );
      }

      if(widget.taggedUsers.isNotEmpty){
        List<RegularSearchUsers> filteredList = users.where((element){
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
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
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
                                icon: const Icon(Icons.search, color: Color(0xff888888)),
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
                    subtitle: Text(users[i].email, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff888888),),),
                    onTap: (){
                      Navigator.pop(context, RegularTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType),);
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

                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Search a user to tag on your post.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
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