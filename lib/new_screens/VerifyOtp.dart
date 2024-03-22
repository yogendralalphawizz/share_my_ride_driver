import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
//import 'package:pinput/pinput.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smr_driver/Assets/assets.dart';
import 'package:smr_driver/Auth/Login/UI/login_page.dart';
import 'package:smr_driver/new_screens/register_screen.dart';
import 'package:smr_driver/new_screens/resetPassword_ui.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

import '../../../Theme/colors.dart';
import 'package:http/http.dart'as http;

import 'bottom_navigation.dart';
import 'my_profile.dart';


class VerifyOtp extends StatefulWidget {
  String? otp;
  String? mobile;
  String? title;

  VerifyOtp({Key? key,this.otp,this.mobile,this.title}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool isLoading = false;
  bool isloader = false;
  TextEditingController pinController = TextEditingController();

  @override


  final _formKey = GlobalKey<FormState>();

  final defaultPinTheme = PinTheme(
    width: 66,
    height: 60,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: MyColorName.mainColor),
      borderRadius: BorderRadius.circular(50),
    ),
  );

  // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  //   border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
  //   borderRadius: BorderRadius.circular(8),
  // );
  //
  // final submittedPinTheme = defaultPinTheme.copyWith(
  //   decoration: defaultPinTheme.decoration.copyWith(
  //     color: Color.fromRGBO(234, 239, 243, 1),
  //   ),
  // );

  // @override


    @override
  void initState() {
    super.initState();
    //verifyOtp();
    // Future.delayed(Duration(seconds: 60)).then((_) {
    //   verifyOtp();
    //
    // });

  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
 
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  boxHeight(context,2),
                  Text(
                    "Verify OTP ",
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

            // SizedBox(height: 45,),
            boxHeight(context,2,),
            //Spacer(),
            Text(
              "Code has sent to",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
            SizedBox(
              height: 0,
            ),
            Text(
              "+91${widget.mobile}",
              style: TextStyle(color:  Colors.black,fontWeight:FontWeight.w500,fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            /*Text(
              "OTP-${widget.otp}",
              style: TextStyle(color:  Colors.black,fontWeight:FontWeight.bold,fontSize: 16),
            ),*/
            SizedBox(height: 20,),
            Center(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Directionality(
                      // Specify direction if desired
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40,right: 40),
                        child: Pinput(
                          controller: pinController,
                         defaultPinTheme: defaultPinTheme,
                         // focusedPinTheme: ,
                         // submittedPinTheme: submittedPinTheme,
                          validator: (s) {
                            return s == '${widget.otp}' ? null : 'Pin is incorrect';
                          },
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) => print(pin),
                        ),

                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 40,),
            Text("Haven't received the verification code?",style: TextStyle(
                color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold
            ),),
            InkWell(
              onTap: (){
                if(widget.title=='sendOtp'){
                  registerResendOtpApi();
                }else if(widget.title=='forgot') {
                  reSendOtp();
                }else {
                  loginResendOtpApi();
                }
              },
              child: Text("Resend",style: TextStyle(
                  color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17
              ),),
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 18),
              child: InkWell(
                  onTap: ()
                  {if(pinController.text == widget.otp){

                    if(widget.title == 'sendOtp'){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    }else if(widget.title == 'forgot'){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(mobile: widget.mobile),));
                    }else {
                      setState(() {
                        isloader = true;
                      });
                      verifyOtp();

                    }



                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid otp")));
                  }

                  },
                  child:  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [MyColorName.mainColor, MyColorName.mainColor],
                            stops: [0, 1]),
                        color: MyColorName.mainColor),
                    child:
                    Center(
                        child: Text("Send", style: TextStyle(fontSize: 18, color: Colors.white))),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void reSendOtp()async{
    try{
      await App.init();
      Map param = {
        "email":'',
        "mobile":widget.mobile,
        "type":'drivers',
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}forgot_pass"), param);
      if(response['status']=='success'){

        Fluttertoast.showToast(msg: response['msg']);

        if(response['otp']!=null){

          widget.otp = response['otp'].toString();
          setState(() {

          });
        }
        //
      }else{

      }
      setSnackbar(response['msg'], context);
    }catch(e){

    }finally{

    }
  }

  verifyOtp() async {
    var headers = {
      'Cookie': 'ci_session=1fae43cb24be06ee09e394b6be82b42f6d887269'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}verify_otp'));
    request.fields.addAll({
      'mobile': widget.mobile.toString(),
      'otp': pinController.text,
    });
    print("Requestt>>>>>>>${request.fields}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalresponse = await response.stream.bytesToString();
      final jsonresponse = json.decode(finalresponse);
      if (jsonresponse['error'] == false){

        if (jsonresponse['data']['is_verified'].toString() == "1" &&
            jsonresponse['data']['reject'].toString() == "1") {
          App.localStorage
              .setString("userProfileId", jsonresponse['data']['id'].toString());
          curUserId = jsonresponse['data']['id'].toString();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
                  (route) => false);
        } else if (jsonresponse['data']['is_verified'].toString() == "0") {
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
              .setString("userId", jsonresponse['data']['id'].toString());
          curUserId = jsonresponse['data']['id'].toString();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomBar()),
                  (route) => false);
        }
        /*Map info = jsonresponse['data'];
        setSnackbar(jsonresponse['message'].toString(), context);

        App.localStorage
            .setString("userId", "${info["id"]}")
            .toString();
        curUserId = "${info["id"]}";
        navigateBackScreen(context, BottomBar());*/
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${jsonresponse['message']}")));
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  void registerResendOtpApi()async{
    try{
      await App.init();
      Map param = {
        'mobile': widget.mobile
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}register_otp"), param);
      if(!response['error']){

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          widget.otp =response['otp'].toString();
          setState(() {

          });
        }

        //
      }else{
        Fluttertoast.showToast(msg: response['message']);

      }
      setSnackbar(response['msg'], context);
    }catch(e){

    }finally{

    }
  }

  void loginResendOtpApi() async {
    try {
      await App.init();
      Map param = {
        "mobile":widget.mobile,
      };

      var response =
      await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}send_otp"), param);

      if (!response['error']) {

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          widget.otp = response['otp'].toString();
          setState(() {

          });
        }
      } else {
        setSnackbar(response['message'], context);
      }
    } catch (e) {

    } finally {

    }
  }

}
