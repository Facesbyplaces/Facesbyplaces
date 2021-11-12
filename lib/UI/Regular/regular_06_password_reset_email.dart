import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_08_password_reset.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class RegularPasswordResetEmail extends StatelessWidget{
  RegularPasswordResetEmail({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context){
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
            child: LayoutBuilder(
              builder: (context, constraint){
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          const SizedBox(height: 80,),

                          const Center(child: Text('Verify Email', style: TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                          const SizedBox(height: 40,),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text('Please enter email address used on signing up.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                          ),

                          const SizedBox(height: 80,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: controller,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: const Color(0xff000000),
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              decoration: const InputDecoration(
                                alignLabelWithHint: true,
                                labelText: 'Email Address',
                                labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff), width: 0,),),
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                              ),
                            ),
                          ),

                          const Expanded(child: SizedBox()),

                          const SizedBox(height: 50,),

                          MiscButtonTemplate(
                            buttonText: 'Next',
                            buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
                            buttonColor: const Color(0xff04ECFF),
                            width: SizeConfig.screenWidth! / 2,
                            height: 50,
                            onPressed: () async{
                              bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(controller.text);

                              if(controller.text == ''){
                                await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Error',
                                    description: 'Please complete the form before submitting.',
                                    okButtonColor: const Color(0xfff44336), // RED
                                    includeOkButton: true,
                                  ),
                                );
                              }else if(!validEmail){
                                await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Error',
                                    description: 'Invalid email address. Please try again.',
                                    okButtonColor: const Color(0xfff44336), // RED
                                    includeOkButton: true,
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
                                  ..addCustomMetadata('reset-type', 'Regular'),
                                );

                                BranchLinkProperties lp = BranchLinkProperties(channel: 'facebook', feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three'],);
                                lp.addControlParam('url','https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                                FlutterBranchSdk.setIdentity('alm-user-forgot-password');
                                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

                                context.loaderOverlay.hide();

                                if(response.success){
                                  context.loaderOverlay.show();
                                  List<dynamic> result = await apiRegularPasswordReset(email: controller.text, redirectLink: response.result);
                                  context.loaderOverlay.hide();

                                  FlutterClipboard.copy('${response.result}').then((value){});

                                  if(result[0] == true){
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Success',
                                        description: result[1],
                                        okButtonColor: const Color(0xff4caf50), // GREEN
                                        includeOkButton: true,
                                      ),
                                    );
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Error',
                                        description: result[1],
                                        okButtonColor: const Color(0xfff44336), // RED
                                        includeOkButton: true,
                                      ),
                                    );
                                  }
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: 'Error',
                                      description: 'Something went wrong. Please try again.',
                                      okButtonColor: const Color(0xfff44336), // RED
                                      includeOkButton: true,
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
                );
              }  
            ),
          ),
        ),
      ),
    );
  }
}