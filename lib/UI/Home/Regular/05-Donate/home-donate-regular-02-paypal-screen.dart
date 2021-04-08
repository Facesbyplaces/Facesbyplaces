import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class HomeRegularPaypal extends StatefulWidget{

  HomeRegularPaypalState createState() => HomeRegularPaypalState();
}

class HomeRegularPaypalState extends State<HomeRegularPaypal>{

  String url = "";
  double progress = 0;

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
          backgroundColor: Color(0xffECF0F1),
          appBar: AppBar(
             backgroundColor: Color(0xff04ECFF),
            title: Text('Paypal', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AWLin_bJ6V3b0F7WJVam90ow5ffcqWp9aEfQOHYuQtl5nqoSoH47WJKE24dCLiY-Xmg2UmKaj8v9WkWv&response_type=code&redirect_uri=https://www.google.com'),
            ),
          ),
        ),
      ),
    );
  }
}


