import 'package:flutter/material.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-03-register.dart';
import 'UI/BLM/blm-04-verify-email.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/Home/home-01-home.dart';
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Faces by Places',
      home: UIGetStarted(),
      routes: <String, WidgetBuilder>{
        'ui-02-login': (BuildContext context) => UILogin01(),
        'blm/blm-01-join': (BuildContext context) => BLMJoin(),
        'blm/blm-02-login': (BuildContext context) => BLMLogin(),
        'blm/blm-03-register': (BuildContext context) => BLMRegister(),
        'blm/blm-04-verify-email': (BuildContext context) => BLMVerifyEmail(),
        'blm/blm-05-upload-photo': (BuildContext context) => BLMUploadPhoto(),
        'regular/regular-01-join': (BuildContext context) => RegularJoin(),
        'regular/regular-02-login': (BuildContext context) => RegularLogin(),
        'regular/regular-03-register': (BuildContext context) => RegularRegister(),
        'regular/regular-04-verify-email': (BuildContext context) => RegularVerifyEmail(),
        'regular/regular-05-upload-photo': (BuildContext context) => RegularUploadPhoto(),
        'home/': (BuildContext context) => HomeScreen(),
      },
    ),
  );
}
