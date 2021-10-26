import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';

class RegularJoin extends StatelessWidget{
  const RegularJoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint){
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/All Lives Matter.png'),),),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xffFFFFFF), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        const SizedBox(height: 50,),
                        
                        SizedBox(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),

                        const SizedBox(height: 50,),

                        const Expanded(child: SizedBox()),

                        const Center(child: Text('All Lives Matter', style: TextStyle(fontSize: 42, color: Color(0xffffffff), fontFamily: 'NexaBold',),),),

                        const SizedBox(height: 50,),

                        MiscButtonTemplate(
                          buttonText: 'Next',
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
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