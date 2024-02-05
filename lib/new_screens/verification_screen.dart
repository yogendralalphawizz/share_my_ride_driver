import 'dart:async';


import 'package:flutter/material.dart';

import 'package:smr_driver/Auth/Login/UI/login_page.dart';


import 'package:smr_driver/Components/entry_field.dart';


import 'package:smr_driver/Locale/strings_enum.dart';
import 'package:smr_driver/new_screens/bottom_navigation.dart';
import 'package:smr_driver/new_screens/my_profile.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import '../DrawerPages/Home/offline_page.dart';


class VerificationScreen extends StatefulWidget {
 
  String mobile, otp;

  VerificationScreen(this.mobile, this.otp);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController otpCon = TextEditingController();

  @override
  void dispose() {
    otpCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: commonGradient()
            ),
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top +
                120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    getTranslated(context, Strings.ENTER)! +
                        '\n' +
                        getTranslated(context, Strings.VER_CODE)!,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: Colors.white
                    ),
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    getTranslated(context, Strings.ENTER_CODE_WE)!,
                    style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Expanded(
                  child: Container(
                    height: 500,
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Spacer(),
                        EntryField(
                          keyboardType: TextInputType.phone,
                          maxLength: 4,
                          controller: otpCon,
                          label:
                          getTranslated(context, Strings.ENTER_6_DIGIT)
                              .toString() +
                              " ${widget.otp}",
                        ),
                        Spacer(flex: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            commonButton(
                                context: context,
                                width: 80,
                                loading: loading,
                                title: "Continue",
                                onPressed: (){
                                  if (otpCon.text == "" ||
                                      otpCon.text.length != 4) {
                                    setSnackbar("Please Enter Valid Otp", context);
                                    return;
                                  }
                                  if (otpCon.text != widget.otp) {
                                    setSnackbar("Wrong Otp", context);
                                    return;
                                  }
                                  setState(() {
                                    loading = true;
                                  });
                                  loginUser();
                                }
                            ),
                          ],
                        ),
                        Spacer(flex: 1),
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

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = false;
  loginUser() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "mobile": widget.mobile.trim().toString(),
          "otp": widget.otp.toString(),
        };
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl + "verify_otp"), data);
        print(response);
        String msg = response['message'];
        setState(() {
          loading = false;
        });
        setSnackbar(msg, context);
        if (!response['error']) {
          if (response['data']['is_verified'].toString() == "1" &&
              response['data']['reject'].toString() == "1") {
            App.localStorage
                .setString("userProfileId", response['data']['id'].toString());
            curUserId = response['data']['id'].toString();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
                (route) => false);
          } else if (response['data']['is_verified'].toString() == "0") {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Alert"),
                    content: Text("Wait For Admin Approval"),
                    actions: <Widget>[
                      ElevatedButton(
                          child: Text('OK'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                MyColorName.primaryLite),
                          ),
                          /* shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent)),
                                textColor: Theme.of(context).colorScheme.primary,*/
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          }),
                    ],
                  );
                });
          }
          // else if(response['data']['is_active'].toString() == "1" && response['data']['reject'].toString() == "1"){
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => MyProfilePage(
          //         isActive: response['data']['is_active'].toString(),
          //       )),
          //           (route) => false);
          // }
          else {
            App.localStorage
                .setString("userId", response['data']['id'].toString());
            curUserId = response['data']['id'].toString();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomBar()),
                (route) => false);
          }
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        loading = false;
      });
    }
  }
}
