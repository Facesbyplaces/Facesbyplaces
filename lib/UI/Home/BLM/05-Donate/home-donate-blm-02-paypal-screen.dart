import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class HomeBLMPaypal extends StatefulWidget{

  HomeBLMPaypalState createState() => HomeBLMPaypalState();
}

class HomeBLMPaypalState extends State<HomeBLMPaypal>{

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: WebView(
            initialUrl: 'https://www.sandbox.paypal.com',
          ),
        ),
      ),
    );
  }
}


