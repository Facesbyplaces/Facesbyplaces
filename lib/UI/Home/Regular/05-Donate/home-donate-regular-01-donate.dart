import 'package:facesbyplaces/API/Regular/06-Donate/api-donate-regular-01-donate.dart';
import 'package:facesbyplaces/API/Regular/06-Donate/api-donate-regular-05-confirm-payment.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart' as pay;
import 'dart:io';

class HomeRegularUserDonate extends StatefulWidget{
  final String pageType;
  final int pageId;
  final String pageName;
  const HomeRegularUserDonate({required this.pageType, required this.pageId, required this.pageName});

  HomeRegularUserDonateState createState() => HomeRegularUserDonateState();
}

class HomeRegularUserDonateState extends State<HomeRegularUserDonate>{
  final Widget donateWithGoogle = SvgPicture.asset('assets/icons/google-pay.svg', semanticsLabel: 'Google Pay Mark', height: 52, width: 52);
  final Widget donateWithApple = SvgPicture.asset('assets/icons/apple-pay.svg', semanticsLabel: 'Apple Pay Mark', height: 32, width: 32);
  CardFieldInputDetails? newCard;
  int donateToggle = 0;

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
          backgroundColor: const Color(0xff888888),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xffffffff), borderRadius: BorderRadius.circular(20.0),),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(child: Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xff000000),), onPressed: (){Navigator.pop(context);},)),),

                      const Text('Send a Gift', style: const TextStyle(fontSize: 24,),),

                      Expanded(child: Container(),)
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
                      physics: const ClampingScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(6, 
                        (index){
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: index == donateToggle ? 2 : .5, color: index == donateToggle ? const Color(0xff70D8FF) : const Color(0xff888888),),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),

                                  Image.asset('assets/icons/gift.png', height: 120, width: 120),

                                  const SizedBox(height: 10),

                                  Container(
                                    child: ((){
                                      switch(index){
                                        case 0: return const Text('\$1.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 1: return const Text('\$5.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 2: return const Text('\$15.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 3: return const Text('\$25.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 4: return const Text('\$50.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 5: return const Text('\$100.00', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                      }
                                    }()),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                donateToggle = index;
                              });
                            },
                          );
                        }
                      ),
                    ),
                  ),

                  MiscRegularButtonTemplate(
                    buttonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
                    width: SizeConfig.screenWidth! / 2, 
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    height: 45,
                    onPressed: () async{

                      String amount = '0.99';

                      if(donateToggle == 0){
                        amount = '0.99';
                      }else if(donateToggle == 1){
                        amount = '5.00';
                      }else if(donateToggle == 2){
                        amount = '15.00';
                      }else if(donateToggle == 3){
                        amount = '25.00';
                      }else if(donateToggle == 4){
                        amount = '50.00';
                      }else if(donateToggle == 5){
                        amount = '100.00';
                      }

                      await showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 20,),

                            Text('Select donation options', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),

                            SizedBox(height: 20,),

                            Platform.isIOS 
                            ? pay.RawApplePayButton(
                              type: pay.ApplePayButtonType.donate,
                              onPressed: () async{
                                bool onError = false;

                                await Stripe.instance.presentApplePay(
                                  ApplePayPresentParams(
                                    cartItems: [
                                      ApplePayCartSummaryItem(
                                        label: 'Donation for ${widget.pageName}',
                                        amount: amount,
                                      ),
                                    ],
                                    country: 'US',
                                    currency: 'USD',
                                  ),
                                );

                                List<String> newValue = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: '').onError((error, stackTrace){
                                  showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      buttonOkColor: const Color(0xffff0000),
                                      onlyOkButton: true,
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                  onError = true;
                                  throw Exception('$error');
                                });

                                if(onError != true){
                                  await Stripe.instance.confirmApplePayPayment(newValue[0]);
                                }
                              },
                            )
                            : pay.RawGooglePayButton(
                              type: pay.GooglePayButtonType.donate,
                              onPressed: () async{

                              },
                            ),

                            SizedBox(height: 15,),

                            GestureDetector(
                              child: Text('Donate with Credit Card', style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular',),),
                              onTap: () async{

                                await showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    height: SizeConfig.screenHeight! / 1.5,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.arrow_back),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                          child: CardField(
                                            onCardChanged: (card){
                                              newCard = card;
                                            },
                                          ),
                                        ),

                                        SizedBox(height: 20,),

                                        MiscRegularButtonTemplate(
                                          buttonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
                                          width: SizeConfig.screenWidth! / 2, 
                                          buttonColor: Color(0xff4EC9D4),
                                          buttonText: 'Send Gift',
                                          height: 45,
                                          onPressed: () async{

                                            if(newCard != null){

                                              context.loaderOverlay.show();

                                              PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(
                                                PaymentMethodParams.card(billingDetails: BillingDetails.fromJson(newCard!.toJson(),),),
                                              ).onError((error, stackTrace){
                                                context.loaderOverlay.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
                                                    onOkButtonPressed: (){
                                                      Navigator.pop(context, true);
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                                throw Exception('$error');
                                              });
                                              
                                              List<String> newValue = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: paymentMethod.id).onError((error, stackTrace){
                                                context.loaderOverlay.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
                                                    onOkButtonPressed: (){
                                                      Navigator.pop(context, true);
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                                throw Exception('$error');
                                              });
                                              bool confirmPaymentResult = await apiRegularConfirmPayment(clientSecret: newValue[0], paymentMethod: newValue[1]).onError((error, stackTrace){
                                                context.loaderOverlay.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
                                                    onOkButtonPressed: (){
                                                      Navigator.pop(context, true);
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                );
                                                throw Exception('$error');
                                              });

                                              context.loaderOverlay.hide();

                                              if(confirmPaymentResult == true){
                                                await showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: const Text('We appreciate your donation on this Memorial page. This will surely help the family during these times.', textAlign: TextAlign.center,),
                                                    title: const Text('Thank you', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    onlyOkButton: true,
                                                    onOkButtonPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              }else{
                                                await showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                                    description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center,),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                                  description: const Text('Please input your card information first before proceeding.', textAlign: TextAlign.center,),
                                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                  entryAnimation: EntryAnimation.DEFAULT,
                                                  buttonOkColor: const Color(0xffff0000),
                                                  onlyOkButton: true,
                                                  onOkButtonPressed: (){
                                                    Navigator.pop(context, true);
                                                  },
                                                )
                                              );
                                            }

                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                              },
                            ),

                            SizedBox(height: 10,),
                          ],
                        ),
                      );
                      
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}