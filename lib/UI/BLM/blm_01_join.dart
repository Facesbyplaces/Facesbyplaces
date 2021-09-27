import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';

class BLMJoin extends StatelessWidget{
  const BLMJoin({Key? key}) : super(key: key);

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
                  decoration: const BoxDecoration(color: Color(0xffffffff), image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icons/background2.png', ), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Spacer(),

                              const Text('BLACK', style: TextStyle(fontSize: 32, color: Color(0xff000000), fontFamily: 'NexaBold',),),

                              const SizedBox(width: 20,),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.center,
                                child: const Text('LIVES', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xffffffff), fontFamily: 'NexaBold',),),
                                decoration: const BoxDecoration(color: Color(0xff000000), borderRadius: BorderRadius.all(Radius.circular(10),),),
                              ),

                              const SizedBox(width: 20,),

                              const Text('MATTER', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff000000), fontFamily: 'NexaBold',),),

                              const Spacer(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        SizedBox(width: SizeConfig.screenWidth, height: 600, child: Image.asset('assets/icons/BLM Matter.png', fit: BoxFit.cover,),),

                        const SizedBox(height: 20,),

                        const Text('Remembering the Victims', style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                        const SizedBox(height: 20,),

                        MiscButtonTemplate(
                          buttonText: 'Join',
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                          width: SizeConfig.screenWidth! / 1.8,
                          height: 50,
                          buttonColor: const Color(0xff4EC9D4),
                          onPressed: (){
                            Navigator.pushNamed(context, '/blm/login');
                          },
                        ),

                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}