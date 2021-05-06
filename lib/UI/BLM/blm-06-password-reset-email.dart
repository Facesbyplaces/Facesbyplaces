import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-08-password-reset.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMPasswordResetEmail extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  
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
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [

                      Column(
                        children: [
                          const SizedBox(height: 40),
                          
                          Align(
                            alignment: Alignment.topLeft, 
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 80,),

                      const Center(child: const Text('Verify Email', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),),

                      const SizedBox(height: 40),

                      const Center(child: const Text('Please enter email address used on signing up.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),),

                      const SizedBox(height: 80,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: MiscBLMInputFieldTemplate(
                          key: _key1, 
                          labelText: 'Email Address', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400, 
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                     const  SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Next',
                        buttonTextStyle: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45, 
                        buttonColor: const Color(0xff04ECFF),
                        onPressed: () async{

                          bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text);

                          if(_key1.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Please complete the form before submitting.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
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
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Invalid email address. Please try again.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }else{
                            context.loaderOverlay.show();

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
                                ..addCustomMetadata('reset-type', 'Blm')
                            );

                            BranchLinkProperties lp = BranchLinkProperties(
                                channel: 'facebook',
                                feature: 'sharing',
                                stage: 'new share',
                              tags: ['one', 'two', 'three']
                            );
                            lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                            FlutterBranchSdk.setIdentity('blm-user-forgot-password');
                            BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

                            context.loaderOverlay.hide();
                            
                            if(response.success){
                              context.loaderOverlay.show();
                              bool result = await apiBLMPasswordReset(email: _key1.currentState!.controller.text, redirectLink: response.result);
                              context.loaderOverlay.hide();
                              
                              if(result == true){
                                await showDialog(
                                  context: context,
                                  builder: (_) => 
                                    AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('An email has been sent to ${_key1.currentState!.controller.text} containing instructions for resetting your password.',
                                      textAlign: TextAlign.center,
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
                                    title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: const Text('Something went wrong. Please try again.',
                                      textAlign: TextAlign.center,
                                    ),
                                    onlyOkButton: true,
                                    buttonOkColor: const Color(0xffff0000),
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
                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: const Text('Something went wrong. Please try again.',
                                    textAlign: TextAlign.center,
                                  ),
                                  onlyOkButton: true,
                                  buttonOkColor: const Color(0xffff0000),
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
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
            ],
          ),
        ),
      ),
    );
  }
}