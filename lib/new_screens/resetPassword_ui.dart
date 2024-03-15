import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

import 'login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key,this.mobile}) : super(key: key);
final String? mobile;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible1 =false;
  bool isVisible2 =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(children: [
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
                    "Reset Password",
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Card(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Center(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  controller: passwordC,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  obscureText: isVisible1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",

                    contentPadding:
                    EdgeInsets.only(left: 15, top: 15),
                    hintText: "New Password",hintStyle: TextStyle(color: MyColorName.colorTextSecondary),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: MyColorName.mainColor,
                      size: 20,
                    ),
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            isVisible1 = !isVisible1;
                          });
                        },
                        child: Icon(
                          isVisible1 ? Icons.visibility_off :Icons.remove_red_eye,
                          color: MyColorName.mainColor,
                          size: 20,
                        ),
                      )

                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 0),
            child: Card(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Center(
                child: TextFormField(
                  validator: (value) {
                    if (value! != passwordC.text) {
                      return 'Password does not match.';
                    }

                  },
                  controller: confirmPasswordC,
                  obscureText: isVisible2,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    hintText: "Confirm Password",hintStyle: TextStyle(color: MyColorName.colorTextSecondary),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: MyColorName.mainColor,
                      size: 20,
                    ),
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            isVisible2 = !isVisible2;
                          });
                        },
                        child: Icon(
                          isVisible2 ? Icons.visibility_off :Icons.remove_red_eye,
                          color: MyColorName.mainColor,
                          size: 20,
                        ),
                      )
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    //registerUser();
                    resetPassword();
                  } else {
                    print('_____');
                    setState((){
                      //isLoading = false;
                    });
                    ///Fluttertoast.showToast(msg: "Enter Correct Credentials!!");
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Correct Credentials!")));
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [MyColorName.mainColor, MyColorName.mainColor],
                          stops: [0, 1]),
                      color: MyColorName.mainColor),
                  child: Center(
                      child: /*isLoading ==*/ false ? CircularProgressIndicator():Text("Reset Password",
                          style: TextStyle(
                              fontSize: 18, color: Colors.white))),
                )),
          ),
                ],),
        ),
      ),
    );
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  void resetPassword()async{
    try{
      await App.init();
      Map param = {
        "new_password":passwordC.text,
        "mobile":widget.mobile,
        "type":'drivers'
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}reset_password"), param);

      setSnackbar(response['message'], context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }catch(e){

    }finally{

    }
  }

}
