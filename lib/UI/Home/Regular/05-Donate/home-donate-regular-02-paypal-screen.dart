// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-18-paypal-access-token.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-19-paypal-user-information.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-20-paypal-connect.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularPaypal extends StatefulWidget{
  final int pageId;
  const HomeRegularPaypal({required this.pageId});

  HomeRegularPaypalState createState() => HomeRegularPaypalState();
}

class HomeRegularPaypalState extends State<HomeRegularPaypal>{

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
            title: const Text('Paypal', style: const TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https%3A%2F%2Fwww.sandbox.paypal.com%2Fmyaccount%2Fsummary%2F',),),
            onLoadStart: (InAppWebViewController app, uri) async{
              if(uri!.queryParameters['code'] != null){
                String accessToken = await apiRegularMemorialPaypalAccessToken(code: '${uri.queryParameters['code']}');
                APIRegularShowPaypalUserInformation userInformation = await apiRegularMemorialPaypalUserInformation(accessToken: accessToken);
                bool result = await apiRegularMemorialPaypalConnect(userId: userInformation.userId, name: userInformation.name, email: userInformation.emails[0].email, memorialId: widget.pageId);

                if(result == false){
                  await showDialog(
                    context: context,
                    builder: (_) =>  AssetGiffyDialog(
                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      buttonOkColor: const Color(0xffff0000),
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                    )
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