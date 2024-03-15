

import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:smr_driver/new_screens/VerifyOtp.dart';
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
  final _formKey = GlobalKey<FormState>();


  void forgotApi() async {


    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map<String, String> param = {

          "email":isEmail(emailCon.text) ? emailCon.text : '',
          "mobile":isPhone(emailCon.text) ? emailCon.text: '',


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
          if (data['status']=='success') {
           // setSnackbar("Your New Password ${data['new_pass'].toString()}", context);

            Fluttertoast.showToast(msg: data['msg']);
            if(data['otp']!=null){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:data['otp'].toString(),mobile:data['mobile'].toString() ,title: 'forgot', ),));
            }else{
              Navigator.pop(context);
            }
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
        child: Form(
          key: _formKey,
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
                    Row(
                      children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Icon(Icons.arrow_back,size: 25,color: Colors.white,),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width/4.5,),
                      Text(
                        "Forgot ",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ],),
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
                    validator:  (value) {
                      if (!isEmail(value!) && !isPhone(value)) {
                        return 'Please enter a valid email or phone number.';
                      }
                      return null;
                    },
                  decoration: InputDecoration(
                    fillColor: MyColorName.colorBg2,
                    filled: true,
                    labelText: "Email Address/Mobile Number",
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

                  if (_formKey.currentState!.validate())
                   {
                     setState(() {
                       loading = true;
                     });
                     forgotApi();
                  }





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
      ),
    );

  }

  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
}
