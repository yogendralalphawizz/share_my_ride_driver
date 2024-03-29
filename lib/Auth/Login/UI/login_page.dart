import 'package:flutter/material.dart';
import 'package:smr_driver/DrawerPages/Home/offline_page.dart';

import 'package:smr_driver/new_screens/login_screen.dart';
import 'package:smr_driver/new_screens/my_profile.dart';

import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:smr_driver/utils/location_details.dart';
import '../../login_navigator.dart';
import 'login_interactor.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginInteractor {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* PushNotificationService notificationService = new PushNotificationService(context: context,onResult: (result){

    });
    notificationService.initialise();*/
    changePage();
  }

  changePage() async {
    await App.init();

    if (App.localStorage.getString("userId") != null) {
      curUserId = App.localStorage.getString("userId").toString();
      GetLocation location = new GetLocation((result) {
        /*    address = result.first.addressLine;
        latitude = result.first.coordinates.latitude;
        longitude = result.first.coordinates.longitude;*/
      });
      location.getLoc();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OfflinePage("")),
          (route) => false);
      return;
    }
    if (App.localStorage.getString("userProfileId") != null) {
      curUserId = App.localStorage.getString("userProfileId").toString();
      GetLocation location = new GetLocation((result) {
        /*    address = result.first.addressLine;
        latitude = result.first.coordinates.latitude;
        longitude = result.first.coordinates.longitude;*/
      });
      location.getLoc();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
          (route) => false);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }

  @override
  void loginWithMobile(String isoCode, String mobileNumber) {
    Navigator.pushNamed(context, LoginRoutes.registration,
        arguments: isoCode + mobileNumber);
  }
}
