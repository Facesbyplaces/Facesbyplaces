import 'package:facesbyplaces/API/Regular/06-Donate/api-donate-regular-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

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

                                  Expanded(child: Image.asset('assets/icons/gift.png'),),

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

                  CardField(
                    onCardChanged: (card){
                      newCard = card;
                    },
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

                      // await Stripe.instance.createPaymentMethod(data)

                      // print('The newCard is $newCard');

                      context.loaderOverlay.show();

                      PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(
                        PaymentMethodParams.card(
                          billingDetails: BillingDetails.fromJson(newCard!.toJson())
                        ),
                      );

                      print('The paymentMethod is $paymentMethod');
                      print('The paymentMethod id is ${paymentMethod.id}');

                      String clientSecret = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: paymentMethod.id);
                      // String clientSecret = await apiRegularDonate(pageType: widget.pageType, pageId: widget.pageId, amount: double.parse(amount), paymentMethod: 'pi_1J2q2tE1OZN8BRHaqwBeXkRX_secret_cGw2FpCgRheuZIdO31epdzOdn');

                      PaymentIntent confirmPaymentMethod = await Stripe.instance.confirmPaymentMethod(clientSecret, PaymentMethodParams.card(
                          billingDetails: BillingDetails.fromJson(newCard!.toJson())
                        ),
                      );

                      print('The confirmPaymentMethod is $confirmPaymentMethod');

                      context.loaderOverlay.hide();

                      // print('The confirmPaymentMethod is $confirmPaymentMethod');
                      // print('The confirmPaymentMethod is ${confirmPaymentMethod.clientSecret}');

                      

                      // Stripe.instance.confirmPaymentMethod(, data)
                      
                      // final paymentIntent = await Stripe.instance.retrievePaymentIntent('sk_test_51Hp23FE1OZN8BRHaFUWRZXzsf6p20xlgnqnEKIspzG6CWRpZ2t8TEpY9zXo7tKB0m6z263qSDfcLQ4r6EYWoJfi100BzfylDfs');
                      // print('The paymentIntent is $paymentIntent');


                      // print('The paymentIntent is ${paymentIntent.}');


                      // final cardAction = await Stripe.instance.handleCardAction(

                      // );

                      // print('start');

                      // await Stripe.instance.initPaymentSheet(
                      //   paymentSheetParameters: SetupPaymentSheetParameters(
                      //     applePay: true,
                      //     googlePay: true,
                      //     style: ThemeMode.dark,
                      //     testEnv: true,
                      //     merchantCountryCode: 'US',
                      //     merchantDisplayName: 'Flutter Stripe Store Demo',
                      //     customerId: '',
                      //     paymentIntentClientSecret: '',
                      //     customerEphemeralKeySecret: '',
                      //   ),
                      // ).onError((error, stackTrace) => print('The error is $error'));

                      // print('1');

                      // await Stripe.instance.presentPaymentSheet(
                      //   parameters: PresentPaymentSheetParameters(clientSecret: 'sk_test_51Hp23FE1OZN8BRHaFUWRZXzsf6p20xlgnqnEKIspzG6CWRpZ2t8TEpY9zXo7tKB0m6z263qSDfcLQ4r6EYWoJfi100BzfylDfs'),
                      // ).onError((error, stackTrace) => print('The error is $error'));

                      // print('2');

                      // await Stripe.instance.confirmPaymentSheetPayment();

                      // print('3');

                      // print('done');

                      // await Stripe.instance.initPaymentSheet(
                      //   paymentSheetParameters: SetupPaymentSheetParameters(
                      //     applePay: true,
                      //     googlePay: true,
                      //     style: ThemeMode.dark,
                      //     testEnv: true,
                      //     merchantCountryCode: 'US',
                      //     merchantDisplayName: 'Flutter Stripe Store Demo',
                      //     customerId: '',
                      //     paymentIntentClientSecret: '',
                      //     customerEphemeralKeySecret: '',
                      //   ),
                      // );

                      // await Stripe.instance.presentPaymentSheet(
                      //   parameters: PresentPaymentSheetParameters(

                      //   ),
                      // );

                      // await Stripe.instance.presentApplePay(
                      //   ApplePayPresentParams(
                      //     cartItems: [
                      //       ApplePayCartSummaryItem(
                      //         label: 'Product Test',
                      //         amount: amount,
                      //       ),
                      //     ],
                      //     country: 'US',
                      //     currency: 'USD',
                      //   ),
                      // );


                      // await Stripe.instance.presentApplePay(
                      //   ApplePayPresentParams(
                      //     cartItems: [
                      //       ApplePayCartSummaryItem(
                      //         label: 'Product Test',
                      //         amount: amount,
                      //       ),
                      //     ],
                      //     country: 'US',
                      //     currency: 'USD',
                      //   ),
                      // );

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