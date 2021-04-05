import 'dart:convert';

import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-03-tokenization.dart';
import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-04-process-payment.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter/material.dart';

class HomeBLMUserDonate extends StatefulWidget{
  final String pageType;
  final int pageId;

  HomeBLMUserDonate({required this.pageType, required this.pageId});

  HomeBLMUserDonateState createState() => HomeBLMUserDonateState(pageType: pageType, pageId: pageId);
}

class HomeBLMUserDonateState extends State<HomeBLMUserDonate>{
  final String pageType;
  final int pageId;

  HomeBLMUserDonateState({required this.pageType, required this.pageId});

  int donateToggle = 0;

  @override
  initState() {
    super.initState();
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

                  MiscBLMButtonTemplate(
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    onPressed: () async{

                      String token = await apiBLMTokenization();

                      // print('The new token is $token');

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
                      print('The device token is ${result.deviceData}');
                      print('The description is ${result.paymentMethodNonce.description}');
                      print('The description is ${result.paymentMethodNonce.isDefault}');
                      print('The description is ${result.paymentMethodNonce.nonce}');
                      print('The description is ${result.paymentMethodNonce.typeLabel}');

                      var newValue = json.decode(result.deviceData!);
                      var deviceToken = newValue['correlation_id'];

                      print('The newValue is $newValue');
                      print('The deviceToken is $deviceToken');

                      bool paymentResult = await apiBLMProcessToken(amount: request.paypalRequest!.amount!, nonce: result.paymentMethodNonce.nonce, deviceData: deviceToken);

                      print('The paymentResult is $paymentResult');
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