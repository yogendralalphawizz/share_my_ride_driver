

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smr_driver/new_screens/login_screen.dart';

import '../../../utils/Session.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../../../utils/location_details1.dart';

class ForgotPage extends StatefulWidget {

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController emailCon = TextEditingController();
  bool isPasswordVisible = true ;
  bool loading = false;
  void registerApi() async {


    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map<String, String> param = {

          "email": emailCon.text,


        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "forgot_pass"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };

       // print("kkkkkkkkkkkkkkkkkkkkkkkkkkkk");
        request.headers.addAll(headers);
        request.fields.addAll(param);
        print(request.fields.toString());
        print("request: " + request.toString());
        var res = await request.send();
        print("This is response:" + res.toString());
        setState(() {
          loading = false;
        });
        print(res.statusCode);
        final respStr = await res.stream.bytesToString();
        print(respStr.toString());
        if (res.statusCode == 200) {
          Map data = jsonDecode(respStr.toString());
          if (data['status'].toString()=="1") {
            setSnackbar("Your New Password ${data['new_pass'].toString()}", context);


          } else {
            setSnackbar(data['msg'].toString(), context);
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
        setState(() {
          loading = true;
        });
      }
    } else {
      setSnackbar("No Internet Connection", context);
      setState(() {
        loading = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: getWidth(context,100, ),
              //  height: getHeight(context,35, ),
              decoration: BoxDecoration(
                  gradient: commonGradient(),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(52),
                    bottomRight: Radius.circular(52),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  boxHeight(context,2, ),
                  Text(
                    "Forgot ",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                  boxHeight(context,2, ),


                ],
              ),
            ),
            boxHeight(context,3, ),
            Spacer(),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
              child: TextFormField(
                controller: emailCon,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: MyColorName.colorBg2,
                  filled: true,
                  labelText: "Email Address",
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.mail,
                      color: MyColorName.primaryDark,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColorName.colorBg2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: MyColorName.colorBg2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            boxHeight(context,3, ),
            commonButton(
              width: 70,
              onPressed: () {

                if (emailCon.text == "" ||
                    !emailCon.text.contains("@") ||
                    !emailCon.text.contains(".")
                ) {
                  setSnackbar("Enter Valid Email", context);
                  return;
                }




                setState(() {
                  loading = true;
                });
                registerApi();
              },
              loading: loading,
              title: "Forgot Password",
              context: context,
            ),
            Spacer(),
            boxHeight(context,3, ),

          ],
        ),
      ),
    );

  }
}
