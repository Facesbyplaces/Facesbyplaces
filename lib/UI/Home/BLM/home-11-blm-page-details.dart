import 'package:facesbyplaces/API/BLM/api-08-blm-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMPageDetails extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),)
          ],
          child: BlocBuilder<BlocShowLoading, bool>(
            builder: (context, loading){
              return ((){
                switch(loading){
                  case false: return Scaffold(
                    appBar: MiscBLMAppBarTemplate(
                      appBar: AppBar(), 
                      title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
                      leadingAction: (){Navigator.pop(context);},
                      actions: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/home/blm/home-09-blm-memorial-settings');
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0), 
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: Stack(
                      children: [

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            children: [

                              MiscBLMInputFieldTemplate(key: _key1, labelText: 'Page Name'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscBLMInputFieldTemplate(key: _key2, labelText: 'Relationship'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscBLMInputFieldTemplate(key: _key3, labelText: 'DOB'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscBLMInputFieldTemplate(key: _key4, labelText: 'RIP'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscBLMInputFieldTemplate(key: _key5, labelText: 'DOB'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscBLMInputFieldTemplate(key: _key6, labelText: 'Cemetery'),

                              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                              MiscBLMButtonTemplate(
                                buttonText: 'Update', 
                                buttonTextStyle: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xffffffff),
                                ),
                                onPressed: () async{

                                  context.bloc<BlocShowLoading>().modify(true);
                                  bool result = await apiBLMHomeUpdatePageDetails();
                                  context.bloc<BlocShowLoading>().modify(false);

                                  if(result){
                                    Navigator.popUntil(context, ModalRoute.withName('/home/blm/home-09-blm-memorial-settings'));
                                  }else{
                                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                  }
                                }, 
                                width: SizeConfig.screenWidth / 2, 
                                height: SizeConfig.blockSizeVertical * 7, 
                                buttonColor: Color(0xff04ECFF),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ); break;
                  case true: return Scaffold(body: Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)),); break;
                }
              }());
            }
          )
        ),
      ),
    );
  }
}