import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:smr_driver/Components/custom_button.dart';

import '../Model/get_withdrawel_request.dart';
import '../Model/user_model.dart';
import '../utils/PushNotificationService.dart';
import '../utils/Session.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../utils/constant.dart';


class MyWallet extends StatefulWidget {
  UserModel? getprofile;
  MyWallet({required this.getprofile});
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  GetWithdrawelModel getWithdrawelModel=GetWithdrawelModel();

  void getWalletApi(String userid) async {
    try {
      Map param = {
        "user_id":curUserId,

      };

      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_withdrawal_request"), param);
      print(response.toString()+"GGGGGGGGGGGGGGGGFTFGGGGGGGGGG");
      getWithdrawelModel=GetWithdrawelModel.fromJson(response);
      print(getWithdrawelModel.data?.length);
      setState(() {

      });

    } catch (e) {

    } finally {

    }
  }

  void withdrawalRequest(String amount, String acno,String bankname,String ifsccode,String actype,String acname) async {
    try {
      Map param = {
        "user_id":curUserId,

        "payment_address":jsonEncode({"ac_no": "${acno}", "bank_name": "${bankname}", "ifsc_code": "${ifsccode}", "account_type": "${actype}", "ac_holder_name": "${acname}"})
       , "amount":"${100}"
      };

      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}send_withdrawal_request"), param);
      print(response.toString()+"GGGGGGGGGGGGGGGGFTFGGGGGGGGGG");
     if(response["error"]==false){
       setSnackbar("Withdrawal Request Sent Successfully", context);
     }
     else{
       setSnackbar("${response["message"]}", context);
     }
      setState(() {

      });

    } catch (e) {

    } finally {

    }
  }




  void showAccountDetailsDialog(BuildContext context) {
    TextEditingController accountNumberController = TextEditingController();
    TextEditingController accountNameController = TextEditingController();
    TextEditingController ifscCodeController = TextEditingController();
    TextEditingController accountTypeController = TextEditingController();
    TextEditingController bankNameController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Details'),
          content: Container(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: accountNameController,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
              
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Account Name",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
              
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
                    1,
                  ),  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: bankNameController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
              
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Bank Name",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
              
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
                    1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: accountNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
              
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Account Number",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
              
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
                    1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: ifscCodeController,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
              
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Ifsc Code",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
              
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
                    1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: accountTypeController,
                      keyboardType: TextInputType.text,
                      maxLength: 10,
              
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Account Type",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
              
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
                    1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          2,
                        )),
                    child: TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.text,
                      maxLength: 10,

                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Amount",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),

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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Process the entered data here
                String accountNumber = accountNumberController.text;
                String accountName = accountNameController.text;
                String ifscCode = ifscCodeController.text;
                String accountType = accountTypeController.text;
                String bankName = bankNameController.text;

                // Do something with the entered data (e.g., validation, saving, etc.)

                // Close the dialog
                if(accountNumberController.text==""){
                  setSnackbar("Please enter accountNumber", context);
                  return;
                }
                if(accountNameController.text==""){
                  setSnackbar("Please enter accountName", context);
                  return;
                }
                if(ifscCodeController.text==""){
                  setSnackbar("Please enter ifscCode", context);
                  return;
                }
                if(bankNameController.text==""){
                  setSnackbar("Please enter bankName", context);
                  return;
                }
                if(amountController.text==""){
                  setSnackbar("Please enter bankName", context);
                  return;
                }
                withdrawalRequest(amountController.text, "${accountNumber}", "${bankName}", "${ifscCode}", "${accountType}", "${accountName}");

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getWallet();
    getWalletApi(curUserId.toString());

  }
  Map stringcpnvertmap(String data) {
    String jsonData = "${data}";

    // Convert JSON string to a Map
    Map<String, dynamic> dataMap = json.decode(jsonData);

    // Convert Map back to a string
    String properString = dataMap.toString();

    print(properString);
    return dataMap;
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
          "My Wallet",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:Colors.white),
        ),
      ),
      body:
      FadedSlideAnimation(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                      height: 90,
                      width: 170,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, border: Border.all(color: MyColorName.mainColor)),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                              children:[
                                Text(
                                  "Current Balance",
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 4,
                                ),

                                Text('\₹' + "${widget.getprofile?.wallet??0}",
                                    style: Theme.of(context).textTheme
                                        .headline4!
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.center),
                              ]))),
                  // Text(
                  //   "Your Balance",
                  //   style: Theme.of(context).textTheme.bodyText2,
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 4,
                  // ),
                  // Text('\₹' + balance.toString(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline4!
                  //         .copyWith(color: blackColor),
                  //     textAlign: TextAlign.center),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  // Image.asset("assets/mywallet.jpg", height: 300, width: 300,),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            commonButton(
              width: 70,
              onPressed: () {
                showAccountDetailsDialog(context);
              },
              loading: false,
              title: "Withdrawal Request",
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: getWithdrawelModel.data?.length??0,
                  itemBuilder: (context,index){
                   Map data= stringcpnvertmap("${getWithdrawelModel.data?[index].bankDetails??0}");
                    return  Card(
                      child: ListTile(

                        title:Text("${getWithdrawelModel.data?[index].amount??0}") ,
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Text("Ac/No :"),
                                Text("${data["ac_no"]}",maxLines: 1),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Ac/Name :"),
                                Text("${data["bank_name"]}",maxLines: 1),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Ifsc Code :"),
                                Text("${data["ifsc_code"]}",maxLines: 1),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Ac/Holder Name :"),
                                Text("${data["ac_holder_name"]}",maxLines: 1,),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Ac/Type :"),
                                Text("${data["account_type"]}",maxLines: 1),
                              ],
                            ),
                          ],
                        ),
                        trailing: Text("${getWithdrawelModel.data?[index].createdAt??0}"),
                      ),
                    );
                  }),
            )

          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

}
