import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class HomeRegularUserDonate extends StatefulWidget{

  HomeRegularUserDonateState createState() => HomeRegularUserDonateState();
}

class HomeRegularUserDonateState extends State<HomeRegularUserDonate>{

  int donateToggle;
  Token paymentToken;

  @override
  initState() {
    super.initState();
    donateToggle = 0;
    StripePayment.setOptions(StripeOptions(publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp", merchantId: "merchant.com.app.facesbyplaces", androidPayMode: 'test'));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
                  SizedBox(height: ScreenUtil().setHeight(20)),

                  Row(
                    children: [
                      Expanded(child: Align(alignment: Alignment.centerLeft, child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xff000000),), onPressed: (){Navigator.pop(context);},)),),

                      Text('Send a Gift', style: TextStyle(fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),),),

                      Expanded(child: Container(),)
                    ],
                  ),

                  SizedBox(height: ScreenUtil().setHeight(20)),

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
                                  SizedBox(height: ScreenUtil().setHeight(10)),

                                  Expanded(child: Image.asset('assets/icons/gift.png'),),

                                  SizedBox(height: ScreenUtil().setHeight(10)),

                                  ((){
                                    switch(index){
                                      case 0: return Text('\$0.99', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
                                      case 1: return Text('\$5.00', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
                                      case 2: return Text('\$15.00', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
                                      case 3: return Text('\$25.00', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
                                      case 4: return Text('\$50.00', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
                                      case 5: return Text('\$100.00', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold),); break;
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

                  SizedBox(height: ScreenUtil().setHeight(20)),

                  MiscRegularButtonTemplate(
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    buttonTextStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ), 
                    onPressed: () async{
                      // if (Platform.isIOS) {
                      //   _controller.jumpTo(450);
                      // }


                        // double amount;


                        // switch(donateToggle){
                        //   case 0: return amount = 0.99; break;
                        //   case 1: return amount = 5.00; break;
                        //   case 2: return amount =15.00; break;
                        //   case 3: return amount =25.00; break;
                        //   case 4: return amount =50.00; break;
                        //   case 5: return amount =100.00; break;
                        // }

                        // print('The amount is $amount');

                      paymentToken = await StripePayment.paymentRequestWithNativePay(
                        androidPayOptions: AndroidPayPaymentRequest(
                          totalPrice: ((){
                            switch(donateToggle){
                              case 0: return '0.99'; break;
                              case 1: return '5.00'; break;
                              case 2: return '15.00'; break;
                              case 3: return '25.00'; break;
                              case 4: return '50.00'; break;
                              case 5: return '100.00'; break;
                            }
                          }()),
                          currencyCode: 'USD',
                        ),
                        applePayOptions: ApplePayPaymentOptions(
                          countryCode: 'US',
                          currencyCode: 'USD',
                          items: [
                            ApplePayItem(
                              label: 'Donation',
                              amount: ((){
                                switch(donateToggle){
                                  case 0: return '0.99'; break;
                                  case 1: return '5.00'; break;
                                  case 2: return '15.00'; break;
                                  case 3: return '25.00'; break;
                                  case 4: return '50.00'; break;
                                  case 5: return '100.00'; break;
                                }
                              }()),
                            )
                          ],
                        ),
                      );

                      print('The token is $paymentToken');
                      print('The token is ${paymentToken.tokenId}');

                      StripePayment.completeNativePayRequest();


                      // .catchError();



                      // =================================================================================================================================


                      
                        // Future<String> get receiptPayment async {
                        //   /* custom receipt w/ useReceiptNativePay */
                        //   const receipt = <String, double>{"Nice Hat": 5.00, "Used Hat" : 1.50};
                        //   var aReceipt = Receipt(receipt, "Hat Store");
                        //   return await StripeNative.useReceiptNativePay(aReceipt);
                        // }








                      // =================================================================================================================================

                      // FlutterPay flutterPay = FlutterPay();

                      // bool isAvailable = await flutterPay.canMakePayments();

                      // if(isAvailable == true){
                      //   flutterPay.setEnvironment(
                      //     environment: PaymentEnvironment.Production,
                      //   );

                      //   PaymentItem item = PaymentItem(
                      //     name: 'Donation', 
                      //     price: ((){
                      //       switch(donateToggle){
                      //         case 0: return 0.99; break;
                      //         case 1: return 5.00; break;
                      //         case 2: return 15.00; break;
                      //         case 3: return 25.00; break;
                      //         case 4: return 50.00; break;
                      //         case 5: return 100.00; break;
                      //       }
                      //     }()),
                      //   );

                      //   String token = await flutterPay.makePayment(
                      //     merchantIdentifier: 'merchant.com.app.facesbyplaces',
                      //     currencyCode: 'USD',
                      //     countryCode: 'US',
                      //     allowedPaymentNetworks: [
                      //       PaymentNetwork.visa, 
                      //       PaymentNetwork.masterCard,
                      //     ],
                      //     paymentItems: [item],
                      //     merchantName: 'FacesbyPlaces', 
                      //     gatewayName: 'Stripe',
                      //   );

                      //   print('The token is $token');

                      // }

                    }, 
                    width: SizeConfig.screenWidth / 2, 
                    height: ScreenUtil().setHeight(45),
                  ),

                  SizedBox(height: ScreenUtil().setHeight(20)),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}