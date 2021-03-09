import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeBLMPaypal extends StatefulWidget{

  HomeBLMPaypalState createState() => HomeBLMPaypalState();
}

class HomeBLMPaypalState extends State<HomeBLMPaypal>{

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  // InAppWebViewController? webView;
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
          // body: InAppWebView(
          //   // onReceivedHttpAuthRequest: (InAppWebViewController inAppController, URLAuthenticationChallenge authChallenge){
          //   //   Future<HttpAuthResponse> newValue;

          //   //   print('The value of authChallenge is ${authChallenge.toJson}');
          //   //   print('The value of authChallenge is ${authChallenge.toMap}');
          //   //   print('The value of authChallenge is ${authChallenge.protectionSpace}');

          //   //   print('The value of inAppController is ${inAppController.android}');
          //   //   print('The value of inAppController is ${inAppController.ios}');
          //   //   print('The value of inAppController is ${inAppController.javaScriptHandlersMap}');
          //   //   print('The value of inAppController is ${inAppController.webStorage}');
            
          //   //   return newValue;
          //   // },
          //   // initialUrl: URLRequest(
          //   //   url: Uri.parse("https://flutter.dev/")
          //   // ),
          //   initialUrlRequest: URLRequest(url: Uri.parse('https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.google.com')),
          //   // initialUrl: "https://www.sandbox.paypal.com/connect?flowEntry=static&scope=openid profile email&client_id=AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT&response_type=code&redirect_uri=https://www.google.com",
          //   initialOptions: InAppWebViewGroupOptions(
          //     crossPlatform: InAppWebViewOptions(
          //     ),
          //     ios: IOSInAppWebViewOptions(

          //     ),
          //     // android: AndroidInAppWebViewOptions(
          //     //   useHybridComposition: true
          //     // )
          //   ),
          //   onWebViewCreated: (InAppWebViewController controller) {
          //     webView = controller;
          //   },
          //   onLoadStart: (controller, url) {
          //     setState(() {
          //       this.url = url?.toString() ?? '';
          //     });
          //   },
          //   onLoadStop: (controller, url) async {
          //     setState(() {
          //       this.url = url?.toString() ?? '';
          //     });
          //   },
          //   onProgressChanged: (controller, progress) {
          //     setState(() {
          //       this.progress = progress / 100;
          //     });
          //   },
          // ),

          // body: SingleChildScrollView(
          //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
          //   physics: ClampingScrollPhysics(),
          //   child: Column(
          //     children: [
                
          //       Container(
          //         height: 240,
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             image: AssetImage('assets/icons/paypal.png'),
          //           ),
          //         ),
          //       ),

          //       Text('Log in with Paypal', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),

          //       SizedBox(height: 40,),

          //       TextFormField(
          //         controller: controller1,
          //         keyboardType: TextInputType.emailAddress,
          //         cursorColor: Color(0xff000000),
          //         decoration: InputDecoration(
          //           fillColor: Color(0xffffffff),
          //           filled: true,
          //           alignLabelWithHint: true,
          //           labelText: 'Email',
          //           labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //         ),
          //       ),

          //       SizedBox(height: 20,),

          //       TextFormField(
          //         controller: controller2,
          //         obscureText: true,
          //         keyboardType: TextInputType.text,
          //         cursorColor: Color(0xff000000),
          //         decoration: InputDecoration(
          //           fillColor: Color(0xffffffff),
          //           filled: true,
          //           alignLabelWithHint: true,
          //           labelText: 'Password',
          //           labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(5.0),
          //             borderSide: BorderSide(
          //               color: Color(0xff000000),
          //             ),
          //           ),
          //         ),
          //       ),

          //       SizedBox(height: 40,),

          //       MaterialButton(
          //         padding: EdgeInsets.zero,
          //         onPressed: (){},
          //         child: Text(
          //           'Login',
          //           style: TextStyle(
          //             fontSize: 20, 
          //             fontWeight: FontWeight.bold, 
          //             color: Color(0xffffffff),
          //           ), 
          //         ),
          //         minWidth: SizeConfig.screenWidth,
          //         height: 70,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5.0)
          //         ),
          //         color: Color(0xff0070BA),
          //       ),

          //       SizedBox(height: 20,),

          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}


