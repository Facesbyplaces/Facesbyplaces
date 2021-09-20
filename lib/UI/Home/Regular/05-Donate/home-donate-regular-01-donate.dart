// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/06-Donate/api-donate-regular-01-donate.dart';
import 'package:facesbyplaces/API/Regular/06-Donate/api-donate-regular-02-confirm-payment.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart' as pay;
import 'dart:convert';
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
  ValueNotifier<int> donateToggle = ValueNotifier<int>(0);
  CardFieldInputDetails? newCard;
  int paymentToggle = 0;

  void initState(){
    super.initState();
  }

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
        child: ValueListenableBuilder(
          valueListenable: donateToggle,
          builder: (_, int donateToggleListener, __) => Scaffold(
            backgroundColor: const Color(0xff888888),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xffffffff), borderRadius: BorderRadius.circular(20.0),),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: Align(alignment: Alignment.centerLeft, child: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xff000000), size: 35,), onPressed: (){Navigator.pop(context);},)),),

                          const Text('Send a Gift', style: const TextStyle(fontSize: 24,),),

                          Expanded(child: Container(),)
                        ],
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          physics: const ClampingScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: List.generate(6, 
                            (index){
                              return GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: index == donateToggleListener ? 2 : .5, color: index == donateToggleListener ? const Color(0xff70D8FF) : const Color(0xff888888),),
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
                                            case 0: return const Text('\$1.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                            case 1: return const Text('\$5.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                            case 2: return const Text('\$15.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                            case 3: return const Text('\$25.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                            case 4: return const Text('\$50.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                            case 5: return const Text('\$100.00', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),);
                                          }
                                        }()),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  donateToggle.value = index;
                                },
                              );
                            }
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      MiscRegularButtonTemplate(
                        buttonTextStyle: const TextStyle(fontSize: 24, color: const Color(0xffffffff), fontFamily: 'NexaBold',),
                        width: SizeConfig.screenWidth! / 2, 
                        buttonColor: const Color(0xff4EC9D4),
                        buttonText: 'Send Gift',
                        height: 50,
                        onPressed: () async{
                          String amount = '0.99';

                          if(donateToggle.value == 0){
                            amount = '0.99';
                          }else if(donateToggle.value == 1){
                            amount = '5.00';
                          }else if(donateToggle.value == 2){
                            amount = '15.00';
                          }else if(donateToggle.value == 3){
                            amount = '25.00';
                          }else if(donateToggle.value == 4){
                            amount = '50.00';
                          }else if(donateToggle.value == 5){
                            amount = '100.00';
                          }

                          await showMaterialModalBottomSheet( // SHOW PAYMENT OPTIONS
                            context: context,
                            builder: (context){
                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter modalSetState){
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        MaterialButton(
                                          minWidth: 0,
                                          color: const Color(0xffffffff),
                                          child: const Icon(Icons.close, color: Colors.grey,),
                                          shape: CircleBorder(),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        ),

                                        const SizedBox(height: 10,),

                                        const Text('Select your donation method', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

                                        const SizedBox(height: 10,),

                                        Container(
                                          height: 100,
                                          width: SizeConfig.screenWidth,
                                          child: ListView.separated(
                                            itemCount: 2,
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 15,),
                                            itemBuilder: (BuildContext context, int index){
                                              return Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: paymentToggle == index ? Colors.green : const Color(0xffffffff),
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: MaterialButton(
                                                  height: 80,
                                                  minWidth: 120,
                                                  color: Color(0xffffffff),
                                                  focusColor: Colors.blue,
                                                  onPressed: (){
                                                    modalSetState((){
                                                      paymentToggle = index;
                                                    });
                                                  },
                                                  child: ((){
                                                    if(index == 0){
                                                      return Icon(Icons.credit_card_rounded, color: Colors.black);
                                                    }else if(Platform.isIOS){
                                                      return donateWithApple;
                                                    }else{
                                                      return donateWithGoogle;
                                                    }
                                                  }()),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 10,),

                                        Container(
                                          alignment: Alignment.center,
                                          child: ((){
                                            if(paymentToggle == 0){
                                              return MaterialButton(
                                                minWidth: 0,
                                                color: const Color(0xff000000),
                                                shape: const CircleBorder(),
                                                child: const Icon(Icons.arrow_forward_rounded, color: const Color(0xffffffff),),
                                                onPressed: () async{
                                                  await showMaterialModalBottomSheet(
                                                    context: context,
                                                    builder: (context) => Container(
                                                      height: SizeConfig.screenHeight! / 1.5,
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: IconButton(
                                                              icon: const Icon(Icons.arrow_back),
                                                              onPressed: (){
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                            child: CardField(
                                                              onCardChanged: (card){
                                                                newCard = card;
                                                              },
                                                            ),
                                                          ),

                                                          SizedBox(height: 20,),

                                                          MiscRegularButtonTemplate(
                                                            buttonTextStyle: const TextStyle(fontSize: 24, color: const Color(0xffffffff), fontFamily: 'NexaBold',),
                                                            width: SizeConfig.screenWidth! / 2, 
                                                            buttonColor: const Color(0xff4EC9D4),
                                                            buttonText: 'Send Gift',
                                                            height: 50,
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
                                                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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

                                                                print('The payment method id is $paymentMethod');
                                                                print('The payment method id is ${paymentMethod.id}');
                                                                print('The amount is $amount');
                                                                
                                                                List<String> newValue = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: paymentMethod.id).onError((error, stackTrace){
                                                                  context.loaderOverlay.hide();
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (_) => AssetGiffyDialog(
                                                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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

                                                                print('The newValue[0] id is ${newValue[0]}');
                                                                print('The newValue[1] id is ${newValue[1]}');

                                                                bool confirmPaymentResult = await apiRegularConfirmPayment(clientSecret: newValue[0], paymentMethod: newValue[1]).onError((error, stackTrace){
                                                                  context.loaderOverlay.hide();
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (_) => AssetGiffyDialog(
                                                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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

                                                                print('The confirmPaymentResult id is $confirmPaymentResult');

                                                                context.loaderOverlay.hide();

                                                                if(confirmPaymentResult == true){
                                                                  
                                                                  await showDialog(
                                                                    context: context,
                                                                    builder: (_) => AssetGiffyDialog(
                                                                      title: const Text('Thank you', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                      description: const Text('We appreciate your donation on this Memorial page. This will surely help the family during these times.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),
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
                                                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                                                    title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                                    description: const Text('Please input your card information first before proceeding.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                              );
                                            }else if(Platform.isIOS){
                                              return pay.RawApplePayButton(
                                                type: pay.ApplePayButtonType.donate,
                                                onPressed: () async{
                                                  if(Stripe.instance.isApplePaySupported.value == true){
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
                                                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                          description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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

                                                    print('The newValue[0] is ${newValue[0]}');
                                                    print('The newValue[1] is ${newValue[1]}');

                                                    if(onError != true){
                                                      await Stripe.instance.confirmApplePayPayment(newValue[0]);
                                                    }
                                                  }else{
                                                    await showDialog(
                                                      context: context,
                                                      builder: (_) => AssetGiffyDialog(
                                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                        description: const Text('Apple pay is not setup on this phone\'s settings. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                                },
                                              );
                                            }else{
                                              print('here');
                                              var _paymentItems = [
                                                pay.PaymentItem(
                                                  label: 'Donation for ${widget.pageName}',
                                                  amount: amount,
                                                  status: pay.PaymentItemStatus.final_price,
                                                )
                                              ];

                                              print('The _paymentItems is $_paymentItems');
                                              print('The page name is ${widget.pageName}');
                                              print('The amount is $amount');
                                              print('The price is ${pay.PaymentItemStatus.final_price}');

                                              return pay.GooglePayButton(
                                                paymentConfigurationAsset: 'google_pay_payment_profile.json',
                                                paymentItems: _paymentItems,
                                                type: pay.GooglePayButtonType.donate,
                                                margin: const EdgeInsets.only(top: 15),
                                                loadingIndicator: const Center(child: CircularProgressIndicator(),),
                                                onPaymentResult: (paymentResult) async{
                                                  try{
                                                    
                                                    debugPrint('the payment result is $paymentResult');
                                                    final token = paymentResult['paymentMethodData']['tokenizationData']['token'];
                                                    final tokenJson = Map.castFrom(json.decode(token));
                                                    print('The token is $tokenJson');

                                                    bool onError = false;

                                                    List<String> newValue = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: '').onError((error, stackTrace){
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) => AssetGiffyDialog(
                                                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                          description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                                      throw Exception('The error is: $error');
                                                    });

                                                    print('The newValue[0] is ${newValue[0]}');
                                                    print('The newValue[1] is ${newValue[1]}');

                                                    if(onError != true){
                                                      final params = PaymentMethodParams.cardFromToken(token: tokenJson['id'],);

                                                      print('The params is $params');

                                                      PaymentIntent confirmGooglePayment = await Stripe.instance.confirmPayment(newValue[0], params,);

                                                      print('The google payment is $confirmGooglePayment');
                                                      print('The google payment status is ${confirmGooglePayment.status}');

                                                      if(confirmGooglePayment.status == PaymentIntentsStatus.Succeeded){
                                                        await showDialog(
                                                          context: context,
                                                          builder: (_) => AssetGiffyDialog(
                                                            title: const Text('Thank you', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                            description: const Text('We appreciate your donation on this Memorial page. This will surely help the family during these times.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),
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
                                                            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                            description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                                    }
                                                  }catch(e){
                                                    await showDialog(
                                                      context: context,
                                                      builder: (_) => AssetGiffyDialog(
                                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                        description: Text('Error: $e', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                                },
                                                onPressed: () async{
                                                  print('pressed key!');
                                                  await debugChangedStripePublishableKey();
                                                },
                                                onError: (e) async{
                                                  print('The error on google payment: $e');
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => AssetGiffyDialog(
                                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      entryAnimation: EntryAnimation.DEFAULT,
                                                      buttonOkColor: const Color(0xffff0000),
                                                      onlyOkButton: true,
                                                      onOkButtonPressed: (){
                                                        Navigator.pop(context, true);
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          }()),
                                        ),

                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
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
        ),
      ),
    );
  }

  Future<void> debugChangedStripePublishableKey() async {
    if (kDebugMode) {
      final profile =
          await rootBundle.loadString('assets/google_pay_payment_profile.json');
      final isValidKey = profile.contains('pk_test_51Hp23FE1OZN8BRHat4PjzxlWArSwoTP4EYbuPjzgjZEA36wjmPVVT61dVnPvDv0OSks8MgIuALrt9TCzlgfU7lmP005FkfmAik');
      print('The value of isValidKey is $isValidKey');
      assert(
        isValidKey,
        'No stripe publishable key added to assets/google_pay_payment_profile.json',
      );
    }
  }
}