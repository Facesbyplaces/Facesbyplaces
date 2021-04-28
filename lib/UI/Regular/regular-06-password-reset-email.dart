import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-08-password-reset.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class RegularPasswordResetEmail extends StatelessWidget{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
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

                    SizedBox(height: 80,),

                    Center(child: Text('Verify Email', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                    SizedBox(height: 40,),

                    Center(child: Text('Please enter email address used on signing up.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                    SizedBox(height: 80,),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: MiscRegularInputFieldTemplate(
                        key: _key1, 
                        labelText: 'Email Address', 
                        type: TextInputType.emailAddress, 
                        labelTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400, 
                          color: Color(0xff000000),
                        ),
                      ),
                    ),

                    SizedBox(height: 80,),

                    MiscRegularButtonTemplate(
                      buttonText: 'Next',
                      buttonTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ),
                      width: SizeConfig.screenWidth! / 2, 
                      height: 45,
                      buttonColor: Color(0xff04ECFF),
                      onPressed: () async{

                        bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text);

                        if(_key1.currentState!.controller.text == ''){
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
                        }else if(!validEmail){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Invalid email address. Please try again.',
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

                          BranchUniversalObject buo = BranchUniversalObject(
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

                          BranchLinkProperties lp = BranchLinkProperties(
                            channel: 'facebook',
                            feature: 'sharing',
                            stage: 'new share',
                            tags: ['one', 'two', 'three']
                          );
                          lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                          FlutterBranchSdk.setIdentity('alm-user-forgot-password');
                          BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

                          context.hideLoaderOverlay();
                          
                          if(response.success){
                            context.showLoaderOverlay();
                            bool result = await apiRegularPasswordReset(email: _key1.currentState!.controller.text, redirectLink: response.result);
                            context.hideLoaderOverlay();

                            FlutterClipboard.copy('${response.result}').then(( value ) => print('Url copied!'));
                            
                            if(result == true){
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('An email has been sent to ${_key1.currentState!.controller.text} containing instructions for resetting your password.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                  onlyOkButton: true,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
                              );
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
                    ),

                    SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}