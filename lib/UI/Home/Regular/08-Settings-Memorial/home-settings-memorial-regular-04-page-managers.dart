import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-03-show-admin-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-09-add-admin.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-10-remove-admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularShowAdminSettings {
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  const RegularShowAdminSettings(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.image,
      required this.relationship,
      required this.email});
}

class HomeRegularPageManagers extends StatefulWidget {
  final int memorialId;
  const HomeRegularPageManagers({required this.memorialId});

  HomeRegularPageManagersState createState() =>
      HomeRegularPageManagersState(memorialId: memorialId);
}

class HomeRegularPageManagersState extends State<HomeRegularPageManagers> {
  final int memorialId;
  HomeRegularPageManagersState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  List<Widget> managers = [];
  int adminItemsRemaining = 1;
  int familyItemsRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  bool flag1 = false;

  void initState() {
    super.initState();
    addManagers1();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (adminItemsRemaining != 0 && familyItemsRemaining != 0) {
          setState(() {
            onLoading();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more users to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  void onLoading() async {
    if (flag1 == false) {
      onLoading1();
    } else {
      onLoading2();
    }
  }

  Future<void> onRefresh() async {
    if (adminItemsRemaining == 0 && flag1 == false) {
      setState(() {
        flag1 = true;
      });
      onLoading1();
    } else {
      onLoading2();
    }
  }

  void addManagers1() {
    managers.add(
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        child: Text(
          'Admin',
          style: TextStyle(
            fontSize: SizeConfig.blockSizeVertical! * 1.76,
            fontFamily: 'NexaRegular',
            color: const Color(0xff9F9F9F),
          ),
        ),
      ),
    );
  }

  void addManagers2() {
    managers.add(
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        child: Text(
          'Family',
          style: TextStyle(
            fontSize: SizeConfig.blockSizeVertical! * 1.76,
            fontFamily: 'NexaRegular',
            color: const Color(0xff9F9F9F),
          ),
        ),
      ),
    );
  }

  void onLoading1() async {
    if (adminItemsRemaining != 0) {
      context.loaderOverlay.show();
      var newValue = await apiRegularShowAdminSettings(
          memorialId: memorialId, page: page1);
      context.loaderOverlay.hide();

      adminItemsRemaining = newValue.almAdminItemsRemaining;

      for (int i = 0; i < newValue.almAdminList.length; i++) {
        managers.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xff888888),
              foregroundImage: NetworkImage(
                '${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}',
              ),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text(
                '${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.64,
                fontFamily: 'NexaBold',
                color: const Color(0xff000000),
              ),),
            subtitle: Text(
                '${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.11,
                fontFamily: 'NexaRegular',
                color: const Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: const Color(0xffffffff),
              splashColor: const Color(0xff04ECFF),
              onPressed: () async {
                bool confirmation = await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                          image: Image.asset(
                            'assets/icons/cover-icon.png',
                            fit: BoxFit.cover,
                          ),
                      title: Text(
                        'Confirm',
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 3.87,
                            fontFamily: 'NexaRegular'),
                      ),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text(
                            'Are you sure you want to remove this user?',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                fontFamily: 'NexaRegular'
                            ),
                          ),
                          onlyOkButton: false,
                          onOkButtonPressed: () async {
                            Navigator.pop(context, true);
                          },
                          onCancelButtonPressed: () {
                            Navigator.pop(context, false);
                          },
                        ));

                if (confirmation) {
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialAdmin(
                      pageType: 'Memorial',
                      pageId: memorialId,
                      userId: newValue.almAdminList[i].showAdminsSettingsUser
                          .showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if (result != 'Success') {
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
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                    fontFamily: 'NexaRegular'),
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text(
                                'Error: $result.',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                    fontFamily: 'NexaRegular'
                                ),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            ));
                  } else {
                    await showDialog(
                        context: context,
                        builder: (_) => AssetGiffyDialog(
                              image: Image.asset(
                                'assets/icons/cover-icon.png',
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                'Success',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                    fontFamily: 'NexaRegular'),
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text(
                                'Successfully removed the user from the list.',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                    fontFamily: 'NexaRegular'
                                ),
                              ),
                              onlyOkButton: true,
                              onOkButtonPressed: () {
                                managers = [];
                                adminItemsRemaining = 1;
                                familyItemsRemaining = 1;
                                page1 = 1;
                                page2 = 1;
                                flag1 = false;
                                addManagers1();
                                onLoading();

                                Navigator.pop(context, true);
                              },
                            ));
                  }
                }
              },
              child: Text(
                'Remove',
                style:  TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 2.11,
                    fontFamily: 'HelveticaRegular',
                  color: const Color(0xffffffff),
                ),
              ),
              height: 40,
              shape: const StadiumBorder(
                side: const BorderSide(color: const Color(0xffE74C3C)),
              ),
              color: const Color(0xffE74C3C),
            ),
          ),
        );
      }
    }

    if (mounted) setState(() {});
    page1++;

    if (adminItemsRemaining == 0) {
      addManagers2();
      flag1 = true;
      onLoading();
    }
  }

  void onLoading2() async {
    if (familyItemsRemaining != 0) {
      context.loaderOverlay.show();
      var newValue = await apiRegularShowAdminSettings(
          memorialId: memorialId, page: page2);
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.almFamilyItemsRemaining;

      for (int i = 0; i < newValue.almFamilyList.length; i++) {
        managers.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(
                  '${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text(
                '${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text(
                '${newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: const Color(0xffffffff),
              splashColor: const Color(0xff04ECFF),
              onPressed: () async {
                bool confirmation = await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                          image: Image.asset(
                            'assets/icons/cover-icon.png',
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            'Confirm',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                fontFamily: 'NexaRegular'),
                          ),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text(
                            'Are you sure you want to make this user a manager?',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                fontFamily: 'NexaRegular'
                            ),
                          ),
                          onlyOkButton: false,
                          onOkButtonPressed: () async {
                            Navigator.pop(context, true);
                          },
                          onCancelButtonPressed: () {
                            Navigator.pop(context, false);
                          },
                        ));

                if (confirmation) {
                  context.loaderOverlay.show();
                  String result = await apiRegularAddMemorialAdmin(
                      pageType: 'Memorial',
                      pageId: memorialId,
                      userId: newValue.almFamilyList[i].showAdminsSettingsUser
                          .showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if (result != 'Success') {
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
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                    fontFamily: 'NexaRegular'),
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text(
                                'Error: $result.',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                    fontFamily: 'NexaRegular'
                                ),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            ));
                  } else {
                    await showDialog(
                        context: context,
                        builder: (_) => AssetGiffyDialog(
                              image: Image.asset(
                                'assets/icons/cover-icon.png',
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                'Success',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                    fontFamily: 'NexaRegular'),
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text(
                                'Successfully removed the user from the list.',
                                textAlign: TextAlign.center,
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                    fontFamily: 'NexaRegular'
                                ),
                              ),
                              onlyOkButton: true,
                              onOkButtonPressed: () {
                                managers = [];
                                adminItemsRemaining = 1;
                                familyItemsRemaining = 1;
                                page1 = 1;
                                page2 = 1;
                                flag1 = false;
                                addManagers1();
                                onLoading();

                                Navigator.pop(context, true);
                              },
                            ));
                  }
                }
              },
              child: Text(
                'Make Manager',
                style:  TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 2.2,
                    fontFamily: 'NexaRegular'
                ),
              ),
              height: 40,
              shape: const StadiumBorder(
                side: const BorderSide(color: const Color(0xff04ECFF)),
              ),
              color: const Color(0xff04ECFF),
            ),
          ),
        );
      }

      if (mounted) setState(() {});
      page2++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff04ECFF),
        title: Row(
          children: [
            Text(
              'Page Managers',
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                fontFamily: 'NexaRegular',
                color: const Color(0xffffffff),
              ),
            ),
            Spacer()
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: SizeConfig.blockSizeVertical! * 3.52,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: managers.length != 0
            ? RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.separated(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  physics: const ClampingScrollPhysics(),
                  itemCount: managers.length,
                  separatorBuilder: (c, i) =>
                      const Divider(height: 10, color: Colors.transparent),
                  itemBuilder: (c, i) => managers[i],
                ))
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                          3.5,
                    ),
                    Image.asset(
                      'assets/icons/app-icon.png',
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Text(
                      'Managers list is empty',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 3.52,
                        fontFamily: 'NexaBold',
                        color: const Color(0xffB1B1B1),
                      ),
                    ),
                    SizedBox(
                      height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                          3.5,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
