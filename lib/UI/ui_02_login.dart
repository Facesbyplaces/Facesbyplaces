import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget{
  const UILogin01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint){
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Align(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),

                        Image.asset('assets/icons/logo.png', height: 150, width: 150,),

                        const SizedBox(height: 30,),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text('Keeping the legacy and memories of family and friends alive', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),
                        ),

                        const SizedBox(height: 50,),

                        const Text('Black Lives Matter', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 10,),

                        MaterialButton(
                          padding: EdgeInsets.zero,
                          color: const Color(0xff000000),
                          // child: const Icon(Icons.search, size: 80, color: Color(0xffffffff),),
                          child: Image.asset('assets/icons/fist.png', height: 80, width: 80),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: (){
                            // Navigator.pushNamed(context, '/blm/join');
                            Navigator.pushNamed(context, '/blm/login');
                          },
                        ),

                        const SizedBox(height: 10,),

                        const Text('Memorial', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 30,),

                        const Text('All Lives Matter', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 10,),

                        MaterialButton(
                          padding: EdgeInsets.zero,
                          color: const Color(0xff04ECFF),
                          child: const Icon(Icons.favorite, size: 80, color: Color(0xffffffff),),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: (){
                            // Navigator.pushReplacementNamed(context, '/home/regular');
                            Navigator.pushNamed(context, '/regular/login');
                          },
                        ),

                        const SizedBox(height: 10,),

                        const Text('Memorial', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),
                        
                        const Expanded(child: SizedBox()),

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