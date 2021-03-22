import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
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