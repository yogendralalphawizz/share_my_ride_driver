// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:smr_driver/new_screens/register_screen.dart';
// import 'package:smr_driver/new_screens/verification_screen.dart';
//
//
// import 'package:smr_driver/Components/entry_field.dart';
// import 'package:smr_driver/Locale/strings_enum.dart';
//
// import 'package:smr_driver/utils/ApiBaseHelper.dart';
// import 'package:smr_driver/utils/Session.dart';
// import 'package:smr_driver/utils/colors.dart';
// import 'package:smr_driver/utils/common.dart';
// import 'package:smr_driver/utils/constant.dart';
//
//
//
// class LoginScreen extends StatefulWidget {
//
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   // final TextEditingController mobileCon =
//   //     TextEditingController(text: '+91 9854596545');
//
//   final mobileCon = TextEditingController();
//
//
//   @override
//   void dispose() {
//     mobileCon.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     return Scaffold(
//       body:  SingleChildScrollView(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: commonGradient()
//           ),
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Spacer(flex: 5),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24),
//                 child: Text(
//                   getTranslated(context, Strings.ENTER_YOUR)! +
//                       '\n' +
//                       getTranslated(context, Strings.PHONE_NUMBER)!,
//                   style: theme.textTheme.headlineMedium!
//                       .copyWith(color: Colors.white),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 child: Text(
//                   getTranslated(context, Strings.WILL_SEND_CODE)!,
//                   style: theme.textTheme.bodyMedium!
//                       .copyWith(color: Colors.white),
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 color: theme.scaffoldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Spacer(),
//                     EntryField(
//                       maxLength: 10,
//                       keyboardType: TextInputType.phone,
//                       controller: mobileCon,
//                       label: getTranslated(context, Strings.ENTER_PHONE),
//                     ),
//                     Spacer(flex: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         commonButton(
//                           context: context,
//                           width: 80,
//                           loading: loading,
//                           title: "Continue",
//                           onPressed: (){
//                             if (mobileCon.text == "" ||
//                                 mobileCon.text.length != 10) {
//                               setSnackbar(
//                                   "Please Enter Valid Mobile Number",
//                                   context);
//                               return;
//                             }
//                             setState(() {
//                               loading = true;
//                             });
//                             loginUser();
//                           }
//                         ),
//                       ],
//                     ),
//                     Spacer(flex: 1),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ApiBaseHelper apiBase = new ApiBaseHelper();
//   bool isNetwork = false;
//   bool loading = false;
//   loginUser() async {
//     await App.init();
//     isNetwork = await isNetworkAvailable();
//     if (isNetwork) {
//       try {
//         Map data;
//         data = {
//           "mobile": mobileCon.text.trim().toString(),
//           "device_token": fcmToken.toString(),
//         };
//         print(data);
//
//         Map response = await apiBase.postAPICall(
//             Uri.parse(baseUrl + "send_otp"), data);
//         print(response);
//
//         String msg = response['message'];
//         setState(() {
//           loading = false;
//         });
//         setSnackbar(msg, context);
//         if (!response['error']) {
//           navigateScreen(
//               context,
//               VerificationScreen(mobileCon.text.trim().toString(),
//                   response['otp'].toString()));
//
//         } else {
//           if (msg.contains("Approve")) {
//             showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text("Alert"),
//                     content: Text("Wait For Admin Approval"),
//                     actions: <Widget>[
//                       ElevatedButton(
//                           child: Text('OK'),
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(
//                                 MyColorName.primaryLite),
//                           ),
//                           /* shape: RoundedRectangleBorder(
//                                     side: BorderSide(color: Colors.transparent)),
//                                 textColor: Theme.of(context).colorScheme.primary,*/
//                           onPressed: () async {
//                             Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => LoginScreen()),
//                                 (route) => false);
//                           }),
//                     ],
//                   );
//                 });
//             /* showDialog(
//                 context: context,
//                 builder: (context) {
//                   return Dialog(
//                     child: Container(
//                       padding: EdgeInsets.all(getWidth(context,10)),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           text("Wait For Admin Approval",
//                             fontFamily: fontMedium,
//                             textColor: Colors.black,
//                             isCentered:   true,
//                             fontSize: 10.sp,),
//                           boxHeight(context,20),
//                           ElevatedButton(onPressed: (){
//                             Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => LoginPage()),
//                                     (route) => false);
//                           }, child: text("OK", fontFamily: fontMedium,
//                             textColor: Colors.white,
//                             isCentered:   true,
//                             fontSize: 10.sp,))
//                         ],
//                       ),),
//                   );
//                 });*/
//           } else {
//             navigateScreen(
//                 context, RegisterScreen(phoneNumber:mobileCon.text.trim()));
//          }
//        }
//       } on TimeoutException catch (_) {
//         setSnackbar("Something Went Wrong", context);
//         setState(() {
//           loading = false;
//         });
//       }
//     } else {
//       setSnackbar("No Internet Connection", context);
//       setState(() {
//         loading = false;
//       });
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:smr_driver/Auth/Registration/UI/registration_page.dart';
import 'package:smr_driver/new_screens/VerifyOtp.dart';
import 'package:smr_driver/new_screens/home_screen.dart';
import 'package:smr_driver/new_screens/register_screen.dart';
import 'package:smr_driver/new_screens/send_Otp.dart';
import 'package:smr_driver/utils/PushNotificationService.dart';

import '../Auth/ForgotPassword/UI/forgot_page.dart';
import '../Auth/ForgotPassword/UI/forgot_password_page.dart';
import '../DrawerPages/Home/offline_page.dart';
import '../utils/Session.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../utils/constant.dart';
import '../utils/location_details1.dart';
import 'bottom_navigation.dart';
import 'my_profile.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isloader = false;

  TextEditingController mobileCtr = TextEditingController();
  List<String> method = ["Email", "Mobile No."];
  String selectMethod = "Email";
  bool obscure = true;

  void loginApi() async {
    //await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map<String, String> param = {
          "email": emailCon.text,
          "password": passCon.text,
          "fcm_id": "${fcmToken}"
        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "login"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };

        print("kkkkkkkkkkkkkkkkkkkkkkkkkkkk");
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
            Map info = data['data'];
            setSnackbar(data['message'].toString(), context);

             App.localStorage
                .setString("userId", "${info["id"]}")
                .toString();
            curUserId = "${info["id"]}";
            navigateBackScreen(context, BottomBar());
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

  // getLoginApi() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var headers = {
  //     'Cookie': 'ci_session=82d54b12ed7aa11a9ddd2cc054abba94d291adbd'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('${ApiService.login}'));
  //   request.fields.addAll({
  //     'mobile': mobileCtr.text,
  //     'password':passCtr.text
  //   });
  //
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     final result = await response.stream.bytesToString();
  //     final Finalresult = jsonDecode(result);
  //
  //     if(!(Finalresult['error'])) {
  //       var id = Finalresult['data']['id'];
  //       var mobile = Finalresult['data']['mobile'];
  //       var address = Finalresult['data']['address'];
  //       var email = Finalresult['data']['email'];
  //       var userName = Finalresult['data']['username'];
  //       SharedPreferences preferences = await SharedPreferences.getInstance();
  //       preferences.setString("userId", id.toString());
  //       preferences.setString("mobile", mobile.toString());
  //       preferences.setString("address", address.toString());
  //       preferences.setString("userName", userName.toString());
  //       preferences.setString("email", email.toString());
  //       String? name = preferences.getString('userName');
  //       print('${name} _________________name');
  //
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("${Finalresult['message']}")));
  //     } else {
  //
  //       setState(() {
  //         isLoading = false ;
  //       });
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("${Finalresult['message']}")));
  //     }
  //
  //   }
  //   else {
  //     setState(() {
  //       isLoading = false ;
  //     });
  //     print(response.reasonPhrase);
  //
  //   }
  //
  // }
  // loginwitMobile() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('otp', "otp");
  //   preferences.setString('mobile', "mobile");
  //
  //   print("this is apiiiiiiii");
  //   var headers = {
  //     'Cookie': 'ci_session=b13e618fdb461ccb3dc68f327a6628cb4e99c184'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('${ApiService.login}'));
  //   request.fields.addAll({
  //     'mobile': mobileCtr.text,
  //   });
  //   print("Request here${request.fields}");
  //
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     print("this is true response");
  //     var finalresponse = await response.stream.bytesToString();
  //     final jsonresponse = json.decode(finalresponse);
  //     print("this is final response${finalresponse}");
  //     // Future.delayed(Duration(seconds: 1)).then((_) {
  //     //   Navigator.pushReplacement(
  //     //       context,
  //     //       MaterialPageRoute(
  //     //           builder: (context) => VerifyOtp()
  //     //       ));
  //     // });
  //     if (jsonresponse['error'] == false) {
  //       int? otp = jsonresponse["otp"];
  //       String mobile = jsonresponse["mobile"];
  //
  //       print("otpppp${otp.toString()}");
  //       print("mobilee${mobile.toString()}");
  //       // print("This is urllllllllllllllll${baseUrl}");
  //       print("this is final response${finalresponse}");
  //
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${jsonresponse['message']}")));
  //
  //       setState(() {
  //
  //       });
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => VerifyOtp(otp: otp.toString(), mobile:mobile.toString() ,)
  //           ));
  //     }
  //     else{
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${jsonresponse['message']}")));
  //     }
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }
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

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  bool isPasswordVisible = true;

  bool isMobile = false;
  int _value = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  checkLogin();
  }

  bool loading = false;
  String? id;

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('userId');

    if (App.localStorage.getString("userId") == null) {
      print("this is is user is ${id} from null");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    //var locale = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      // backgroundColor: Color(0xffEBECF0),
      body: Column(
        children: [
          Container(
            width: getWidth(
              context,
              100,
            ),
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
                boxHeight(
                  context,
                  2,
                ),
                Text(
                  "LOGIN ",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                ),
                boxHeight(
                  context,
                  2,
                ),
              ],
            ),
          ),
          boxHeight(
            context,
            3,
          ),

          // SizedBox(height: 45,),
          boxHeight(
            context,
            2,
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 2,
                fillColor: MaterialStateColor.resolveWith(
                    (states) => MyColorName.mainColor),
                activeColor: Colors.white,
                groupValue: _value,
                onChanged: (int? value) {
                  setState(() {
                    _value = value!;
                    isMobile = false;
                  });
                },
              ),
              const Text(
                "Email",
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              Radio(
                  value: 1,
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => MyColorName.mainColor),
                  groupValue: _value,
                  onChanged: (int? value) {
                    setState(() {
                      _value = value!;
                      isMobile = true;
                    });
                  }),
              // SizedBox(width: 10.0,),
              const Text(
                "Mobile No.",
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ],
          ),
          !isMobile
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(
                        context,
                        8,
                      )),
                      child: TextFormField(
                        controller: emailCon,
                        keyboardType: TextInputType.emailAddress,
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
                    boxHeight(
                      context,
                      2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(
                        context,
                        8,
                      )),
                      child: TextFormField(
                        controller: passCon,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Password",
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
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
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
                    SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPage()));
                              },
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: Color(0xffd22027),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          isMobile
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                    context,
                    8,
                  )),
                  child: TextFormField(
                    controller: mobileCtr,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
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
                )
              : SizedBox.shrink(),
          SizedBox(height: 35),
          commonButton(
            width: 70,
            onPressed: () {
              if (isMobile) {
                if (mobileCtr.text == "") {
                  setSnackbar("Enter Valid Mobile Number", context);
                  return;
                }
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerifyOtp(mobile: mobileCtr.text, title: 'login'),
                    ));*/
                setState(() {
                  loading = true;
                });
                sendLoginOtpApi();
              } else {
                if (emailCon.text == "") {
                  setSnackbar("Enter Valid Email or Mobile", context);
                  return;
                }
                if (passCon.text == "") {
                  setSnackbar("Enter Password", context);
                  return;
                }

                setState(() {
                  loading = true;
                });
                loginApi();
              }
            },
            loading: loading,
            title: "LOGIN",
            context: context,
          ),
          SizedBox(
            height: 23,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't Have an Account?",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendOTPScreen()));

                    // Navigator.push(context, MaterialPageRoute(builder: ))
                    // widget.loginInteractor.signUp();
                  },
                  child: Text(
                    "Register ",
                    style: TextStyle(
                        color: Color(0xffd22027),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),

          Spacer()
        ],
      ),
    ));
    // return Scaffold(
    //   body: Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height/1.2,
    //     decoration: BoxDecoration(
    //         image: DecorationImage(
    //             image: AssetImage('assets/imgs/login.png'), fit: BoxFit.fill)),
    //     child: Column(
    //       children: <Widget>[
    //         Expanded(
    //           flex: 1,
    //           child: Container(),
    //         ),
    //         Stack(
    //           // flex: 0,
    //           children:[ SingleChildScrollView(
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(30),
    //                     topRight: Radius.circular(30),
    //                   )),
    //               child: Padding(
    //                 padding:
    //                 const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
    //                 child: Column(
    //                   children: [
    //                     SizedBox(height: 20,),
    //                     Text("Login",style: TextStyle(color: primary,fontWeight: FontWeight.w500,fontSize: 35),),
    //                     SizedBox(height: 45,),
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                           padding: const EdgeInsets.only(left: 8.0),
    //                           child: Text("Mobile Number",style: TextStyle(fontSize: 15),),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(
    //                               horizontal: 0, vertical: 0),
    //                           child: Card(
    //                             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                             elevation: 4,
    //                             child: Center(
    //
    //                               child: TextFormField(
    //                                 keyboardType: TextInputType.number,
    //                                 maxLength: 10,
    //                                 decoration: InputDecoration(
    //                                   border: InputBorder.none,
    //                                   counterText: "",
    //                                   contentPadding:
    //                                   EdgeInsets.only(left: 15, top: 15),
    //                                   hintText: "Mobile Number",hintStyle: TextStyle(color: blackColor),
    //                                   prefixIcon: Icon(
    //                                     Icons.call,
    //                                     color: blackColor,
    //                                     size: 20,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //
    //                       ],
    //                     ),
    //                     Padding(
    //                         padding: const EdgeInsets.only(
    //                             top: 40, left: 0, right: 0),
    //                         child:
    //                         InkWell(
    //                           onTap: (){
    //                             Navigator.push(context, MaterialPageRoute(builder: (c)=>HomePage()));
    //                           },
    //                             child:  Container(
    //                               height: 50,
    //                               width: MediaQuery.of(context).size.width,
    //                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: primary),
    //                               child:
    //                               Center(child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white))),
    //                             )
    //                         )
    //                     ),
    //                     SizedBox(height: 10,),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                       Text("Dont Have an Account?",style: TextStyle(fontSize: 15),),
    //                       Text("Register Now",style: TextStyle(color: primary,fontSize: 17),)
    //                     ],)
    //
    //                     // Container(
    //                     //   decoration: BoxDecoration(
    //                     //       border: Border.all(color: Colors.black87,width: 1),
    //                     //       borderRadius: BorderRadius.circular(7)
    //                     //   ),
    //                     //   child:
    //                     //   CustomButton(
    //                     //     text: 'Sign Up',
    //                     //     bgColor: Colors.white.withOpacity(0),
    //                     //     textColor: Colors.black,
    //                     //   ),
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    // ]
    //         ),
    //
    //       ],
    //     ),
    //   ),
    // );

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   backgroundColor: background,
    //   body: Stack(
    //     children:[
    //       Container(
    //         height: 500,
    //         decoration:  BoxDecoration(
    //             image:  DecorationImage(
    //               image:  AssetImage("assets/imgs/Layer 1672.png"),
    //               fit: BoxFit.cover,
    //             )
    //         ),
    //
    //     ),
    //       Container(
    //           height: 400,
    //           // alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //               color: background,
    //               borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
    //           ),
    //           child: Column(
    //             children: [
    //               SizedBox(height: 20,),
    //               Text("Login",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 35),),
    //               SizedBox(height: 15,),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(
    //                     horizontal: 20, vertical: 20),
    //                 child: Card(
    //                   shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //                   elevation: 4,
    //                   child: Center(
    //                     child: TextFormField(
    //                       keyboardType: TextInputType.number,
    //                       maxLength: 10,
    //                       decoration: InputDecoration(
    //                         border: InputBorder.none,
    //                         counterText: "",
    //                         contentPadding:
    //                         EdgeInsets.only(left: 15, top: 15),
    //                         hintText: "Mobile Number",hintStyle: TextStyle(color: Colors.red),
    //                         prefixIcon: Icon(
    //                           Icons.call,
    //                           color: Colors.red,
    //                           size: 20,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                   padding: const EdgeInsets.only(
    //                       top: 80, left: 20, right: 20),
    //                   child:
    //                   InkWell(
    //
    //                       child:  Container(
    //                         height: 50,
    //                         width: MediaQuery.of(context).size.width,
    //                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black),
    //                         child:
    //                         // isloader == true ? Center(child: CircularProgressIndicator(color: Colors.white,),) :
    //                         Center(child: Text("Send Otp", style: TextStyle(fontSize: 18, color: Colors.black))),
    //                       )
    //                   )
    //
    //               )
    //             ],
    //           )
    //
    //         // Column(
    //         //   children: [
    //         //     SizedBox(height: 20,),
    //         //     Text("Login",style: TextStyle(color: colors.blackTemp,fontSize: 30,fontWeight: FontWeight.w500),),
    //         //     SizedBox(height: 30,),
    //         //     Container(
    //         //       child: Row(
    //         //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         //         children: [
    //         //           InkWell(
    //         //             onTap: () {
    //         //               setState(() {
    //         //                 selectedIndex = 1;
    //         //               });
    //         //             },
    //         //             child: Container(
    //         //               child: Row(
    //         //                 children: [
    //         //                   Container(
    //         //                     height: 20,
    //         //                     width: 20,
    //         //                     padding: EdgeInsets.all(3),
    //         //                     decoration: BoxDecoration(
    //         //                         borderRadius: BorderRadius.circular(100),
    //         //                         border: Border.all(
    //         //                             color: selectedIndex == 1
    //         //                                 ? colors.secondary
    //         //                                 :colors.secondary,
    //         //                             width: 2)),
    //         //                     child: Container(
    //         //                       decoration: BoxDecoration(
    //         //                         borderRadius: BorderRadius.circular(100),
    //         //                         color: selectedIndex == 1
    //         //                             ? colors.secondary
    //         //                             : Colors.transparent,
    //         //                       ),
    //         //                     ),
    //         //                   ),
    //         //                   SizedBox(
    //         //                     width: 10,
    //         //                   ),
    //         //                   Text(
    //         //                     "Email",
    //         //                     style: TextStyle(
    //         //                         color:colors.secondary,
    //         //                         fontSize: 14,
    //         //                         fontWeight: FontWeight.w500),
    //         //                   )
    //         //                 ],
    //         //               ),
    //         //             ),
    //         //           ),
    //         //           InkWell(
    //         //             onTap: () {
    //         //               setState(() {
    //         //                 selectedIndex = 2;
    //         //               });
    //         //             },
    //         //             child: Container(
    //         //               child: Row(
    //         //                 children: [
    //         //                   Container(
    //         //                     height: 20,
    //         //                     width: 20,
    //         //                     padding: EdgeInsets.all(3),
    //         //                     decoration: BoxDecoration(
    //         //                         borderRadius: BorderRadius.circular(100),
    //         //                         border: Border.all(
    //         //                             color: selectedIndex == 2
    //         //                                 ? colors.secondary
    //         //                                 :colors.secondary,
    //         //                             width: 2)),
    //         //                     child: Container(
    //         //                       decoration: BoxDecoration(
    //         //                         borderRadius: BorderRadius.circular(100),
    //         //                         color: selectedIndex == 2
    //         //                             ? colors.secondary
    //         //                             : Colors.transparent,
    //         //                       ),
    //         //                     ),
    //         //                   ),
    //         //                   SizedBox(
    //         //                     width: 10,
    //         //                   ),
    //         //                   Text(
    //         //                     "Mobile no.",
    //         //                     style: TextStyle(
    //         //                         color: colors.secondary,
    //         //                         fontSize: 14,
    //         //                         fontWeight: FontWeight.w500),
    //         //                   )
    //         //                 ],
    //         //               ),
    //         //             ),
    //         //           ),
    //         //         ],
    //         //       ),
    //         //     ),
    //         //     Padding(
    //         //       padding: const EdgeInsets.only(right: 15,left: 15,top: 20),
    //         //       child: Column(
    //         //         children: [
    //         //       selectedIndex == 1?
    //         //         Form(
    //         //           key: _formKey,
    //         //           child: Column(
    //         //             crossAxisAlignment: CrossAxisAlignment.end,
    //         //             children: [
    //         //               Card(
    //         //                 shape: RoundedRectangleBorder(
    //         //                   borderRadius: BorderRadius.circular(10.0),
    //         //                 ),
    //         //                 elevation: 4,
    //         //                 child: TextFormField(
    //         //                   controller: emailController,
    //         //                   keyboardType: TextInputType.text,
    //         //                   decoration: InputDecoration(
    //         //                       prefixIcon: Icon(Icons.email_outlined,color: colors.secondary),
    //         //                       hintText: 'Email', hintStyle: TextStyle(fontSize: 15.0, color: colors.secondary),
    //         //                       border: InputBorder.none,
    //         //                       contentPadding: EdgeInsets.only(left: 10,top: 10)
    //         //                   ),
    //         //                   validator: (v) {
    //         //                     if (v!.isEmpty) {
    //         //                       return "Email is required";
    //         //                     }
    //         //                     if (!v.contains("@")) {
    //         //                       return "Enter Valid Email Id";
    //         //                     }
    //         //                   },
    //         //                 ),
    //         //               ),
    //         //               SizedBox(height: 10,),
    //         //               Card(
    //         //                 shape: RoundedRectangleBorder(
    //         //                   borderRadius: BorderRadius.circular(10.0),
    //         //                 ),
    //         //                 elevation: 5,
    //         //                 child: TextFormField(
    //         //                   controller: passwordController,
    //         //                   obscureText: true,
    //         //                   keyboardType: TextInputType.text,
    //         //                   decoration: InputDecoration(
    //         //                       prefixIcon: Icon(Icons.lock_open_rounded,color: colors.secondary),
    //         //                       hintText: 'Password', hintStyle: TextStyle(fontSize: 15.0, color: colors.secondary),
    //         //                       border: InputBorder.none,
    //         //                       contentPadding: EdgeInsets.only(left: 10,top: 12)
    //         //                   ),
    //         //                   validator: (v) {
    //         //                     if (v!.isEmpty) {
    //         //                       return "Password is required";
    //         //                     }
    //         //                   },
    //         //                 ),
    //         //               ),
    //         //
    //         //               InkWell(
    //         //                 onTap: (){
    //         //                   Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePassword()));
    //         //                 },
    //         //                   child: Padding(
    //         //                     padding: const EdgeInsets.all(8.0),
    //         //                     child: Text("Forget Password?",style: TextStyle(color: colors.secondary),),
    //         //                   )),
    //         //               SizedBox(height: 40,),
    //         //               Padding(
    //         //                 padding: const EdgeInsets.only(right:10.0),
    //         //                 child: Btn(
    //         //                     height: 50,
    //         //                     width: 350,
    //         //                     title: 'Sign in',
    //         //                     onPress: () {
    //         //                       if (_formKey.currentState!.validate()) {
    //         //                         Navigator.push(context,
    //         //                             MaterialPageRoute(builder: (context) =>SignupScreen()));
    //         //                       } else {
    //         //                         const snackBar = SnackBar(
    //         //                           content: Text('All Fields are required!'),
    //         //                         );
    //         //                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //         //                         //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    //         //                       }
    //         //
    //         //                     }
    //         //
    //         //                 ),
    //         //               ),
    //         //             ],
    //         //           ),
    //         //         )
    //         //           : SizedBox.shrink(),
    //         //           selectedIndex == 2?
    //         //           Form(
    //         //             key: _formKey,
    //         //             child: Column(
    //         //               children: [
    //         //                 Card(
    //         //                   shape: RoundedRectangleBorder(
    //         //                     borderRadius: BorderRadius.circular(10.0),
    //         //                   ),
    //         //                   elevation: 5,
    //         //                   child: TextFormField(
    //         //                     maxLength: 10,
    //         //                     maxLines: 1,
    //         //                     controller: mobileController,
    //         //                     keyboardType: TextInputType.number,
    //         //                     decoration: InputDecoration(
    //         //                         counterText: "",
    //         //                         prefixIcon: Icon(Icons.perm_identity_sharp,color: colors.secondary),
    //         //                         hintText: 'Mobile ',hintStyle: TextStyle(fontSize: 15.0, color: colors.secondary),
    //         //                         border: InputBorder.none,
    //         //                         contentPadding: EdgeInsets.only(left: 10,top: 12)
    //         //                     ),
    //         //                     validator: (v) {
    //         //                       if (v!.isEmpty) {
    //         //                         return "Mobile is required";
    //         //                       }
    //         //
    //         //                     },
    //         //                   ),
    //         //                 ),
    //         //                 SizedBox(height: 40,),
    //         //                 Btn(
    //         //                     height: 50,
    //         //                     width: 350,
    //         //                     title: 'Send OTP',
    //         //                     onPress: () {
    //         //                       if (_formKey.currentState!.validate()) {
    //         //                         Navigator.push(context,
    //         //                             MaterialPageRoute(builder: (context) =>VerifyOtp()));
    //         //                       } else {
    //         //                         const snackBar = SnackBar(
    //         //                           content: Text('All Fields are required!'),
    //         //                         );
    //         //                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //         //                         //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    //         //                       }
    //         //                     }
    //         //
    //         //                 ),
    //         //               ],
    //         //             ),
    //         //           ) : SizedBox.shrink(),
    //         //          //  SizedBox(height: 30,),
    //         //          // Btn(
    //         //          //    height: 50,
    //         //          //    width: 320,
    //         //          //    title: selectedIndex==1?'Sign in': 'Send OTP',
    //         //          //    onPress: () {
    //         //          //      if (_formKey.currentState!.validate()) {
    //         //          //      } else {
    //         //          //        // Navigator.push(context,
    //         //          //        //     MaterialPageRoute(builder: (context) =>LoginScreen()));
    //         //          //        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    //         //          //      }
    //         //          //        const snackBar = SnackBar(
    //         //          //          content: Text('All Fields are required!'),
    //         //          //        );
    //         //          //        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //         //          //
    //         //          //      }
    //         //          //
    //         //          //  ),
    //         //         ],
    //         //       ),
    //         //     )
    //         //   ],
    //         // ),
    //       ),
    // ]
    //   ),
    //
    //
    // );
  }

  void sendLoginOtpApi() async {
    try {
      await App.init();
      Map param = {
        "mobile":mobileCtr.text,
      };

      var response =
      await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}send_otp"), param);
      setState(() {
        loading = false;
      });
      if (!response['error']) {

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:response['otp'].toString(),mobile: mobileCtr.text,title: 'login'),));
        }
      } else {
        setSnackbar(response['message'], context);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }


}
