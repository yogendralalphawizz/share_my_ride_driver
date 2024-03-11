
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smr_driver/new_screens/add_vechicle.dart';

import '../Model/vehicle_model_list.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../utils/constant.dart';

class VehicleList extends StatefulWidget {

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  VehicleListModel vehicleListModel=VehicleListModel();

  bool isloading=false;

  Future<void> getVehicleList() async {
    isloading=true;
    setState(() {

    });
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
      log('${result}________');
      vehicleListModel = VehicleListModel.fromJson(jsonDecode(result));
      isStatus="${vehicleListModel.data?.first.status}";
      print(vehicleListModel.data?.first.status);
      enablelist.clear();
      if(vehicleListModel.data?.isNotEmpty??false) {
        for (int i = 0; i < vehicleListModel.data!.length; i++) {
          enablelist.add(vehicleListModel.data?[i].status);
        }
      }
      isloading=false;

      setState(() {




      });
    } else {
      isloading=false;
      setState(() {

      });
      throw Exception("Failed to load suggestions");
    }
  }

  Future<void> updateStatusVehicle(String status,String id) async {

    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseUrl}update_bus_status"));

    request.fields.addAll({
      'driver_id': "${id}",
      "status":"${status}"

    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.fields}________');
    if (response.statusCode == 200) {

    } else {
      throw Exception("Failed to load suggestions");
    }
  }

  Future<void> deleteVehicle(String id) async {

    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseUrl}delete_vehicle"));

    request.fields.addAll({
      'bus_id': "${id}",
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.fields}________');
    if (response.statusCode == 200) {
      getVehicleList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleList();
  }
  String isStatus="0";
  List enablelist=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColorName.primaryDark,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Vehicle List",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:Colors.white),
        ),
      ),
      body:isloading==true?Center(child: CircularProgressIndicator(),): Column(
        children: [

        boxHeight(
          context,
          2,
        ),
        Expanded(
          child: ListView.builder(
              itemCount:vehicleListModel.data?.length??0 ,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return  InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => AddvehicleDetails(vehicleData: vehicleListModel.data?[index],isupdate: true,)));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 14),
                      height: 150,
                      child:Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Name:",style: TextStyle(color: Colors.black,fontSize: 20),),
                                    Text("${vehicleListModel.data?[index].name}",style: TextStyle(color: Colors.black,fontSize: 20),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Type:",style: TextStyle(color: Colors.black,fontSize: 20),),
                                    Text("${vehicleListModel.data?[index].type}",style: TextStyle(color: Colors.black,fontSize: 20),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("No of seat:",style: TextStyle(color: Colors.black,fontSize: 20),),
                                    Text("${vehicleListModel.data?[index].noOfSeat}",style: TextStyle(color: Colors.black,fontSize: 20),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text("Amount:",style: TextStyle(color: Colors.black,fontSize: 20),),
                                      Text("${vehicleListModel.data?[index].amount}",style: TextStyle(color: Colors.black,fontSize: 20),),
                                    ],),

                                  ],
                                ),
                            
                            
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(

                              children: [
                                Text("Status"),
                                Switch(

                                  onChanged: (value){
                                    enablelist[index]=value==true?"1":"0";
                                    setState(() {

                                    });
                                    updateStatusVehicle(enablelist[index],"${vehicleListModel.data?[index].id}");

                                  },
                                  value: enablelist[index]=="1"?true:false,
                                  activeColor: Colors.green,
                                  // activeTrackColor: Colors.green,
                                  inactiveThumbColor: Colors.red,

                                ),
                                IconButton(icon: Icon(Icons.delete, color: MyColorName.mainColor),onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: Text("Delete Vehicle"),
                                          content: Text(
                                              "Do you want to delete?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  Colors.red,
                                                  shadowColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                ),
                                                child: Text(
                                                  "No",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 14),
                                                )),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  deleteVehicle(vehicleListModel.data?[index].id ?? '');
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  Colors.green,
                                                  shadowColor:
                                                  Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                ),
                                                child: Text(
                                                  "Yes",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 14),
                                                )),
                                          ],
                                        );
                                      });
                                },)
                              ],
                            ),
                          ),
                        ],
                      ) ,
                    ),
                  ),
                );
              }),
        )
      ],),
    );
  }
}
