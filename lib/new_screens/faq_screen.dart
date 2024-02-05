import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';

import '../Model/faq_model.dart';



class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<FAQModel> faqList = [];
  void getTerms()async{
    try{
      await App.init();
      Map param = {
        "id":"3",
      };

      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}faq"), param);
      setState(() {
        loading =false;
      });
      if(response['status']=="1"){
        for(var v in response['setting']){
          setState(() {
            faqList.add(FAQModel.fromJson(v));
          });
        }


      }else{
        setSnackbar(response['msg'], context);
      }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTerms();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "FAQ",
        ),
      ),
      body: faqList.isEmpty? Center(child: Text('Data Not Available'),)
          :   ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: faqList.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text("${faqList[index].title}"),
                  subtitle:
                  Text("${faqList[index].description}",
                    style: TextStyle(
                        fontSize: 12,),
                  ),

                ),
                index != 2
                    ? Divider(thickness: 6)
                    : SizedBox.shrink(),
              ],
            );
          }),
    );
  }
}
