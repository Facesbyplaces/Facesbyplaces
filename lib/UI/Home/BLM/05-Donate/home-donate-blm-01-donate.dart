import 'package:facesbyplaces/API/BLM/06-Donate/api-donate-blm-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMUserDonate extends StatefulWidget{
  final String pageType;
  final int pageId;

  HomeBLMUserDonate({this.pageType, this.pageId});

  HomeBLMUserDonateState createState() => HomeBLMUserDonateState(pageType: pageType, pageId: pageId);
}

class HomeBLMUserDonateState extends State<HomeBLMUserDonate>{
  final String pageType;
  final int pageId;

  HomeBLMUserDonateState({this.pageType, this.pageId});

  int donateToggle;
  Token paymentToken;

  @override
  initState() {
    super.initState();
    donateToggle = 0;
    StripePayment.setOptions(StripeOptions(
      publishableKey: "pk_test_51Hp23FE1OZN8BRHat4PjzxlWArSwoTP4EYbuPjzgjZEA36wjmPVVT61dVnPvDv0OSks8MgIuALrt9TCzlgfU7lmP005FkfmAik", 
      merchantId: "merchant.com.app.facesbyplaces", 
      androidPayMode: 'test'));
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
                              setState(() {
                                donateToggle = index;
                              });
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

                  MiscBLMButtonTemplate(
                    buttonColor: Color(0xff4EC9D4),
                    buttonText: 'Send Gift',
                    onPressed: () async{
                      

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

                      StripePayment.completeNativePayRequest();
                      double amount;

                      switch(donateToggle){
                        case 0: amount = 0.99; break;
                        case 1: amount = 5.00; break;
                        case 2: amount = 15.00; break;
                        case 3: amount = 25.00; break;
                        case 4: amount = 50.00; break;
                        case 5: amount = 100.00; break;
                      }

                      context.showLoaderOverlay();
                      bool result = await apiBLMDonate(pageType: pageType, pageId: pageId, amount: amount, token: paymentToken.tokenId);
                      context.hideLoaderOverlay();

                      if(result == true){
                        showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Thank you', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.BOTTOM_RIGHT,
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