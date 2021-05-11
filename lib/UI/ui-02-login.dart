import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget {
  const UILogin01();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical! * 5),
              Image.asset(
                'assets/icons/logo.png',
                height: 200,
                width: 200,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              const Text(
                'FacesByPlaces.com',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff2F353D),
                    fontFamily: 'NexaBold'),
              ),
              Spacer(),
              const Text(
                'Honor, Respect, Never Forget',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NexaBold',
                  fontSize: 18,
                  color: const Color(0xff000000),
                ),
              ),
              Spacer(),
              Text(
                'Black Lives Matter',
                style: const TextStyle(
                    fontSize: 18,
                    color: const Color(0xff000000),
                    fontFamily: 'NexaRegular'),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal! * 3,
                    right: SizeConfig.blockSizeHorizontal! * 3),
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: SizeConfig.screenWidth! / 1.5,
                  height: 35,
                  child: Row(
                    children: [
                      CircleAvatar(
                        minRadius: 35,
                        backgroundColor: const Color(0xff000000),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/fist.png',
                            height: SizeConfig.blockSizeVertical! * 10,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal! * 8,
                            right: SizeConfig.blockSizeHorizontal! * 17,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Speak for a loved one killed by law enforcement',
                            style: const TextStyle(
                                fontSize: 18,
                                color: const Color(0xff2F353D),
                                fontFamily: 'NexaRegular'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  shape: const StadiumBorder(),
                  color: const Color(0xffF2F2F2),
                  onPressed: () {
                    Navigator.pushNamed(context, '/blm/join');
                  },
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              const Text(
                'All Lives Matter',
                style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff000000),
                    fontFamily: 'NexaRegular'),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal! * 3,
                    right: SizeConfig.blockSizeHorizontal! * 3),
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: SizeConfig.screenWidth! / 1.5,
                  height: 35,
                  child: Row(
                    children: [
                      CircleAvatar(
                        minRadius: 35,
                        backgroundColor: const Color(0xff04ECFF),
                        child: Icon(
                          Icons.favorite,
                          size: 50,
                          color: const Color(0xffffffff),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal! * 8,
                            right: SizeConfig.blockSizeHorizontal! * 17,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Remembering friends and family',
                            style: const TextStyle(
                                fontSize: 18,
                                color: const Color(0xff2F353D),
                                fontFamily: 'NexaRegular'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  shape: const StadiumBorder(),
                  color: const Color(0xffE6FDFF),
                  onPressed: () {
                    Navigator.pushNamed(context, '/regular/join');
                  },
                ),
              ),
              Spacer(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: const Color(0xff000000),
                        fontFamily: 'NexaRegular'
                      ),
                    ),
                    TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          fontSize: 16,
                          color: const Color(0xff04ECFF),
                            fontFamily: 'NexaRegular'
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/regular/login');
                          }),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
