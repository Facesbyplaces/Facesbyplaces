import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeMemorialSettings extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeUpdateMemorialToggle>(
          create: (context) => BlocHomeUpdateMemorialToggle(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text('Memorial Settings',
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: Color(0xffffffff),
            ),
          ),
          backgroundColor: Color(0xff04ECFF), 
        ),
        body: Column(
          children: [
            Container(
              color: Color(0xffECF0F1),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: MiscMemorialSettings(),
            ),

            Expanded(
              child: BlocBuilder<BlocHomeUpdateMemorialToggle, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeMemorialSettingsPage(); break;
                      case 1: return HomeMemorialSettingsPrivacy(); break;
                    }
                  }());
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class HomeMemorialSettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, 'home/home-11-page-details');
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 10,
            color: Color(0xffffffff),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Page Details',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Update page details',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffBDC3C7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, 'home/home-07-03-create-memorial');
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 10,
            color: Color(0xffffffff),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Page Image',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Update Page image and background image',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffBDC3C7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Admins',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Add or remove admins of this page',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDC3C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Family',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Add or remove family of this page',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDC3C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Friends',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Add or remove friends of this page',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDC3C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Paypal',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Manage cards that receives the memorial gifts.',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDC3C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        GestureDetector(
          onTap: () async{
            await showDialog(context: (context), builder: (build) => DeletePageDialog());
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 10,
            color: Color(0xffffffff),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Delete Page',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('Completely remove the page. This is irreversible',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffBDC3C7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          child: Image.asset('assets/icons/logo.png'),
        ),

      ],
    );
  }
}

class HomeMemorialSettingsPrivacy extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Customize shown info',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Customize what others see on your page',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDC3C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Hide Family',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Show or hide family details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MiscToggleSwitch(),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Hide Friends',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Show or hide friends details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MiscToggleSwitch(),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Hide Followers',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Show or hide your followers',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: MiscToggleSwitch(),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          child: Image.asset('assets/icons/logo.png'),
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

      ],
    );

    // return Stack(
    //   children: [
    //     Container(
    //       height: SizeConfig.screenHeight,
    //       color: Color(0xffffffff),
    //     ),
            
    //     ListView(
    //       shrinkWrap: true,
    //       children: [

    //         Container(
    //           height: SizeConfig.blockSizeVertical * 10,
    //           color: Color(0xffffffff),
    //           padding: EdgeInsets.only(left: 20.0, right: 20.0),
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 child: Align(
    //                   alignment: Alignment.bottomLeft,
    //                   child: Text('Customize shown info',
    //                     style: TextStyle(
    //                       fontSize: SizeConfig.safeBlockHorizontal * 4,
    //                       fontWeight: FontWeight.bold,
    //                       color: Color(0xff000000),
    //                     ),
    //                   ),
    //                 ),
    //               ),

    //               Expanded(
    //                 child: Align(
    //                   alignment: Alignment.topLeft,
    //                   child: Text('Customize what others see on your page',
    //                     style: TextStyle(
    //                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
    //                       fontWeight: FontWeight.w300,
    //                       color: Color(0xffBDC3C7),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),

    //         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

    //         Container(
    //           height: SizeConfig.blockSizeVertical * 10,
    //           color: Color(0xffffffff),
    //           padding: EdgeInsets.only(left: 20.0),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 flex: 2,
    //                 child: Column(
    //                   children: [
    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.bottomLeft,
    //                         child: Text('Hide Family',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 4,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color(0xff000000),
    //                           ),
    //                         ),
    //                       ),
    //                     ),

    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.topLeft,
    //                         child: Text('Show or hide family details',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 3.5,
    //                             fontWeight: FontWeight.w300,
    //                             color: Color(0xffBDC3C7),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MiscToggleSwitch(),
    //               ),
    //             ],
    //           ),
    //         ),

    //         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

    //         Container(
    //           height: SizeConfig.blockSizeVertical * 10,
    //           color: Color(0xffffffff),
    //           padding: EdgeInsets.only(left: 20.0),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 flex: 2,
    //                 child: Column(
    //                   children: [
    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.bottomLeft,
    //                         child: Text('Hide Friends',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 4,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color(0xff000000),
    //                           ),
    //                         ),
    //                       ),
    //                     ),

    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.topLeft,
    //                         child: Text('Show or hide friends details',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 3.5,
    //                             fontWeight: FontWeight.w300,
    //                             color: Color(0xffBDC3C7),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MiscToggleSwitch(),
    //               ),
    //             ],
    //           ),
    //         ),

    //         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

    //         Container(
    //           height: SizeConfig.blockSizeVertical * 10,
    //           color: Color(0xffffffff),
    //           padding: EdgeInsets.only(left: 20.0),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 flex: 2,
    //                 child: Column(
    //                   children: [
    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.bottomLeft,
    //                         child: Text('Hide Followers',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 4,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color(0xff000000),
    //                           ),
    //                         ),
    //                       ),
    //                     ),

    //                     Expanded(
    //                       child: Align(
    //                         alignment: Alignment.topLeft,
    //                         child: Text('Show or hide your followers',
    //                           style: TextStyle(
    //                             fontSize: SizeConfig.safeBlockHorizontal * 3.5,
    //                             fontWeight: FontWeight.w300,
    //                             color: Color(0xffBDC3C7),
    //                           ),
    //                         ),
    //                       ),
    //                     ),

    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: MiscToggleSwitch(),
    //               ),
    //             ],
    //           ),
    //         ),

    //         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

    //         SizedBox(height: SizeConfig.blockSizeVertical * 5,),

    //         Container(
    //           height: SizeConfig.blockSizeVertical * 10,
    //           child: Image.asset('assets/icons/logo.png'),
    //         ),

    //         SizedBox(height: SizeConfig.blockSizeVertical * 5,),

    //       ],
    //     ),
    //   ],
    // );
  }
}