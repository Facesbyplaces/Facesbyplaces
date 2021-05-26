// import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-01-donate.dart';
import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-03-tokenization.dart';
import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-04-process-payment.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class HomeBLMUserDonate extends StatefulWidget{
  final String pageType;
  final int pageId;
  final String pageName;

  const HomeBLMUserDonate({required this.pageType, required this.pageId, required this.pageName});

  HomeBLMUserDonateState createState() => HomeBLMUserDonateState();
}

class HomeBLMUserDonateState extends State<HomeBLMUserDonate>{

  int donateToggle = 0;
  final Widget donateWithGoogle = SvgPicture.asset('assets/icons/donation-google-pay.svg', semanticsLabel: 'Donate with Google',);

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
          backgroundColor: const Color(0xff888888),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20,),

                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft, 
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: const Color(0xff000000),), 
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                      const Text('Send a Gift', style: const TextStyle(fontSize: 24),),

                      Expanded(child: Container(),)

                    ],
                  ),

                  const SizedBox(height: 20,),

                  Expanded(
                    child: GridView.count(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: List.generate(6, 
                        (index){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                donateToggle = index;
                              });
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10,),

                                  Image.asset('assets/icons/gift.png', height: 120, width: 120),

                                  const SizedBox(height: 10,),

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
                              decoration: BoxDecoration(
                                border: Border.all(width: index == donateToggle ? 2 : .5, color: index == donateToggle ? const Color(0xff70D8FF) : const Color(0xff888888),),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async{

                          String token = await apiBLMTokenization();

                          print('The new token is $token');

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

                          var request = BraintreeDropInRequest(
                            tokenizationKey: token,
                            collectDeviceData: true,
                            applePayRequest: BraintreeApplePayRequest(
                              countryCode: 'US',
                              currencyCode: 'USD',
                              appleMerchantID: 'merchant.com.app.facesbyplaces',
                              amount: double.parse(amount),
                              displayName: 'FacesbyPlaces'
                            ),
                            googlePaymentRequest: BraintreeGooglePaymentRequest(
                              totalPrice: amount,
                              currencyCode: 'USD',
                              billingAddressRequired: false,
                              // googleMerchantID: 'BCR2DN6TV7D57PRP',
                            ),
                            paypalRequest: BraintreePayPalRequest(
                              amount: ((){
                                switch(donateToggle){
                                  case 0: return '0.99';
                                  case 1: return '5.00';
                                  case 2: return '15.00';
                                  case 3: return '25.00';
                                  case 4: return '50.00';
                                  case 5: return '100.00';
                                }
                              }()),
                              displayName: 'Example company',
                            ),
                            cardEnabled: true,
                          );

                          BraintreeDropInResult result = (await BraintreeDropIn.start(request))!;

                          print('The amount is ${request.paypalRequest!.amount}');
                          print('The nonce is ${result.paymentMethodNonce.nonce}');
                          print('The nonce is ${result.deviceData}');

                          var newValue = json.decode(result.deviceData!);
                          var deviceToken = newValue['correlation_id'];

                          print('The newValue is $newValue');
                          print('The deviceToken is $deviceToken');

                          bool paymentResult = await apiBLMProcessToken(amount: request.paypalRequest!.amount!, nonce: result.paymentMethodNonce.nonce, deviceData: deviceToken);

                          print('The paymentResult is $paymentResult');

                          if(paymentResult == true){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: const Text('Thank you', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: const Text('We appreciate your donation on this Memorial page. This will surely help the family during these times.',
                                    textAlign: TextAlign.center,
                                  ),
                                  onlyOkButton: true,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
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
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        height: 44,
                        minWidth: 280,
                        color: const Color(0xff000000),
                        child: Platform.isIOS
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Donate with', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
                            const SizedBox(width: 8.0,),
                            const Icon(FontAwesome5.apple_pay, color: const Color(0xffffffff), size: 40),
                          ],
                        )
                        : donateWithGoogle
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}