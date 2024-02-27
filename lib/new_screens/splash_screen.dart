import 'dart:async';



import 'package:smr_driver/generated/assets.dart';
import 'package:smr_driver/new_screens/bottom_navigation.dart';
import 'package:smr_driver/new_screens/login_screen.dart';
import 'package:smr_driver/new_screens/my_profile.dart';

import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:smr_driver/utils/location_details.dart';


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/PushNotificationService.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double value = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinateIndicator();
  }

  void determinateIndicator() async {
    await Future.delayed(Duration(seconds: 5));
    await App.init();
    PushNotificationService notificationService =
    new PushNotificationService(context: context, onResult: (result) {});
    notificationService.initialise();
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
          MaterialPageRoute(builder: (context) => BottomBar()),
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);

  }

  double width = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(Assets.assetsSplashScreen),
                fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text.rich(
          TextSpan(
              text: 'By continuing, you agree to our\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: <TextSpan>[
                TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff722BEA),
                      decorationColor: Color(0xff722BEA),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // code to open / launch terms of service link here
                      }),
                TextSpan(
                    text: ' and ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff722BEA),
                              decorationColor: Color(0xff722BEA),
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // code to open / launch privacy policy link here
                            })
                    ])
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
