import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-blm-02-create-memorial.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMCreateMemorialValues {
  final String blmName;
  final String description;
  final String location;
  final String dob;
  final String rip;
  final String state;
  final String country;
  final String precinct;
  final String relationship;
  final List<File> imagesOrVideos;
  final double longitude;
  final double latitude;

  const BLMCreateMemorialValues({required this.blmName, required this.description, required this.location, required this.dob, required this.rip, required this.state, required this.country, required this.precinct, required this.relationship, required this.imagesOrVideos, required this.latitude, required this.longitude,});
}

class HomeBLMCreateMemorial1 extends StatefulWidget {
  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1> {
  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cry out for the Victims',
                maxLines: 2,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 3.16,
                    fontFamily: 'NexaRegular',
                    color: const Color(0xffffffff))),
            centerTitle: true,
            backgroundColor: const Color(0xff04ECFF),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xffffffff),
                size: SizeConfig.blockSizeVertical! * 3.52,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: SizeConfig.screenHeight,
                  child: const MiscBLMBackgroundTemplate(
                    image: const AssetImage('assets/icons/background2.png'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    MiscBLMInputFieldDropDown(
                      key: _key1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscBLMInputFieldTemplate(
                        key: _key2, labelText: 'Location of the incident',
                        labelTextStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000))
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscBLMInputFieldTemplate(
                        key: _key3,
                        labelText: 'Precinct / Station House (Optional)',
                        labelTextStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000))),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: controller1,
                      keyboardType: TextInputType.text,
                      cursorColor: const Color(0xff000000),
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: dob,
                          maxTime: rip,
                          currentTime: DateTime.now(),
                          onConfirm: (date) {
                            String format =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                            dob = date;
                            controller1.text = format;
                          },
                          locale: LocaleType.en,
                        );
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'DOB',
                        labelStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: controller2,
                      keyboardType: TextInputType.text,
                      cursorColor: const Color(0xff000000),
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: dob,
                          maxTime: DateTime.now(),
                          currentTime: DateTime.now(),
                          onConfirm: (date) {
                            String format =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                            rip = date;
                            controller2.text = format;
                          },
                          locale: LocaleType.en,
                        );
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'RIP',
                        labelStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country',
                      labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000)),),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscBLMInputFieldTemplate(key: _key7, labelText: 'State',
                      labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000)),),
                    const SizedBox(
                      height: 40,
                    ),
                    MiscBLMButtonTemplate(
                      width: SizeConfig.screenWidth! / 2,
                      height: 45,
                      buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.74,
                          color: const Color(0xffffffff),
                          fontFamily: 'NexaBold'
                      ),
                      onPressed: () async {
                        if (_key2.currentState!.controller.text == '' ||
                            controller1.text == '' ||
                            controller2.text == '' ||
                            _key6.currentState!.controller.text == '' ||
                            _key7.currentState!.controller.text == '') {
                          await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                    image: Image.asset(
                                      'assets/icons/cover-icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    title: const Text(
                                      'Error',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: const Text(
                                      'Please complete the form before submitting.',
                                      textAlign: TextAlign.center,
                                    ),
                                    onlyOkButton: true,
                                    buttonOkColor: const Color(0xffff0000),
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeBLMCreateMemorial2(
                                  relationship:
                                      _key1.currentState!.currentSelection,
                                  locationOfIncident:
                                      _key2.currentState!.controller.text,
                                  precinct: _key3.currentState!.controller.text,
                                  dob: controller1.text,
                                  rip: controller2.text,
                                  country: _key6.currentState!.controller.text,
                                  state: _key7.currentState!.controller.text,
                                ),
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
