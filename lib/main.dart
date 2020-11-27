import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'UI/Home/BLM/home-19-02-blm-create-post.dart';
import 'UI/Home/BLM/home-19-03-regular-create-post.dart';
import 'UI/Home/BLM/home-20-blm-donate.dart';
import 'UI/Home/BLM/home-21-blm-memorial-page-image.dart';
import 'UI/Home/BLM/home-22-blm-connection-list.dart';
import 'UI/Home/BLM/home-24-blm-report.dart';
import 'UI/Home/Regular/home-01-regular-home.dart';
import 'UI/Home/Regular/home-04-01-regular-create-memorial.dart';
import 'UI/Home/Regular/home-05-regular-search.dart';
import 'UI/Home/Regular/home-06-regular-post.dart';
import 'UI/Home/Regular/home-08-regular-profile.dart';
import 'UI/Home/Regular/home-09-02-regular-create-post.dart';
import 'UI/Home/Regular/home-09-03-regular-create-post.dart';
import 'UI/Home/Regular/home-09-regular-create-post.dart';
import 'UI/Home/Regular/home-10-regular-memorial-settings.dart';
import 'UI/Home/BLM/home-01-blm-home.dart';
import 'UI/Home/BLM/home-04-blm-search.dart';
import 'UI/Home/BLM/home-05-blm-post.dart';
import 'UI/Home/BLM/home-07-01-blm-create-memorial.dart';
import 'UI/Home/BLM/home-08-blm-memorial.dart';
import 'UI/Home/BLM/home-09-blm-memorial-settings.dart';
import 'UI/Home/BLM/home-11-blm-page-details.dart';
import 'UI/Home/BLM/home-12-blm-profile.dart';
import 'UI/Home/BLM/home-13-blm-user-profile.dart';
import 'UI/Home/BLM/home-14-blm-user-details.dart';
import 'UI/Home/BLM/home-15-blm-change-password.dart';
import 'UI/Home/BLM/home-16-blm-other-details.dart';
import 'UI/Home/BLM/home-17-blm-report-user.dart';
import 'UI/Home/BLM/home-18-blm-user-update-details.dart';
import 'UI/Home/BLM/home-19-blm-create-post.dart';
import 'UI/Home/Regular/home-12-regular-page-details.dart';
import 'UI/Home/Regular/home-13-regular-memorial.dart';
import 'UI/Home/Regular/home-14-regular-user-profile.dart';
import 'UI/Home/Regular/home-15-regular-user-details.dart';
import 'UI/Home/Regular/home-16-regular-user-update-details.dart';
import 'UI/Home/Regular/home-17-regular-change-password.dart';
import 'UI/Home/Regular/home-18-regular-other-details.dart';
import 'UI/Home/Regular/home-19-regular-connection-list.dart';
import 'UI/Home/Regular/home-21-regular-report.dart';
import 'UI/Home/Regular/home-22-regular-donate.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-03-register.dart';
import 'UI/BLM/blm-04-verify-email.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'package:flutter/material.dart';
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,),
      ),
      child: MaterialApp(
        title: 'Faces by Places',
        home: UIGetStarted(),
        initialRoute: '/',
        theme: ThemeData(
          accentColor: Colors.red,
          cardColor: Colors.purple,
        ),
        routes: <String, WidgetBuilder>{
          '/ui-02-login': (BuildContext context) => UILogin01(),

          '/blm/blm-01-join': (BuildContext context) => BLMJoin(),
          '/blm/blm-02-login': (BuildContext context) => BLMLogin(),
          '/blm/blm-03-register': (BuildContext context) => BLMRegister(),
          '/blm/blm-04-verify-email': (BuildContext context) => BLMVerifyEmail(),
          '/blm/blm-05-upload-photo': (BuildContext context) => BLMUploadPhoto(),

          '/regular/regular-01-join': (BuildContext context) => RegularJoin(),
          '/regular/regular-02-login': (BuildContext context) => RegularLogin(),
          '/regular/regular-03-register': (BuildContext context) => RegularRegister(),
          '/regular/regular-04-verify-email': (BuildContext context) => RegularVerifyEmail(),
          '/regular/regular-05-upload-photo': (BuildContext context) => RegularUploadPhoto(),

          '/home/blm': (BuildContext context) => HomeBLMScreen(),
          '/home/blm/home-04-blm-search': (BuildContext context) => HomeBLMSearch(),
          '/home/blm/home-05-blm-post': (BuildContext context) => HomeBLMPost(),
          '/home/blm/home-07-01-blm-create-memorial': (BuildContext context) => HomeBLMCreateMemorial(),
          '/home/blm/home-08-blm-memorial': (BuildContext context) => HomeBLMMemorialProfile(),
          '/home/blm/home-09-blm-memorial-settings': (BuildContext context) => HomeBLMMemorialSettings(),
          '/home/blm/home-11-blm-page-details': (BuildContext context) => HomeBLMPageDetails(),
          '/home/blm/home-12-blm-profile': (BuildContext context) => HomeBLMProfile(),
          '/home/blm/home-13-blm-user-profile': (BuildContext context) => HomeBLMUserProfile(),
          '/home/blm/home-14-blm-user-details': (BuildContext context) => HomeBLMUserProfileDetails(),
          '/home/blm/home-15-blm-change-password': (BuildContext context) => HomeBLMUserChangePassword(),
          '/home/blm/home-16-blm-other-details': (BuildContext context) => HomeBLMUserOtherDetails(),
          '/home/blm/home-17-blm-report-user': (BuildContext context) => HomeBLMReportUser(),
          '/home/blm/home-18-blm-user-update-details': (BuildContext context) => HomeBLMUserUpdateDetails(),
          '/home/blm/home-19-blm-create-post': (BuildContext context) => HomeBLMCreatePost(),
          '/home/blm/home-19-02-blm-create-post': (BuildContext context) => HomeBLMCreatePostSearch(),
          '/home/blm/home-19-03-regular-create-post': (BuildContext context) => HomeBLMCreatePostSearchUser(),
          '/home/blm/home-20-blm-donate': (BuildContext context) => HomeBLMUserDonate(),
          '/home/blm/home-21-blm-memorial-page-image': (BuildContext context) => HomeBLMMemorialPageImage(),
          '/home/blm/home-22-blm-connection-list': (BuildContext context) => HomeBLMConnectionList(),
          '/home/blm/home-24-blm-report': (BuildContext context) => HomeBLMReport(),
          '/home/blm/home-25-blm-donate': (BuildContext context) => HomeBLMUserDonate(),

          

          '/home/regular': (BuildContext context) => HomeRegularScreen(),
          '/home/regular/home-04-01-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial(),
          '/home/regular/home-05-regular-search': (BuildContext context) => HomeRegularSearch(),
          '/home/regular/home-06-regular-post': (BuildContext context) => HomeRegularPost(),
          '/home/regular/home-08-regular-memorial-profile': (BuildContext context) => HomeRegularProfile(),
          'home/regular/home-09-regular-create-post': (BuildContext context) => HomeRegularCreatePost(),
          'home/regular/home-09-02-regular-create-post': (BuildContext context) => HomeRegularCreatePostSearch(),
          'home/regular/home-09-03-regular-create-post': (BuildContext context) => HomeRegularCreatePostSearchUser(),
          'home/regular/home-10-regular-memorial-settings': (BuildContext context) => HomeRegularMemorialSettings(),
          'home/regular/home-12-regular-page-details': (BuildContext context) => HomeRegularPageDetails(),
          'home/regular/home-13-regular-memorial': (BuildContext context) => HomeRegularMemorialProfile(),
          'home/regular/home-14-regular-user-profile': (BuildContext context) => HomeRegularUserProfile(),
          'home/regular/home-15-regular-user-details': (BuildContext context) => HomeRegularUserProfileDetails(),
          'home/regular/home-16-regular-user-update-details': (BuildContext context) => HomeRegularUserUpdateDetails(),
          'home/regular/home-17-regular-change-password': (BuildContext context) => HomeRegularUserChangePassword(),
          'home/regular/home-18-regular-other-details': (BuildContext context) => HomeRegularUserOtherDetails(),
          'home/regular/home-19-regular-connection-list': (BuildContext context) => HomeRegularConnectionList(),
          'home/regular/home-21-regular-report': (BuildContext context) => HomeRegularReport(),
          'home/regular/home-22-regular-donate': (BuildContext context) => HomeRegularUserDonate(),

        },
      ),
    ),
  );
}
