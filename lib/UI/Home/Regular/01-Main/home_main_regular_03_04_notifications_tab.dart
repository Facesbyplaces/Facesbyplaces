import 'package:facesbyplaces/API/BLM/03-View-Memorial/api_view_memorial_blm_01_show_memorial_details.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_04_home_notifications_tab.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_01_show_memorial_details.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home_show_post_regular_01_show_original_post_comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeRegularNotificationsTab extends StatefulWidget{
  const HomeRegularNotificationsTab({Key? key}) : super(key: key);

  @override
  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab> with AutomaticKeepAliveClientMixin<HomeRegularNotificationsTab>{
  Future<List<APIRegularHomeTabNotificationExtended>>? showListOfNotifications;
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfNotifications = ValueNotifier<int>(0);
  int page1 = 1;
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  bool updatedNotificationsData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfNotifications = getListOfNotifications(page: page1);

          if(updatedNotificationsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New notifications available. Reload to view.'), 
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more notifications to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  void isGuest() async{ // CHECKS IF THE USER IS A GUEST
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      showListOfNotifications = getListOfNotifications(page: page1);
    }
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedNotificationsData = false;
    lengthOfNotifications.value = 0;
    showListOfNotifications = getListOfNotifications(page: page1);
  }

  Future<List<APIRegularHomeTabNotificationExtended>> getListOfNotifications({required int page}) async{
    APIRegularHomeTabNotificationMain? newValue;
    List<APIRegularHomeTabNotificationExtended> listOfNotifications = [];

    do{
      newValue = await apiRegularHomeNotificationsTab(page: page).onError((error, stackTrace){
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
      listOfNotifications.addAll(newValue.almNotification);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfNotifications.value > 0 && listOfNotifications.length > lengthOfNotifications.value){
        updatedNotificationsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfNotifications.value = listOfNotifications.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded.value = true;
    
    return listOfNotifications;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: isGuestLoggedIn,
      builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
        valueListenable: lengthOfNotifications,
        builder: (_, int lengthOfFeedsListener, __) => ValueListenableBuilder(
          valueListenable: loaded,
          builder: (_, bool loadedListener, __) => RefreshIndicator(
            onRefresh: onRefresh,
            child: FutureBuilder<List<APIRegularHomeTabNotificationExtended>>(
              future: showListOfNotifications,
              builder: (context, notifications){
                if(notifications.connectionState == ConnectionState.done){
                  if(loadedListener && lengthOfFeedsListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Notification is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                        ],
                      ),
                    );
                  }else{
                    return ListView.separated(
                      controller: scrollController,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      physics: const ClampingScrollPhysics(),
                      // padding: const EdgeInsets.all(10.0),
                      itemCount: lengthOfFeedsListener,
                      itemBuilder: (c, i) => MiscNotificationDisplayTemplate(
                        imageIcon: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorImage,
                        notification: notifications.data![i].homeTabNotificationAction,
                        dateCreated: timeago.format(DateTime.parse(notifications.data![i].homeTabNotificationCreatedAt,)),
                        readStatus: notifications.data![i].homeTabNotificationRead,
                        actor: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorFirstName,
                        imageOnPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorId, accountType: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorAccountType)));
                        },
                        titleOnPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorId, accountType: notifications.data![i].homeTabNotificationActor.homeTabNotificationActorAccountType)));
                        },
                        notificationOnPressed: () async{
                          if(notifications.data![i].homeTabNotificationNotificationType == 'Memorial'){
                            context.loaderOverlay.show();
                            var memorialProfile = await apiRegularShowMemorial(memorialId: notifications.data![i].homeTabNotificationPostId);
                            context.loaderOverlay.hide();

                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: notifications.data![i].homeTabNotificationPostId, pageType: notifications.data![i].homeTabNotificationNotificationType, newJoin: memorialProfile.almMemorial.showMemorialFollower,)));
                          }else if(notifications.data![i].homeTabNotificationNotificationType == 'Blm'){
                            context.loaderOverlay.show();
                            var blmProfile = await apiBLMShowMemorial(memorialId: notifications.data![i].homeTabNotificationPostId);
                            context.loaderOverlay.hide();

                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: notifications.data![i].homeTabNotificationPostId, pageType: notifications.data![i].homeTabNotificationNotificationType, newJoin: blmProfile.blmMemorial.memorialFollower,)));
                          }else if(notifications.data![i].homeTabNotificationNotificationType == 'Post'){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: notifications.data![i].homeTabNotificationPostId)));
                          }
                        },
                      ),
                    );
                  }
                }else if(notifications.connectionState == ConnectionState.none){
                  return const Center(child: CustomLoader(),);
                }
                else if(notifications.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        isGuest();
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
    );
  }
}