import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class HomeRegularPaypal extends StatefulWidget{

  HomeRegularPaypalState createState() => HomeRegularPaypalState();
}

class HomeRegularPaypalState extends State<HomeRegularPaypal>{

  String url = "";
  double progress = 0;
  // WebViewController? controller;

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
              url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.google.com'),
            ),
            // initialUrlRequest: URLRequest(
            //   url: Uri.parse('https://www.sandbox.paypal.com'),
            // ),
            // {Future<HttpAuthResponse?> Function(InAppWebViewController, URLAuthenticationChallenge)?
            onReceivedHttpAuthRequest: (InAppWebViewController controller, URLAuthenticationChallenge url) async{
              print('The controller is $controller');
              print('The controller is ${controller.android}');
              print('The controller is ${controller.ios}');
              print('The controller is ${controller.javaScriptHandlersMap}');
              print('The controller is ${controller.webStorage}');
              print('The url is $url');
              print('The url is ${url.protectionSpace}');
            },
            onConsoleMessage: (InAppWebViewController controller, ConsoleMessage onConsoleMessage){
              print('The console message is $onConsoleMessage');
              print('The console message is ${onConsoleMessage.message}');
              print('The console message is ${onConsoleMessage.messageLevel}');
              print('The controller is $controller');
              print('The controller is ${controller.android}');
              print('The controller is ${controller.ios}');
              print('The controller is ${controller.javaScriptHandlersMap}');
              print('The controller is ${controller.webStorage}');
            },
            onPrint: (InAppWebViewController controller, Uri? url){
              print('The url is ${url!}');
              print('The url is ${url.authority}');
              print('The url is ${url.data!.uri}');
              print('The url is ${url.path}');
              print('The controller is ${controller.android}');
              print('The controller is ${controller.ios}');
              print('The controller is ${controller.javaScriptHandlersMap}');
              print('The controller is ${controller.webStorage}');
            },
          ),
          // body: WebView(
          //   onWebViewCreated: (WebViewController webViewController){
          //     controller = webViewController;
          //   },
          //   initialUrl: 'https://www.sandbox.paypal.com/connect?flowEntry=static&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&scope=openid profile email&redirect_uri=https://www.google.com',
          //   // javascriptChannels: Set.from([
          //   //   name: 'Print', onMessageReceived: (JavascriptMessage message) { print(message.message); }
          //   // ]),
          //   // javascriptChannels: Set.from([
          //   //   JavascriptChannel(
          //   //     name: 'Print',
          //   //     onMessageReceived: (JavascriptMessage message) {
          //   //       //This is where you receive message from 
          //   //       //javascript code and handle in Flutter/Dart
          //   //       //like here, the message is just being printed
          //   //       //in Run/LogCat window of android studio
          //   //       print(message.message);
          //   //     },
          //   //   )
          //   // ]),
          //   // javascriptChannels: <JavascriptChannel>[
          //   //   JavascriptChannel(name: 'Print', onMessageReceived: (JavascriptMessage msg) { print(msg); }),
          //   // ].toSet(),
          //   // javascriptMode: JavascriptMode.unrestricted,
          //   navigationDelegate: (request){
          //     print('The request is ${request.url}');
          //     print('The request is ${request.isForMainFrame}');

          //     return NavigationDecision.navigate;
          //   },
          //   onPageFinished: (value){
          //     print('The value is $value');
          //   },
          // ),
        ),
      ),
    );
  }
}


