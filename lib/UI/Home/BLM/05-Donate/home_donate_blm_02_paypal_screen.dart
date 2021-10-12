import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_18_paypal_access_token.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_19_paypal_user_information.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_20_paypal_connect.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';

class HomeBLMPaypal extends StatefulWidget{
  final int pageId;
  const HomeBLMPaypal({Key? key, required this.pageId}) : super(key: key);

  @override
  HomeBLMPaypalState createState() => HomeBLMPaypalState();
}

class HomeBLMPaypalState extends State<HomeBLMPaypal>{

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
        child: Scaffold(
          backgroundColor: const Color(0xffECF0F1),
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            centerTitle: false,
            title: const Text('Paypal', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https%3A%2F%2Fwww.sandbox.paypal.com%2Fmyaccount%2Fsummary%2F'),),
            onLoadStart: (InAppWebViewController app, uri) async{
              if(uri!.queryParameters['code'] != null){
                String accessToken = await apiBLMMemorialPaypalAccessToken(code: '${uri.queryParameters['code']}');
                APIBLMShowPaypalUserInformation userInformation = await apiBLMMemorialPaypalUserInformation(accessToken: accessToken);
                bool result = await apiBLMMemorialPaypalConnect(userId: userInformation.userId, name: userInformation.name, email: userInformation.emails[0].email, memorialId: widget.pageId);

                if(result == false){
                  await showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Error',
                      description: 'Something went wrong. Please try again.',
                      okButtonColor: const Color(0xfff44336), // RED
                      includeOkButton: true,
                      okButton: (){
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}