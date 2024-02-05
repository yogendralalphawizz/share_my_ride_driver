

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/Session.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../utils/constant.dart';
import '../utils/location_details1.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {


  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordcon = TextEditingController();
  TextEditingController newPasswordCon = TextEditingController();
  bool obssecure=false;
  bool newobssecure=false;
  bool loading=false;
  void registerApi() async {


    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map<String, String> param = {
         "user_id":curUserId.toString(),
          "old_password": oldPasswordcon.text,
           "new_password":newPasswordCon.text

        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "changePassword"),
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
          if (!data['error']) {
            setSnackbar("${data['message'].toString()}", context);


          } else {
            setSnackbar(data['message'].toString(), context);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColorName.primaryDark,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Change Password",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:Colors.white),
        ),
      ),
      body:
      Column(
        children: [
          Spacer(),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
            child: TextFormField(
              controller: oldPasswordcon,
              obscureText: obssecure,
              decoration: InputDecoration(
                fillColor: MyColorName.colorBg2,
                filled: true,
                labelText: "Old Password",
                counterText: '',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.lock,
                    color: MyColorName.primaryDark,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obssecure = !obssecure;
                    });
                  },
                  icon: Icon(
                    obssecure ? Icons.visibility_off : Icons.visibility,
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
          SizedBox(height: 20,),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
            child: TextFormField(
              controller: newPasswordCon,
              obscureText: newobssecure,
              decoration: InputDecoration(
                fillColor: MyColorName.colorBg2,
                filled: true,
                labelText: "New Password",
                counterText: '',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.lock,
                    color: MyColorName.primaryDark,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      newobssecure = !newobssecure;
                    });
                  },
                  icon: Icon(
                    newobssecure ? Icons.visibility_off : Icons.visibility,
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

              if (oldPasswordcon.text == ""

              ) {
                setSnackbar("Enter Old Passward", context);
                return;
              }
              if (newPasswordCon.text == ""

              ) {
                setSnackbar("Enter New Passward", context);
                return;
              }




              setState(() {
                loading = true;
              });
              registerApi();
            },
            loading: loading,
            title: "Change Password",
            context: context,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
