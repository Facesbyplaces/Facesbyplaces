import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscAppBarTemplate extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appBar;
  final Color backgroundColor;
  final Widget leadingIcon;
  final Function leadingAction;
  final Widget title;
  final List<Widget> actions;

  MiscAppBarTemplate({
    this.appBar,
    this.backgroundColor = const Color(0xff04ECFF),
    this.leadingIcon = const Icon(Icons.arrow_back, color: Color(0xffffffff),),
    this.leadingAction,
    this.title = const Text('Cry out for the Victims', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),
    this.actions,
  });
  

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return AppBar(
      leading: IconButton(
        icon: leadingIcon,
        onPressed: leadingAction,
      ),
      title: title,
      backgroundColor: backgroundColor,
      actions: actions,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}