
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';

class HomeRegularUserDonate extends StatefulWidget{

  HomeRegularUserDonateState createState() => HomeRegularUserDonateState();
}

class HomeRegularUserDonateState extends State<HomeRegularUserDonate>{

  int donateToggle;

  @override
  initState() {
    super.initState();
    donateToggle = 0;
    StripePayment.setOptions(StripeOptions(publishableKey: "pk_test_51Hp23FE1OZN8BRHat4PjzxlWArSwoTP4EYbuPjzgjZEA36wjmPVVT61dVnPvDv0OSks8MgIuALrt9TCzlgfU7lmP005FkfmAik", merchantId: "Test", androidPayMode: 'test'));
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Row(
                    children: [
                      Expanded(child: Align(alignment: Alignment.centerLeft, child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xff000000),), onPressed: (){Navigator.pop(context);},)),),

                      Text('Send a Gift', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 6),),

                      Expanded(child: Container(),)

                    ],
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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
                              
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Image.asset('assets/icons/gift.png', height: SizeConfig.blockSizeVertical * 15, width: SizeConfig.blockSizeVertical * 15),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  ((){
                                    switch(index){
                                      case 0: return Text('\$0.99', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                      case 1: return Text('\$5.00', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                      case 2: return Text('\$15.00', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                      case 3: return Text('\$25.00', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                      case 4: return Text('\$50.00', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                      case 5: return Text('\$100.00', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold),); break;
                                    }
                                  }()),
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

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  MiscRegularButtonTemplate(
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    onPressed: () async{

                      FlutterPay flutterPay = FlutterPay();



                      

                      bool isAvailable = await flutterPay.canMakePayments();

                      print('The value is $isAvailable');

                      flutterPay.setEnvironment(
                        environment: PaymentEnvironment.Production,
                      );

                      PaymentItem item = PaymentItem(
                        name: 'Donation', 
                        price: ((){
                          switch(donateToggle){
                            case 0: return 0.99; break;
                            case 1: return 5.00; break;
                            case 2: return 15.00; break;
                            case 3: return 25.00; break;
                            case 4: return 50.00; break;
                            case 5: return 100.00; break;
                          }
                        }()),
                      );

                      String token = await flutterPay.makePayment(
                        merchantIdentifier: 'merchant.com.app.facesbyplaces',
                        currencyCode: 'USD',
                        countryCode: 'US',
                        allowedPaymentNetworks: [
                          PaymentNetwork.visa, 
                          PaymentNetwork.masterCard,
                        ],
                        paymentItems: [item],
                        merchantName: 'FacesbyPlaces', 
                        gatewayName: 'Stripe',
                      );

                      print('The token is $token');

                    }, 
                    width: SizeConfig.screenWidth / 2, 
                    height: SizeConfig.blockSizeVertical * 7,
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}