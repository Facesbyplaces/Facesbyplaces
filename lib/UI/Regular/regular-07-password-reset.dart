import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-09-password-change.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularPasswordReset extends StatefulWidget{
  final String resetToken;
  RegularPasswordReset({this.resetToken});

  RegularPasswordResetState createState() => RegularPasswordResetState(resetToken: resetToken);
}

class RegularPasswordResetState extends State<RegularPasswordReset>{
  final String resetToken;
  RegularPasswordResetState({this.resetToken});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  void initState(){
    super.initState();
    FlutterBranchSdk.logout();
  }

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
          body: ResponsiveWrapper(
            maxWidth: SizeConfig.screenWidth,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            child: Container(
              height: SizeConfig.screenHeight,
              child: Stack(
                children: [

                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 40),
                              
                              Align(
                                alignment: Alignment.topLeft, 
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }, 
                                  icon: Icon(
                                    Icons.arrow_back, 
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 80),

                          Center(child: Text('Change Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                          SizedBox(height: 40,),

                          Center(child: Text('Please enter your new password.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                          SizedBox(height: 80,),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: MiscRegularInputFieldTemplate(
                              key: _key1, 
                              labelText: 'New Password', 
                              type: TextInputType.emailAddress, 
                              labelTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400, 
                                color: Color(0xff000000),
                              ),
                              obscureText: true,
                            ),
                          ),

                          SizedBox(height: 40,),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: MiscRegularInputFieldTemplate(
                              key: _key2, 
                              labelText: 'Confirm Password', 
                              type: TextInputType.emailAddress, 
                              labelTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400, 
                                color: Color(0xff000000),
                              ),
                              obscureText: true,
                            ),
                          ),

                          SizedBox(height: 80,),

                          MiscRegularButtonTemplate(
                            buttonText: 'Change',
                            buttonTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ),
                            onPressed: () async{

                              if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                                await showDialog(
                                  context: context,
                                  builder: (_) => 
                                    AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Please complete the form before submitting.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                    onlyOkButton: true,
                                    buttonOkColor: Colors.red,
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  )
                                );
                              }else if(_key1.currentState.controller.text != _key2.currentState.controller.text){
                                await showDialog(
                                  context: context,
                                  builder: (_) => 
                                    AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Passwords don\'t match. Please try again.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                    onlyOkButton: true,
                                    buttonOkColor: Colors.red,
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  )
                                );
                              }else{
                                context.showLoaderOverlay();
                                bool result = await apiRegularPasswordChange(
                                  password: _key1.currentState.controller.text, 
                                  passwordConfirmation: _key2.currentState.controller.text,
                                  resetToken: resetToken,
                                );
                                context.hideLoaderOverlay();

                                if(result){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => 
                                        AssetGiffyDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('Successfully updated the password.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                        ),
                                        onlyOkButton: true,
                                        buttonOkColor: Colors.green,
                                        onOkButtonPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      )
                                    );
                                  Navigator.popUntil(context, ModalRoute.withName('/regular/login'));
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              }
                              
                            },
                            width: SizeConfig.screenWidth / 2, 
                            height: 45,
                            buttonColor: Color(0xff04ECFF),
                          ),

                          SizedBox(height: 20),
                          
                        ],
                      ),
                    ),
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