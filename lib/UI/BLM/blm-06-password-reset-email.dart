import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-08-password-reset.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMPasswordResetEmail extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

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
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical! * 3.65,),
                      ),
                    ),

                    const SizedBox(height: 80,),

                    Center(child: Text('Verify Email', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 5.28, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                    const SizedBox(height: 40),

                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 11.25, right: SizeConfig.blockSizeHorizontal! * 11.25),
                      child: Text('Please enter email address used on signing up.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                      ),
                    ),

                    const SizedBox(height: 80,),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: const Color(0xff000000),
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff), width: 0,),),
                          border: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80,),

                    MiscBLMButtonTemplate(
                      buttonText: 'Next',
                      buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
                      width: SizeConfig.screenWidth! / 2,
                      height: 45,
                      buttonColor: const Color(0xff04ECFF),
                      onPressed: () async{
                        bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controller.text);

                        if(controller.text == ''){
                          await showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }else if(!validEmail){
                          await showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Invalid email address. Please try again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }else{
                          context.loaderOverlay.show();

                          BranchUniversalObject buo = BranchUniversalObject(
                            canonicalIdentifier: 'FacesbyPlaces',
                            title: 'FacesbyPlaces Link',
                            contentDescription: 'FacesbyPlaces link to the app',
                            keywords: ['FacesbyPlaces', 'Link', 'App'],
                            publiclyIndex: true,
                            locallyIndex: true,
                            contentMetadata: BranchContentMetaData()
                              ..addCustomMetadata('custom_string', 'fbp-link')
                              ..addCustomMetadata('reset-type', 'Blm'),
                          );

                          BranchLinkProperties lp = BranchLinkProperties(
                            channel: 'facebook',
                            feature: 'sharing',
                            stage: 'new share',
                            tags: ['one', 'two', 'three'],
                          );
                          lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                          FlutterBranchSdk.setIdentity('blm-user-forgot-password');
                          BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

                          context.loaderOverlay.hide();

                          if(response.success){
                            context.loaderOverlay.show();
                            bool result = await apiBLMPasswordReset(email: controller.text, redirectLink: response.result);
                            context.loaderOverlay.hide();

                            if(result == true){
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('An email has been sent to ${controller.text} containing instructions for resetting your password.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                  onlyOkButton: true,
                                  buttonOkColor: const Color(0xffff0000),
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          }else{
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: (){
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}