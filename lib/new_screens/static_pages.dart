

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smr_driver/Model/static_model.dart';





import 'package:smr_driver/utils/ApiBaseHelper.dart';

import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';


import '../utils/Session.dart';



class StaticPageScreen extends StatefulWidget {
  String title,type;

  StaticPageScreen(this.title, this.type);

  @override
  State<StaticPageScreen> createState() => _StaticPageScreenState();
}

class _StaticPageScreenState extends State<StaticPageScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStaticPage();
  }
  StaticModel? model;
  void getStaticPage()async{
    setState(() {
      loading = true;
    });
    Map param = {
      'id': widget.type,

    };
    Map response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}static_pages"), param);
    setState(() {
      loading = false;
    });
    if(response['status']=="1"){
      var v = response['setting'];
      model = StaticModel.fromJson(v);
    }else{
      setSnackbar("Something went wrong", context);
    }
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
          widget.title,
        ),
      ),
      body: SafeArea(
        child: !loading?model!=null?SingleChildScrollView(
          child: Container(
            child: Html(
              data: model!.html ?? ""
            ),
          ),
        ):const SizedBox():const Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;

}
