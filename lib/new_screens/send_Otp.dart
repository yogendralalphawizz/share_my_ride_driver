import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

import 'VerifyOtp.dart';

class SendOTPScreen extends StatefulWidget {
  const SendOTPScreen({Key? key}) : super(key: key);

  @override
  State<SendOTPScreen> createState() => _SendOTPScreenState();
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  TextEditingController mobileCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;



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
                    Text(
                      "Send Otp",
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
              Text(
                "Enter Mobile Number",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!,
              ),
              boxHeight(context,3, ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(
                      context,
                      8,
                    )),
                child: TextFormField(
                  controller: mobileCon,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (!isPhone(value!)) {
                      return 'Please enter a valid phone number.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: MyColorName.colorBg2,

                    filled: true,
                    labelText: "Mobile Number",
                    counterText: '',
                    labelStyle: TextStyle(color: Colors.black87),
                    prefixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.phone,
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
              boxHeight( context,5),
              commonButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    sendOtpApi();
                    // Navigate to next page
                  }

                },
                loading: loading,
                title:  "Submit",
                context: context,
              ),

            ],
          ),
        ),
      ),
    );
  }

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void sendOtpApi()async{
    try{
      await App.init();
      Map param = {
        'mobile': mobileCon.text
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}register_otp"), param);
      if(!response['error']){

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:response['otp'].toString(),mobile: mobileCon.text,title: 'sendOtp'),));
        }
        setState(() {
          loading = false;
        });
        //
      }else{
        Fluttertoast.showToast(msg: response['message']);
        setState(() {
          loading = false;
        });
      }
      setSnackbar(response['msg'], context);
    }catch(e){
      setState(() {
        loading =false;
      });
    }finally{
      setState(() {
        loading =false;
      });
    }
  }

}
