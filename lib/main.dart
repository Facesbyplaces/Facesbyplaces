import 'UI/Home/home-17-report-user.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/Home/home-01-home.dart';
import 'UI/Home/home-04-search.dart';
import 'UI/Home/home-05-01-post.dart';
import 'UI/Home/home-06-memorial.dart';
import 'UI/Home/home-07-create-memorial.dart';
import 'UI/Home/home-08-profile.dart';
import 'UI/Home/home-09-memorial-settings.dart';
import 'UI/Home/home-10-create-post.dart';
import 'UI/Home/home-11-page-details.dart';
import 'UI/Home/home-12-user-profile.dart';
import 'UI/Home/home-13-user-details.dart';
import 'UI/Home/home-14-user-update-details.dart';
import 'UI/Home/home-15-change-password.dart';
import 'UI/Home/home-16-other-details.dart';
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
        '/home/': (BuildContext context) => HomeScreen(),

        '/home/home-04-search': (BuildContext context) => HomeSearch(),
        '/home/home-05-post': (BuildContext context) => HomePost(),
        '/home/home-06-memorial': (BuildContext context) => HomeMemorialProfile(),
        '/home/home-07-01-create-memorial': (BuildContext context) => HomeCreateMemorial(),
        '/home/home-07-02-create-memorial': (BuildContext context) => HomeCreateMemorial2(),
        '/home/home-07-03-create-memorial': (BuildContext context) => HomeCreateMemorial3(),
        '/home/home-08-profile': (BuildContext context) => HomeProfile(),
        '/home/home-09-memorial-settings': (BuildContext context) => HomeMemorialSettings(),
        '/home/home-10-create-post': (BuildContext context) => HomeCreatePost(),
        '/home/home-11-page-details': (BuildContext context) => HomePageDetails(),
        '/home/home-12-user-profile': (BuildContext context) => HomeUserProfile(),
        '/home/home-13-user-details': (BuildContext context) => HomeUserProfileDetails(),
        '/home/home-14-user-update-details': (BuildContext context) => HomeUserUpdateDetails(),
        '/home/home-15-change-password': (BuildContext context) => HomeUserChangePassword(),
        '/home/home-16-other-details': (BuildContext context) => HomeUserOtherDetails(),
        '/home/home-17-report-user': (BuildContext context) => HomeReportUser(),
      },
    ),
  );
}
