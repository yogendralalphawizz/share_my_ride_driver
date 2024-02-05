
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:http/http.dart' as http;

import '../DrawerPages/notification_list.dart';
import '../Model/NotificationModel.dart';
import '../utils/Session.dart';
import '../utils/location_details1.dart';




class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}



class _NotificationsPageState extends State<NotificationsPage> {



  @override
  void initState() {
    // TODO: implement initState
    getNotification();
    super.initState();
  }
  bool loading = true;
  NotificationModel notificationModel=NotificationModel();
  getNotification() async {
    print("_____________________");
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        setState(() {
          loading = true;
        });
        data = {
          "driver_id": curUserId,
        };
        var res = await http
            .post(Uri.parse(baseUrl + "notifications"), body: data);

        print(data);
        print(res.body.toString()+"_____________________");
        var data1=jsonDecode(res.body);
        notificationModel=NotificationModel.fromJson(data1);
        setState(() {

        });
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Notification",
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => BusBookingPage(),));
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => NotificationsPage()));
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
      ),
      body:
      ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: notificationModel.data?.length??0,
          itemBuilder: (context, index) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                elevation: 0.5,
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${notificationModel.data?[index].title}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text( "${notificationModel.data?[index].date}",),

                    ],
                  ),
                  trailing:
                  Text("${notificationModel.data?[index].type??""}"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text( "${notificationModel.data?[index].message}",)
                  ),

                ),
              ),
            );
          }),
    );
  }
}
