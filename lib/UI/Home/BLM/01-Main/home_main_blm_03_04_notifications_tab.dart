import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_04_04_home_notifications_tab.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api_view_memorial_blm_01_show_memorial_details.dart';
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
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeBLMNotificationsTab extends StatefulWidget{
  const HomeBLMNotificationsTab({Key? key}) : super(key: key);

  @override
  HomeBLMNotificationsTabState createState() => HomeBLMNotificationsTabState();
}

class HomeBLMNotificationsTabState extends State<HomeBLMNotificationsTab>{
  List<MiscNotificationDisplayTemplate> notifications = [];
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  bool isGuestLoggedIn = true;
  int itemRemaining = 1;
  int page = 1;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more notifications to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn != true){
      onLoading();
    }
  }

  Future<void> onRefresh() async{
    count.value = 0;
    notifications = [];
    itemRemaining = 1;
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeNotificationsTab(page: page).onError((error, stackTrace) async{
        context.loaderOverlay.hide();
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
        return Future.error('Error occurred: $error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmNotification.length;

      for(int i = 0; i < newValue.blmNotification.length; i++){
        notifications.add(
          MiscNotificationDisplayTemplate(
            imageIcon: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorImage,
            notification: newValue.blmNotification[i].homeTabNotificationAction,
            dateCreated: timeago.format(DateTime.parse(newValue.blmNotification[i].homeTabNotificationCreatedAt,)),
            readStatus: newValue.blmNotification[i].homeTabNotificationRead,
            actor: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorFirstName,
            imageOnPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorId, accountType: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorAccountType,)));
            },
            titleOnPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorId, accountType: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorAccountType,)));
            },
            notificationOnPressed: () async{
              if(newValue.blmNotification[i].homeTabNotificationNotificationType == 'Memorial'){
                context.loaderOverlay.show();
                var memorialProfile = await apiRegularShowMemorial(memorialId: newValue.blmNotification[i].homeTabNotificationPostId);
                context.loaderOverlay.hide();

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: newValue.blmNotification[i].homeTabNotificationPostId, pageType: newValue.blmNotification[i].homeTabNotificationNotificationType, newJoin: memorialProfile.almMemorial.showMemorialFollower,)));
              }else if(newValue.blmNotification[i].homeTabNotificationNotificationType == 'Blm'){
                context.loaderOverlay.show();
                var blmProfile = await apiBLMShowMemorial(memorialId: newValue.blmNotification[i].homeTabNotificationPostId);
                context.loaderOverlay.hide();

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: newValue.blmNotification[i].homeTabNotificationPostId, pageType: newValue.blmNotification[i].homeTabNotificationNotificationType, newJoin: blmProfile.blmMemorial.memorialFollower,)));
              }else if(newValue.blmNotification[i].homeTabNotificationNotificationType == 'Post'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: newValue.blmNotification[i].homeTabNotificationPostId)));
              }
            },
          ),
        );
      }

      if(mounted){
        page++;
      }
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => SizedBox(
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              physics: const ClampingScrollPhysics(),
              itemCount: countListener,
              itemBuilder: (c, i) => notifications[i],
            ),
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              const Text('Notification is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}