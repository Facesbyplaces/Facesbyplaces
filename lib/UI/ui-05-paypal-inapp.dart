import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class InAppPayPal extends StatefulWidget {
  InAppPayPalState createState() => InAppPayPalState();
}

class InAppPayPalState extends State<InAppPayPal> {
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffECF0F1),
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            title: Row(
              children: [
                Text(
                  'Paypal',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 3.16,
                    fontFamily: 'NexaRegular',
                    color: const Color(0xffffffff),
                  ),
                ),
                Spacer()
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon:  Icon(
                Icons.arrow_back,
                color: const Color(0xffffffff),
                size: SizeConfig.blockSizeVertical! * 3.52,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: WebView(
            // initialUrl: 'https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.sandbox.paypal.com/myaccount/summary/',
            initialUrl: 'https://www.sandbox.paypal.com/connect?flowEntry=static&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.sandbox.paypal.com/myaccount/summary/',
            onPageFinished: (value){
              print('onPageFinished: $value');
            },
            onPageStarted: (value){
              print('onPageStarted: $value');
            },
            onProgress: (value){
              print('onProgress: $value');
            },
            onWebResourceError: (value){
              print('onWebResourceError: $value');
              print('onWebResourceError: ${value.description}');
              print('onWebResourceError: ${value.domain}');
              print('onWebResourceError: ${value.errorCode}');
              print('onWebResourceError: ${value.errorType}');
              print('onWebResourceError: ${value.failingUrl}');
            },
            onWebViewCreated: (value) async{
              print('onWebViewCreated: $value');
              String currentUrl = (await value.currentUrl())!;
              print('onWebViewCreated currentUrl: $currentUrl');
              String title = (await value.getTitle())!;
              print('onWebViewCreated title: $title');
            },
          ),
          // body: InAppWebView(
          //   initialUrlRequest: URLRequest(
          //     // url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.sandbox.paypal.com/myaccount/summary/'),
          //     url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.google.com'),
          //   ),
          //   onFindResultReceived: (InAppWebViewController app, int number1, int number2, bool val){
          //     print('The app is ${app.android}');
          //     print('The app is ${app.ios}');
          //     print('The app is ${app.javaScriptHandlersMap}');
          //     print('The app is ${app.webStorage}');
          //     print('The number1 is $number1');
          //     print('The number2 is $number2');
          //     print('The val is $val');
          //     // {void Function(InAppWebViewController, int, int, bool)? onFindResultReceived}
          //   },
          //   onReceivedHttpAuthRequest: (inAppWebViewController, uRLAuthenticationChallenge){
          //     Future<HttpAuthResponse?> http = HttpAuthResponse() as Future<HttpAuthResponse?>;
          //     print('inAppWebViewController is ${inAppWebViewController.android}');
          //     print('inAppWebViewController is ${inAppWebViewController.ios}');
          //     print('inAppWebViewController is ${inAppWebViewController.javaScriptHandlersMap}');
          //     print('inAppWebViewController is ${inAppWebViewController.webStorage}');
          //     return http;
          //     // {Future<HttpAuthResponse?> Function(InAppWebViewController, URLAuthenticationChallenge)? onReceivedHttpAuthRequest}
          //   },
          //   // onReceivedClientCertRequest: (inAppWebViewController, uRLAuthenticationChallenge){
          //   //   // var newValue =inAppWebViewController.cer;
          //   //   var newValue = uRLAuthenticationChallenge.protectionSpace.r;
          //   //   Future<ClientCertResponse?> value = ClientCertResponse(certificatePath: '');
          //   //   return value;
          //   //   // Future<ClientCertResponse?> Function(InAppWebViewController, URLAuthenticationChallenge
          //   // },
          // ),
        ),
      ),
    );
  }
}
