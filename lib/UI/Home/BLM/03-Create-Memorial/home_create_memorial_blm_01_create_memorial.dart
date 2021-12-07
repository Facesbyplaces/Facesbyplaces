import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'home_create_memorial_blm_02_create_memorial.dart';
import 'home_create_memorial_blm_04_locate_map.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeBLMCreateMemorial1 extends StatefulWidget{
  const HomeBLMCreateMemorial1({Key? key}) : super(key: key);

  @override
  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1>{
  final GlobalKey<MiscInputFieldDropDownState> _key1 = GlobalKey<MiscInputFieldDropDownState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key3 = GlobalKey<MiscInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  ValueNotifier<LatLng?> location = ValueNotifier(null);
  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
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
        child: ValueListenableBuilder(
          valueListenable: location,
          builder: (_, LatLng? locationListener, __) => Scaffold(
            appBar: AppBar(
              title: const Text('Cry out for the Victim', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        MiscInputFieldDropDown(key: _key1,),

                        const SizedBox(height: 20,),

                        TextFormField(
                          controller: controller1,
                          style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                          cursorColor: const Color(0xff000000),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          onChanged: (value){
                            if(value == ''){
                              location.value = null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Location of the incident',
                            labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                            alignLabelWithHint: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add_location),
                              onPressed: () async{
                                var memorialLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeBLMCreateMemorialLocateMap()));

                                if(memorialLocation != null){
                                  if(memorialLocation.runtimeType == String){ // CHECKS IF THE USER OPTS OUT OF PINNING ON THE MAPS SCREEN
                                    controller1.text = memorialLocation;
                                    location.value = null; // REMOVES THE LISTENER
                                  }else{
                                    location.value = memorialLocation[0];
                                    controller1.text = memorialLocation[1];
                                  }
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        TextFormField(
                          controller: controller2,
                          cursorColor: const Color(0xff000000),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                          validator: (value){
                            if(value!.isEmpty){
                              return '';
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                            alignLabelWithHint: true,
                            labelText: 'RIP',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close), 
                              onPressed: (){
                                controller2.text = '';
                                rip = DateTime.now();
                              },
                            ),
                          ),
                          onTap: () async{
                            await showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => SafeArea(
                                top: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text('Unsure?'),
                                      leading: const Icon(MdiIcons.headQuestion),
                                      onTap: () async{
                                        controller2.text = 'Unknown';
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Show Calendar'),
                                      leading: const Icon(Icons.calendar_today),
                                      onTap: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: dob,
                                          maxTime: DateTime.now(),
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en,
                                          onConfirm: (date){
                                            String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                            rip = date;
                                            controller2.text = format;
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20,),

                        MiscInputFieldTemplate(
                          key: _key2, 
                          labelText: 'Country',
                        ),

                        const SizedBox(height: 20,),

                        MiscInputFieldTemplate(
                          key: _key3, 
                          labelText: 'State',
                        ),

                        const SizedBox(height: 100,),

                        MiscButtonTemplate(
                          buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),
                          width: SizeConfig.screenWidth! / 2,
                          height: 50,
                          onPressed: () async{
                            if(!(_formKey.currentState!.validate())){
                              await showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: 'Error',
                                  description: 'Please complete the form before submitting.',
                                  okButtonColor: const Color(0xfff44336), // RED
                                  includeOkButton: true,
                                ),
                              );
                            }else if(controller1.text == '' && locationListener == null){
                              await showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: 'Error',
                                  description: 'You can pin the location of the cemetery or put Unknown if you are unsure.',
                                  okButtonColor: const Color(0xfff44336), // RED
                                  includeOkButton: true,
                                ),
                              );
                            }else{
                              if(controller1.text != '' && locationListener == null){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreateMemorial2(relationship: _key1.currentState!.currentSelection, locationOfIncident: controller1.text, rip: controller2.text, country: _key2.currentState!.controller.text, state: _key3.currentState!.controller.text, latitude: '0.0', longitude: '0.0',),),);
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreateMemorial2(relationship: _key1.currentState!.currentSelection, locationOfIncident: controller1.text, rip: controller2.text, country: _key2.currentState!.controller.text, state: _key3.currentState!.controller.text, latitude: '${location.value!.latitude}', longitude: '${location.value!.longitude}',),),);
                              }
                            }
                          },
                        ),

                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}