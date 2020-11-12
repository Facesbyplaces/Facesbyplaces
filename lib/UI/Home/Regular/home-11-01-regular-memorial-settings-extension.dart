import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-16-regular-setting-detail.dart';
import 'package:facesbyplaces/API/Regular/api-05-regular-delete-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularMemorialSettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocShowLoading, bool>(
      builder: (context, loading){
        return ((){
          switch(loading){
            case false: return ListView(
              physics: ClampingScrollPhysics(),
              children: [

                MiscRegularSettingDetailTemplate(
                  onTap: (){
                    Navigator.pushNamed(context, 'home/regular/home-12-regular-page-details');
                  },
                ),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(
                  onTap: (){
                    Navigator.pushNamed(context, '/home/regular/home-04-03-regular-create-memorial');
                  }, 
                  titleDetail: 'Page Image', 
                  contentDetail: 'Update Page image and background image',
                ),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(onTap: (){}, titleDetail: 'Admins', contentDetail: 'Add or remove admins of this page'),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(onTap: (){}, titleDetail: 'Family', contentDetail: 'Add or remove family of this page'),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(onTap: (){}, titleDetail: 'Friends', contentDetail: 'Add or remove friends of this page'),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(onTap: (){}, titleDetail: 'Paypal', contentDetail: 'Manage cards that receives the memorial gifts.'),

                Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                MiscRegularSettingDetailTemplate(
                  onTap: () async{
                    bool deleteResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(),);

                    if(deleteResult){
                      context.bloc<BlocShowLoading>().modify(true);
                      bool result = await apiRegularDeleteMemorial();
                      context.bloc<BlocShowLoading>().modify(false);

                      if(result){
                        Navigator.popAndPushNamed(context, '/home/regular');
                      }else{
                        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                      }
                    }

                  }, 
                  titleDetail: 'Delete Page', 
                  contentDetail: 'Completely remove the page. This is irreversible',
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

              ],
            ); break;
            case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),); break; 
          }
        }());
      },
    );
  }
}