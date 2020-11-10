

import 'UI/Home/Regular/home-01-regular-home.dart';
import 'UI/Home/Regular/home-04-01-regular-create-memorial.dart';
import 'UI/Home/Regular/home-04-02-regular-create-memorial.dart';
import 'UI/Home/Regular/home-04-03-regular-create-memorial.dart';
import 'UI/Home/Regular/home-05-regular-search.dart';
import 'UI/Home/Regular/home-06-regular-post.dart';
import 'UI/Home/Regular/home-08-regular-memorial-profile.dart';
import 'UI/Home/Regular/home-09-regular-create-post.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/Home/BLM/home-01-blm-home.dart';
import 'UI/Home/BLM/home-04-blm-search.dart';
import 'UI/Home/BLM/home-05-blm-post.dart';
import 'UI/Home/BLM/home-07-01-blm-create-memorial.dart';
import 'UI/Home/BLM/home-07-02-blm-create-memorial.dart';
import 'UI/Home/BLM/home-07-03-blm-create-memorial.dart';
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
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-03-register.dart';
import 'UI/BLM/blm-04-verify-email.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'package:flutter/material.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Faces by Places',
      home: UIGetStarted(),
      initialRoute: '/',
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
        '/home/blm/home-04-blm-search': (BuildContext context) => HomeSearch(),
        '/home/blm/home-05-blm-post': (BuildContext context) => HomePost(),
        '/home/blm/home-07-01-blm-create-memorial': (BuildContext context) => HomeCreateMemorial(),
        '/home/blm/home-07-02-blm-create-memorial': (BuildContext context) => HomeCreateMemorial2(),
        '/home/blm/home-07-03-blm-create-memorial': (BuildContext context) => HomeCreateMemorial3(),
        '/home/blm/home-08-blm-memorial': (BuildContext context) => HomeMemorialProfile(),
        '/home/blm/home-09-blm-memorial-settings': (BuildContext context) => HomeMemorialSettings(),
        '/home/blm/home-11-blm-page-details': (BuildContext context) => HomePageDetails(),
        '/home/blm/home-12-blm-profile': (BuildContext context) => HomeProfile(),
        '/home/blm/home-13-blm-user-profile': (BuildContext context) => HomeUserProfile(),
        '/home/blm/home-14-blm-user-details': (BuildContext context) => HomeUserProfileDetails(),
        '/home/blm/home-15-blm-change-password': (BuildContext context) => HomeUserChangePassword(),
        '/home/blm/home-16-blm-other-details': (BuildContext context) => HomeUserOtherDetails(),
        '/home/blm/home-17-blm-report-user': (BuildContext context) => HomeReportUser(),
        '/home/blm/home-18-blm-user-update-details': (BuildContext context) => HomeUserUpdateDetails(),
        '/home/blm/home-19-blm-create-post': (BuildContext context) => HomeCreatePost(),

        '/home/regular': (BuildContext context) => HomeRegularScreen(),
        '/home/regular/home-04-01-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial(),
        '/home/regular/home-04-02-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial2(),
        '/home/regular/home-04-03-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial3(),
        '/home/regular/home-05-regular-search': (BuildContext context) => HomeRegularSearch(),
        '/home/regular/home-06-regular-post': (BuildContext context) => HomeRegularPost(),
        '/home/regular/home-08-regular-memorial-profile': (BuildContext context) => HomeRegularProfile(),
        'home/regular/home-09-regular-create-post': (BuildContext context) => HomeRegularCreatePost(),

      },
    ),
  );
}
