import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget{
  const RegularJoin();

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint){
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: const AssetImage('assets/icons/All Lives Matter.png'),),),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: const Color(0xffFFFFFF), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        const SizedBox(height: 50,),
                        
                        Container(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),

                        const SizedBox(height: 50,),

                        Expanded(child: Container()),

                        Center(child: const Text('All Lives Matter', style: const TextStyle(fontSize: 42, color: const Color(0xffffffff), fontFamily: 'NexaBold',),),),

                        const SizedBox(height: 50,),

                        MiscRegularButtonTemplate(
                          buttonText: 'Next',
                          buttonTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                          width: SizeConfig.screenWidth! / 1.8,
                          height: 50,
                          buttonColor: const Color(0xff04ECFF),
                          onPressed: (){
                            Navigator.pushNamed(context, '/regular/login');
                          },
                        ),

                        const SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}