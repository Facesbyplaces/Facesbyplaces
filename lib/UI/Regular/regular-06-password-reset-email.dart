import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-08-password-reset.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RegularPasswordResetEmail extends StatefulWidget{

  RegularPasswordResetEmailState createState() => RegularPasswordResetEmailState();
}

class RegularPasswordResetEmailState extends State<RegularPasswordResetEmail>{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();

  BranchUniversalObject buo;
  BranchLinkProperties lp;

  void initBranchReferences(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Link', 'App'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('custom_string', 'fbp-link')
        ..addCustomMetadata('reset-type', 'Regular')
    );

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
          body: ContainerResponsive(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: ContainerResponsive(
              width: SizeConfig.screenWidth,
              heightResponsive: false,
              widthResponsive: true,
              alignment: Alignment.center,
              child: Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: [

                        SizedBox(height: SizeConfig.blockSizeVertical * 20,),

                        Center(child: Text('Verify Email', style: TextStyle(fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Center(child: Text('Please enter email address used on signing up.', textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                        SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                        MiscRegularInputFieldTemplate(
                          key: _key1, 
                          labelText: 'Email Address', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                            fontWeight: FontWeight.w400, 
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                        MiscRegularButtonTemplate(
                          buttonText: 'Next',
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ),
                          onPressed: () async{

                            bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState.controller.text);

                            if(validEmail == true){
                              initBranchReferences();
                              // initBranchShare();

                              FlutterBranchSdk.setIdentity('alm-user-forgot-password');
                              BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                              
                              if (response.success) {
                                context.showLoaderOverlay();
                                // bool result = await apiHomeResetPassword(email: email, redirectLink: response.result);
                                bool result = await apiRegularPasswordReset(email: _key1.currentState.controller.text, redirectLink: response.result);
                                context.hideLoaderOverlay();
                                
                                print('Link generated: ${response.result}');
                                if(result == true){
                                  await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'An email has been sent to ${_key1.currentState.controller.text} containing instructions for resetting your password.', color: Colors.green,));
                                }else{
                                  print('Error on requesting the api');
                                  await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.',));  
                                }
                              } else {
                                print('Error on generating link');
                                await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.',));
                              }
                            }

                          },
                          width: SizeConfig.screenWidth / 2, 
                          height: SizeConfig.blockSizeVertical * 7, 
                          buttonColor: Color(0xff04ECFF),
                        ),

                      ],
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                      
                      Align(
                        alignment: Alignment.topLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: Icon(
                            Icons.arrow_back, 
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),


            ),
          ),
        ),
      ),
    );
  }
}