import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-02-create-memorial.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularCreateMemorialValues {
  final String memorialName;
  final String description;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String relationship;
  final List<File> imagesOrVideos;
  final double longitude;
  final double latitude;

  const RegularCreateMemorialValues({
    required this.memorialName,
    required this.description,
    required this.birthplace,
    required this.dob,
    required this.rip,
    required this.cemetery,
    required this.country,
    required this.relationship,
    required this.imagesOrVideos,
    required this.latitude,
    required this.longitude,
  });
}

class HomeRegularCreateMemorial1 extends StatefulWidget {
  HomeRegularCreateMemorial1State createState() =>
      HomeRegularCreateMemorial1State();
}

class HomeRegularCreateMemorial1State
    extends State<HomeRegularCreateMemorial1> {
  GlobalKey<MiscRegularInputFieldDropDownState> _key1 =
      GlobalKey<MiscRegularInputFieldDropDownState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key2 =
      GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key5 =
      GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key6 =
      GlobalKey<MiscRegularInputFieldTemplateState>();

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
            title: Text('Create a Memorial Page for Friends and family.',
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
                  child: const MiscRegularBackgroundTemplate(
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
                    MiscRegularInputFieldDropDown(
                      key: _key1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscRegularInputFieldTemplate(
                      key: _key2, labelText: 'Birthplace',
                      labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000)),),
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
                    MiscRegularInputFieldTemplate(
                      key: _key5, labelText: 'Cemetery',
                      labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000)),),
                    const SizedBox(
                      height: 20,
                    ),
                    MiscRegularInputFieldTemplate(
                      key: _key6, labelText: 'Country',
                      labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000)),),
                    const SizedBox(
                      height: 40,
                    ),
                    MiscRegularButtonTemplate(
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
                            _key5.currentState!.controller.text == '' ||
                            _key6.currentState!.controller.text == '') {
                          await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                    image: Image.asset(
                                      'assets/icons/cover-icon.png',
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      'Error',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                          fontFamily: 'NexaRegular'),
                                    ),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text(
                                      'Please complete the form before submitting.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: SizeConfig
                                              .blockSizeVertical! *
                                              2.87,
                                          fontFamily: 'NexaRegular'),
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
                                builder: (context) =>
                                    HomeRegularCreateMemorial2(
                                  relationship:
                                      _key1.currentState!.currentSelection,
                                  birthplace:
                                      _key2.currentState!.controller.text,
                                  dob: controller1.text,
                                  rip: controller2.text,
                                  cemetery: _key5.currentState!.controller.text,
                                  country: _key6.currentState!.controller.text,
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
