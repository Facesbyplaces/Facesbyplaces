// import 'dart:convert';
// import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-03-tokenization.dart';
// import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-04-process-payment.dart';
import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class HomeBLMUserDonate extends StatefulWidget{
  final String pageType;
  final int pageId;
  final String pageName;

  HomeBLMUserDonate({required this.pageType, required this.pageId, required this.pageName});

  HomeBLMUserDonateState createState() => HomeBLMUserDonateState(pageType: pageType, pageId: pageId, pageName: pageName);
}

class HomeBLMUserDonateState extends State<HomeBLMUserDonate>{
  final String pageType;
  final int pageId;
  final String pageName;

  HomeBLMUserDonateState({required this.pageType, required this.pageId, required this.pageName});

  int donateToggle = 0;

  @override
  initState() {
    super.initState();
    // 'pk_test_51Hp23FE1OZN8BRHat4PjzxlWArSwoTP4EYbuPjzgjZEA36wjmPVVT61dVnPvDv0OSks8MgIuALrt9TCzlgfU7lmP005FkfmAik',
    // "pk_test_aSaULNS8cJU6Tvo20VAXy6rp"
    StripePayment.setOptions(StripeOptions(publishableKey: 'pk_test_51Hp23FE1OZN8BRHat4PjzxlWArSwoTP4EYbuPjzgjZEA36wjmPVVT61dVnPvDv0OSks8MgIuALrt9TCzlgfU7lmP005FkfmAik', merchantId: 'merchant.com.app.facesbyplaces', androidPayMode: 'test'));
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
          backgroundColor: Color(0xff888888),
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20,),

                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft, 
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Color(0xff000000),), 
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                      Text('Send a Gift', style: TextStyle(fontSize: 24),),

                      Expanded(child: Container(),)

                    ],
                  ),

                  SizedBox(height: 20,),

                  Expanded(
                    child: GridView.count(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
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
                                  SizedBox(height: 10,),

                                  Image.asset('assets/icons/gift.png', height: 120, width: 120),

                                  SizedBox(height: 10,),

                                  Container(
                                    child: ((){
                                      switch(index){
                                        case 0: return Text('\$0.99', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 1: return Text('\$5.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 2: return Text('\$15.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 3: return Text('\$25.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 4: return Text('\$50.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                        case 5: return Text('\$100.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                                      }
                                    }()),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: index == donateToggle ? 2 : .5, color: index == donateToggle ? Color(0xff70D8FF) : Color(0xff888888),),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  // Image.asset('assets/icons/apple-pay-mark.svg'),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset('assets/icons/apple-pay-mark.svg', semanticsLabel: 'Apple Pay Mark', height: 50, width: 50,),
                  ),

                  MiscBLMButtonTemplate(
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    onPressed: () async{

                      var paymentToken = await StripePayment.paymentRequestWithNativePay(
                        androidPayOptions: AndroidPayPaymentRequest(
                          totalPrice: ((){
                            switch(donateToggle){
                              case 0: return '0.99';
                              case 1: return '5.00';
                              case 2: return '15.00';
                              case 3: return '25.00';
                              case 4: return '50.00';
                              case 5: return '100.00';
                            }
                          }()),
                          currencyCode: 'USD',
                        ),
                        applePayOptions: ApplePayPaymentOptions(
                          countryCode: 'US',
                          currencyCode: 'USD',
                          items: [
                            ApplePayItem(
                              label: '$pageName',
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
                            )
                          ],
                        ),
                      );

                      StripePayment.completeNativePayRequest();
                      double amount = 0.99;

                      if(donateToggle == 0){
                        amount = 0.99;
                      }else if(donateToggle == 1){
                        amount = 5.00;
                      }else if(donateToggle == 2){
                        amount = 15.00;
                      }else if(donateToggle == 3){
                        amount = 25.00;
                      }else if(donateToggle == 4){
                        amount = 50.00;
                      }else if(donateToggle == 5){
                        amount = 100.00;
                      }

                      print('The amount is $amount');

                      context.showLoaderOverlay();
                      bool result = await apiBLMDonate(pageType: pageType, pageId: pageId, amount: amount, token: paymentToken.tokenId);
                      context.hideLoaderOverlay();

                      if(result == true){
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Thank you', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('We appreciate your donation on this Memorial page. This will surely help the family during these times.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
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


                      // String token = await apiBLMTokenization();

                      // // print('The new token is $token');

                      // String amount = '0.99';

                      // if(donateToggle == 0){
                      //   amount = '0.99';
                      // }else if(donateToggle == 1){
                      //   amount = '5.00';
                      // }else if(donateToggle == 2){
                      //   amount = '15.00';
                      // }else if(donateToggle == 3){
                      //   amount = '25.00';
                      // }else if(donateToggle == 4){
                      //   amount = '50.00';
                      // }else if(donateToggle == 5){
                      //   amount = '100.00';
                      // }

                      // var request = BraintreeDropInRequest(
                      //   tokenizationKey: token,
                      //   collectDeviceData: true,
                      //   applePayRequest: BraintreeApplePayRequest(
                      //     countryCode: 'US',
                      //     currencyCode: 'USD',
                      //     appleMerchantID: 'merchant.com.app.facesbyplaces',
                      //     amount: double.parse(amount),
                      //     displayName: 'FacesbyPlaces'
                      //   ),
                      //   googlePaymentRequest: BraintreeGooglePaymentRequest(
                      //     totalPrice: amount,
                      //     currencyCode: 'USD',
                      //     billingAddressRequired: false,
                      //   ),
                      //   paypalRequest: BraintreePayPalRequest(
                      //     amount: ((){
                      //       switch(donateToggle){
                      //         case 0: return '0.99';
                      //         case 1: return '5.00';
                      //         case 2: return '15.00';
                      //         case 3: return '25.00';
                      //         case 4: return '50.00';
                      //         case 5: return '100.00';
                      //       }
                      //     }()),
                      //     displayName: 'Example company',
                      //   ),
                      //   cardEnabled: true,
                      // );

                      // BraintreeDropInResult result = (await BraintreeDropIn.start(request))!;

                      // print('The amount is ${request.paypalRequest!.amount}');
                      // print('The nonce is ${result.paymentMethodNonce.nonce}');
                      // print('The device token is ${result.deviceData}');
                      // print('The description is ${result.paymentMethodNonce.description}');
                      // print('The description is ${result.paymentMethodNonce.isDefault}');
                      // print('The description is ${result.paymentMethodNonce.nonce}');
                      // print('The description is ${result.paymentMethodNonce.typeLabel}');

                      // var newValue = json.decode(result.deviceData!);
                      // var deviceToken = newValue['correlation_id'];

                      // print('The newValue is $newValue');
                      // print('The deviceToken is $deviceToken');

                      // bool paymentResult = await apiBLMProcessToken(amount: request.paypalRequest!.amount!, nonce: result.paymentMethodNonce.nonce, deviceData: deviceToken);

                      // print('The paymentResult is $paymentResult');
                    },
                    height: 45,
                    width: SizeConfig.screenWidth! / 2, 
                  ),

                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}