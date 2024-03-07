

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smr_driver/Model/user_model.dart';
import 'package:smr_driver/new_screens/add_vechicle.dart';
import 'package:smr_driver/new_screens/edit_profile_screen.dart';
import 'package:smr_driver/new_screens/faq_screen.dart';
import 'package:smr_driver/new_screens/splash_screen.dart';
import 'package:smr_driver/new_screens/static_pages.dart';
import 'package:smr_driver/new_screens/vehicle_list.dart';
import 'package:smr_driver/new_screens/wallet_screen.dart';
import 'package:smr_driver/utils/Session.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:smr_driver/utils/custom_profile.dart';

import 'package:http/http.dart' as http;






import '../Model/vehicle_model_list.dart';
import '../utils/ApiBaseHelper.dart';
import 'change_password.dart';
import 'notifications_page.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  void initState() {
    super.initState();
    getVehicleList();
  }
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  VehicleListModel vehicleListModel=VehicleListModel();
  void getUserDetail()async{
    setState(() {
      loading = true;
    });
    Map param = {
      'driver_id': curUserId,

    };
    Map response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}get_driver_detail"), param);
    setState(() {
      loading = false;
    });
    if(response['status']){
      for(var v in response['data']){
        userModel = UserModel.fromJson(v);

      }
    }else{
      setSnackbar("Something went wrong", context);
    }
  }
  Future<void> getVehicleList() async {

    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseUrl}get_vehicles"));
    request.fields.addAll({
      'driver_id': "${curUserId}"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.fields}________');
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      vehicleListModel = VehicleListModel.fromJson(json.decode(result));

     // print(vehicleListModel.data?.length);
      setState(() {




      });
    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child:  userModel != null ?Image.network(
              "${userModel!.proPic}",fit: BoxFit.fill,):const SizedBox(),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Profile",
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
      backgroundColor: MyColorName.scaffoldColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage('${userModel?.proPic??""}')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userModel!.name}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${userModel!.email}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: ()async {
                       var result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()));
                       if(result!=null){
                         getUserDetail();
                       }
                      },
                      child: CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Notifications ',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => NotificationsPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Help Desk? ',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => StaticPageScreen("Help", "6")));

                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Add Vehicle',

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => AddvehicleDetails(isupdate: false,)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'List Vehicle',

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => VehicleList()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Change Password',

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ChangePassword()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Wallet',

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => MyWallet(getprofile: userModel))).then((value) {
                        getUserDetail();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Rate us ',

                onTap: () {

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Terms & Conditions ',

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => StaticPageScreen("Terms & Conditions", "3")));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Privacy Policy ',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => StaticPageScreen("Privacy Policy", "4")));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'FAQs',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => FAQScreen()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Logout',
                onTap: () {
                  showDialog(context: context, builder: (ctx){
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Do you want to proceed?"),
                      actions: [
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shadowColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              "No",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white,fontSize: 14),
                            )
                        ),
                        ElevatedButton(
                            onPressed: ()async{
                              await App.init();
                              App.localStorage.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("User Logout")));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()),
                                      (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              "Yes",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white,fontSize: 14),
                            )
                        ),
                      ],
                    );
                  });

                },
              ),
            ),
            SizedBox(
              height: 17,
            ),
          ],
        ),
      ),
    );
  }

}
