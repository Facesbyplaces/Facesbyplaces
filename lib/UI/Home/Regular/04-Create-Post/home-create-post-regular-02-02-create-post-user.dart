import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-05-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-post-regular-01-create-post.dart';
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

  @override
  HomeRegularCreatePostSearchUserState createState() => HomeRegularCreatePostSearchUserState();
}

class HomeRegularCreatePostSearchUserState extends State<HomeRegularCreatePostSearchUser>{

  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<RegularSearchUsers> users = [];
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  void initState(){
    super.initState();
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
      var newValue = await apiRegularSearchUsers(keywords: controller.text, page: page);
      itemRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almSearchUsers.length; i++){
        users.add(
          RegularSearchUsers(
            userId: newValue.almSearchUsers[i].searchUsersId, 
            firstName: newValue.almSearchUsers[i].searchUsersFirstName, 
            lastName: newValue.almSearchUsers[i].searchUsersLastName,
            email: newValue.almSearchUsers[i].searchUsersEmail,
            accountType: newValue.almSearchUsers[i].searchUsersAccountType,
            image: newValue.almSearchUsers[i].searchUsersImage,
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
            title: TextFormField(
              onChanged: (newPlace){
                if(newPlace == ''){
                  setState(() {
                    empty = true;
                    users = [];
                    itemRemaining = 1;
                    page = 1;
                  });
                }
              },
              onFieldSubmitted: (newPlace){
                setState(() {
                  controller.text = newPlace;
                  empty = false;
                });

                onLoading();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: const Color(0xffffffff),
                focusColor: const Color(0xffffffff),
                hintText: 'Search User',
                hintStyle: const TextStyle(
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  onPressed: (){
                    print('Search!');
                    setState(() {
                      empty = false;
                    });

                    onLoading();
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
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            backgroundColor: const Color(0xff04ECFF),
          ),
          body: empty == false
          ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(10.0),
              physics: const ClampingScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              itemBuilder: (c, i) {
                return ListTile(
                  onTap: (){
                    Navigator.pop(context, RegularTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
                  },
                  leading: users[i].image != '' 
                  ? CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: const Color(0xff888888),
                    backgroundImage: NetworkImage(users[i].image),
                  )
                  : const CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: const Color(0xff888888),
                    backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                  ),
                  title: Text(users[i].firstName + ' ' + users[i].lastName,),
                  subtitle: Text(users[i].email, style: const TextStyle(fontSize: 12, color: const Color(0xff888888),),),
                );
              }
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

                  const Text('Search a location to add on your post', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}