import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';

import 'package:intl/intl.dart';


import 'package:smr_driver/Model/state_model.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../Model/get_setting_model.dart';
import '../Model/location_search_model.dart';
import '../Model/taluka_model.dart';
import '../Model/vehicle_model_list.dart';
import '../Model/village_model.dart';
import '../utils/Session.dart';
import '../utils/location_details1.dart';

class AddvehicleDetails extends StatefulWidget {
  VehicleData ?vehicleData;
  bool isupdate;

  AddvehicleDetails({this.vehicleData,required this.isupdate});

  @override
  State<AddvehicleDetails> createState() => _AddvehicleDetailsState();
}

class _AddvehicleDetailsState extends State<AddvehicleDetails> {
  List<String> method = ["Auto", "Bus", "Car"];
  List<String> seatBusNo = [
    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24",
    "25","26","27","28","29","30","31","32","33", "34", "35",  "36",  "37",  "38",  "39",  "40",  "41",  "42",  "43",  "44",  "45",  "46",
    "47","48","49","50","51","52","53","54","55", "56", "57", "58", "59", "60",  "61",  "62",
    "63",  "64",  "65",



  ];
  List<String> seatCarNo = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",


  ];
  List<String> seatAutoNo = [
    "1",
    "2",
    "3",


  ];
  Future<void>deleteStopage(String id) async {
    setState(() {

    });
    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseUrl}trash_stoppage"));
    request.fields.addAll({
      'id': "${id}"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.fields}________');
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('${result}________');

      setSnackbar("Stopage Delete Succesfully", context);

      setState(() {




      });
    } else {
      setSnackbar("Failed", context);
      setState(() {

      });
      throw Exception("Failed to load suggestions");
    }
  }
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  LocationsearchModel locationsearchModel=LocationsearchModel();
  Future<void> getSuggestions() async {
    isloading=true;
    setState(() {

    });

    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${baseUrl}get_location"));
    request.fields.addAll({
      'search_text': ""
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.fields}________');
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
       locationsearchModel = LocationsearchModel.fromJson(json.decode(result));
      // locationsearchModel.data?.firstWhere((element) {
      //
      //   print("${element.id=="71"}"+"JJJJJJJJJJJJJJJJJJJJJJJJJJJ");
      //   if("${element.id}"=="71"){
      //     return true;
      //   }
      //   return false;
      // });

      setState(() {

      });
      widget.isupdate?getupadte():updatebool();

    } else {
      throw Exception("Failed to load suggestions");
    }
  }
  updatebool(){
    isloading=false;
    setState(() {

    });
  }
  List<String> selectType = ["AC", "Non AC","Sleeper"];
  List<String> selectTypecar = ["AC", "Non AC"];

  String selectMethod = "Auto";
  TextEditingController price = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController bikeNumberCon = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController startdate = TextEditingController();
   List<TextEditingController> startTimecon=[];
  List<TextEditingController> endTimecon=[];
  List stopage=[];
  List pricelist=[];

  List<dynamic> dropDowncity=[];
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
  List stopageid=[];
  GetSettingModel getSettingModel = GetSettingModel();
  VilliageModel villiageModel = VilliageModel();
  TalukaModel talukaModel = TalukaModel();
  String ?imageurl;

  final TextEditingController searchCitycn = TextEditingController();
getupadte(){
  isloading=true;
  setState(() {

  });
    seatNoid=widget.vehicleData?.type=="car"?seatBusNo.firstWhere((element) => element.toString()==widget.vehicleData?.noOfSeat):
        seatBusNo.firstWhere((element) => element.toString()==widget.vehicleData?.noOfSeat);
    selectMethod="${widget.vehicleData?.type.toString()[0].toUpperCase()}"+"${widget.vehicleData?.type.toString().substring(1)}";
    price.text=widget.vehicleData?.amount.toString()??"";
    nameCon.text=widget.vehicleData?.name.toString()??"";
    bikeNumberCon.text=widget.vehicleData?.vehicleNo.toString()??"";
 selectMethod=="Auto"?null: selectTypeac=selectType.firstWhere((element) => element==widget.vehicleData?.busType.toString());
    fromaddid=locationsearchModel.data?.firstWhere((element) => element.id==widget.vehicleData?.address);
  imageurl=widget.vehicleData?.profileImage??"";
    toaddid=locationsearchModel.data?.firstWhere((element) => element.id==widget.vehicleData?.toAddress);
  selectMethod=="Auto"?null:  startTime.text=widget.vehicleData?.startTime.toString()??"";
  selectMethod=="Auto"?null: endTime.text=widget.vehicleData?.endTime.toString()??"";

     startdate.text=widget.vehicleData?.date.toString()??"";
  stopage.clear();
  dropDowncity.clear();
  startTimecon.clear();
  endTimecon.clear();
  pricelist.clear();
     for(int i=0;i<widget.vehicleData!.stopageData!.length;i++){

       stopage.add(1);
       dropDowncity.add(null);
       startTimecon.add(TextEditingController());
       endTimecon.add(TextEditingController());
       pricelist.add(TextEditingController());
       stopageid.add(widget.vehicleData!.stopageData?[i].id);
       print(widget.vehicleData!.stopageData?[i].stop.toString().trim());
       dropDowncity[i]=locationsearchModel.data?.firstWhere((element) => element.id==widget.vehicleData!.stopageData?[i].stop.toString().trim());
       startTimecon[i].text=widget.vehicleData!.stopageData?[i].stopFromtime.toString()??"";
       endTimecon[i].text=widget.vehicleData!.stopageData?[i].stopTotime.toString()??"";
       pricelist[i].text=widget.vehicleData!.stopageData?[i].charge.toString()??"";

       setState(() {

       });
     }
  isloading=false;

    setState(() {

    });
}
  File? profileImage;

  Future getImage(BuildContext context, int pos) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File tempFile = File(result.files.first.path!);

        setState(() {
          profileImage =tempFile;
        });

    } else {
      // User canceled the picker
    }

    /* var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      imageQuality: 40,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    groupImage = File(image.path);*/
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuggestions();
    // GetLocation getLocation=GetLocation();
    //
    //   getLocation.requestLocationPermission();
    // widget.isupdate?getupadte():null;


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
          "Add Vehicle",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:Colors.white),
        ),
      ),
      body:isloading?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        child: Column(
          children: [

            boxHeight(
              context,
              3,
            ),
            Column(
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  spacing: getWidth(
                    context,
                    3,
                  ),
                  runSpacing: getHeight(context, 2),
                  children: method.map((e) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          value: e,
                          groupValue: selectMethod,
                          activeColor: MyColorName.primaryDark,
                          onChanged: (val) {
                            setState(() {
                              selectMethod = e;
                            });
                          },
                        ),
                        Text(
                          e,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium!,
                        ),
                      ],
                    );
                  }).toList(),
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
                    controller: nameCon,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Vehicle Name",
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

                boxHeight(context, 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                        context,
                        8,
                      )),
                  child: TextFormField(
                    controller: bikeNumberCon,
                    keyboardType: TextInputType.text,
                    maxLength: 10,

                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Vehicle No",
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
                boxHeight(context, 2),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                  child: TextFormField(
                    //controller: addressCon,
                    readOnly: true,
                    onTap: () async {
                      final DateTime ?picked = await showDatePicker(
                        context: context,
                        initialDate:  DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (picked != null ) {
                        print(picked);
                        setState(() {
                       //   _selectedDate = picked;
                          startdate.text = "${picked.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: startdate,
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Date",
                      counterText: '',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.date_range,
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
                boxHeight(context, 2),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                  child: TextFormField(
                    //controller: addressCon,
                    readOnly: true,
                    onTap: (){
                      getImage(context, 1);
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Vehicle Image",
                      counterText: '',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.photo,
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
                  profileImage!=null?


                  Image.file(profileImage!,width: 300,height: 100,):imageurl!=null? Image.network(imageurl??"",width: 300,height: 100,):const SizedBox(),
                boxHeight(context, 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                        context,
                        6,
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(
                            context,
                            2,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(
                              context,
                              4,
                            )),
                            child: DropdownButton<dynamic>(
                              hint: Text(
                                "Seat No",
                                style: TextStyle(color: Colors.black87),
                              ),
                              value: seatNoid,
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: MyColorName.primaryDark,
                              ),
                              items:selectMethod=="Car"?
                              seatCarNo.map((value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList():selectMethod=="Auto"?seatAutoNo.map((value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList():
                              seatBusNo.map((value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: ( value) {
                                setState(() {
                                  seatNoid = value;

                                });

                              },
                            ),
                          ),
                        ),
                      ),
                    selectMethod=="Auto"?SizedBox.shrink():  Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(
                            context,
                            2,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(
                              context,
                              4,
                            )),
                            child: DropdownButton<String>(
                              hint: Text(
                                "Select AC/Non AC",
                                style: TextStyle(color: Colors.black87),
                              ),
                              value: selectTypeac,
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: MyColorName.primaryDark,
                              ),
                              items:selectMethod=="Car"?selectTypecar.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList():
                              selectType.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectTypeac = value;

                                });

                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // boxHeight(
                //   context,
                //   2,
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: getWidth(
                //     context,
                //     8,
                //   )),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: MyColorName.colorBg2,
                //       borderRadius: BorderRadius.circular(8.0),
                //     ),
                //     padding: EdgeInsets.symmetric(
                //         horizontal: getWidth(
                //       context,
                //       4,
                //     )),
                //     child: DropdownButton<dynamic>(
                //       hint: Text(
                //         "Select city",
                //         style: TextStyle(color: Colors.black87),
                //       ),
                //       value:cityId,
                //       icon: Icon(
                //         Icons.keyboard_arrow_down_outlined,
                //         color: MyColorName.primaryDark,
                //       ),
                //       items:  locationsearchModel.data?.map((value) {
                //         return DropdownMenuItem<dynamic>(
                //           value: value,
                //           child: Text(value.name??""),
                //         );
                //       }).toList(),
                //       isExpanded: true,
                //       underline: SizedBox(),
                //       onChanged: (value) {
                //         setState(() {
                //           cityId = value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColorName.colorBg2,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          4,
                        )),
                    child:
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<dynamic>(
                        isExpanded: true,
                        hint: Text(
                          "From Address",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: locationsearchModel.data
                            ?.map((item) => DropdownMenuItem<dynamic>(
                          value: item,
                          child: Text(
                            item.name??"",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: MyColorName.primaryDark,
                          ),
                        ),

                        value: fromaddid,
                        onChanged: (value) {
                          setState(() {
                            fromaddid=value;
                          });
                        },

                        // buttonStyleData: const ButtonStyleData(
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   height: 40,
                        //   width: 200,
                        // ),
                        // dropdownStyleData: const DropdownStyleData(
                        //   maxHeight: 200,
                        // ),
                        // menuItemStyleData: const MenuItemStyleData(
                        //   height: 40,
                        // ),

                        dropdownSearchData: DropdownSearchData(
                          searchController: searchCitycn,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: searchCitycn,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search City  ',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            print("Search Value: ${searchValue}");
                            print("Item Value: ${item.value.name}");


                            //  print("${item.value.toString().toLowerCase().contains(searchValue.toLowerCase())}"+"88888888");
                            return item.value.name.toString().toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            searchCitycn.clear();
                          }
                        },

                      ),
                    ),

                  ),
                ),
                boxHeight(context, 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                        context,
                        6,
                      )),
                  child: Row(
                    children: [

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(
                            context,
                            2,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(
                              context,
                              4,
                            )),
                            child:  DropdownButtonHideUnderline(
                              child: DropdownButton2<dynamic>(
                                isExpanded: true,
                                hint: Text(
                                  "To Address",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: locationsearchModel.data
                                    ?.map((item) => DropdownMenuItem<dynamic>(
                                  value: item,
                                  child: Text(
                                    item.name??"",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: MyColorName.primaryDark,
                                  ),
                                ),

                                value: toaddid,
                                onChanged: (value) {
                                  setState(() {
                                    toaddid = value;

                                  });
                                },

                                // buttonStyleData: const ButtonStyleData(
                                //   padding: EdgeInsets.symmetric(horizontal: 16),
                                //   height: 40,
                                //   width: 200,
                                // ),
                                // dropdownStyleData: const DropdownStyleData(
                                //   maxHeight: 200,
                                // ),
                                // menuItemStyleData: const MenuItemStyleData(
                                //   height: 40,
                                // ),

                                dropdownSearchData: DropdownSearchData(
                                  searchController: searchCitycn,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: searchCitycn,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search City  ',
                                        hintStyle: const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    print("Search Value: ${searchValue}");
                                    print("Item Value: ${item.value.name}");


                                    //  print("${item.value.toString().toLowerCase().contains(searchValue.toLowerCase())}"+"88888888");
                                    return item.value.name.toString().toLowerCase().contains(searchValue.toLowerCase());
                                  },
                                ),
                                //This to clear the search value when you close the menu
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    searchCitycn.clear();
                                  }
                                },

                              ),
                            ),


                            // DropdownButton<dynamic>(
                            //   hint: Text(
                            //     "To Address",
                            //     style: TextStyle(color: Colors.black87),
                            //   ),
                            //   value: toaddid,
                            //   icon: Icon(
                            //     Icons.keyboard_arrow_down_outlined,
                            //     color: MyColorName.primaryDark,
                            //   ),
                            //   items: locationsearchModel.data?.map(( value) {
                            //     return DropdownMenuItem<dynamic>(
                            //       value: value,
                            //       child: Text(value.name!),
                            //     );
                            //   }).toList(),
                            //   isExpanded: true,
                            //   underline: SizedBox(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       toaddid = value;
                            //
                            //     });
                            //
                            //   },
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                boxHeight(context, 2),
                selectMethod=="Auto"?SizedBox.shrink():  Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                        context,
                        6,
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(
                            context,
                            2,
                          )),
                          child: TextFormField(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );

                              if (pickedTime != null) {
                                print(pickedTime
                                    .format(context)); // Output: 10:51 PM
                                DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString());
                                print(
                                    parsedTime); // Output: 1970-01-01 22:53:00.000
                                String formattedTime =
                                    DateFormat('HH:mm').format(parsedTime);
                                print(formattedTime); // Output: 14:59:00
                                startTime.text = formattedTime;
                              } else {
                                print("Time is not selected");
                              }
                            },
                            controller: startTime,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              fillColor: MyColorName.colorBg2,
                              filled: true,
                              labelText: "Start Time",
                              counterText: '',
                              labelStyle: TextStyle(color: Colors.black87),
                              // prefixIcon: IconButton(
                              //   onPressed: null,
                              //   icon: Icon(
                              //     Icons.call,
                              //     color: MyColorName.primaryDark,
                              //   ),
                              // ),
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(
                            context,
                            2,
                          )),
                          child: TextFormField(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );

                              if (pickedTime != null) {
                                print(pickedTime
                                    .format(context)); // Output: 10:51 PM
                                DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString());
                                print(
                                    parsedTime); // Output: 1970-01-01 22:53:00.000
                                //for am pm 12 hour time=hh:mm: a
                                String formattedTime =
                                DateFormat('HH:mm').format(parsedTime);
                                print(formattedTime); // Output: 14:59:00
                                endTime.text = formattedTime;
                              } else {
                                print("Time is not selected");
                              }
                            },
                            controller: endTime,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              fillColor: MyColorName.colorBg2,
                              filled: true,
                              labelText: " End Time",
                              counterText: '',
                              labelStyle: TextStyle(color: Colors.black87),
                              // prefixIcon: IconButton(
                              //   onPressed: null,
                              //   icon: Icon(
                              //     Icons.call,
                              //     color: MyColorName.primaryDark,
                              //   ),
                              // ),
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
                      ),
                    ],
                  ),
                ),

                boxHeight(context, 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(
                        context,
                        8,
                      )),
                  child: TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Rent",
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
            boxHeight(
              context,
              2,
            ),

            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(
                          context,
                          6,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(" Stopage "),
                      InkWell(
                        onTap: (){
                          stopage.add(1);
                          startTimecon.add(TextEditingController());
                          endTimecon.add(TextEditingController());
                          dropDowncity.add(null);
                          pricelist.add(TextEditingController());
                          setState(() {

                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: MyColorName.mainColor,
                            child: Icon(Icons.add)),
                      )
                    ],),
                  ),
                  boxHeight(
                    context,
                    3,
                  ),
                  for(int i=0;i<stopage.length;i++)...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(
                                    context,
                                    8,
                                  )),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: MyColorName.colorBg2,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getWidth(
                                      context,
                                      4,
                                    )),
                                child:
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<dynamic>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Select City',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: locationsearchModel.data
                                        ?.map((item) => DropdownMenuItem<dynamic>(
                                      value: item,
                                      child: Text(
                                        item.name??"",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: MyColorName.primaryDark,
                                      ),
                                    ),
                        
                                    value: dropDowncity[i],
                                    onChanged: (value) {
                                      setState(() {
                                        dropDowncity[i] = value;
                                      });
                                    },
                        
                                    // buttonStyleData: const ButtonStyleData(
                                    //   padding: EdgeInsets.symmetric(horizontal: 16),
                                    //   height: 40,
                                    //   width: 200,
                                    // ),
                                    // dropdownStyleData: const DropdownStyleData(
                                    //   maxHeight: 200,
                                    // ),
                                    // menuItemStyleData: const MenuItemStyleData(
                                    //   height: 40,
                                    // ),
                        
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: searchCitycn,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 50,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 8,
                                          left: 8,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: searchCitycn,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            hintText: 'Search City  ',
                                            hintStyle: const TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        print("Search Value: ${searchValue}");
                                        print("Item Value: ${item.value.name}");


                                     //  print("${item.value.toString().toLowerCase().contains(searchValue.toLowerCase())}"+"88888888");
                                        return item.value.name.toString().toLowerCase().contains(searchValue.toLowerCase());
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        searchCitycn.clear();
                                      }
                                    },
                        
                                  ),
                                ),
                        
                              ),
                            ),
                            boxHeight(
                              context,
                              3,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(
                                    context,
                                    6,
                                  )),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getWidth(
                                            context,
                                            2,
                                          )),
                                      child: TextFormField(
                                        onTap: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            context: context,
                                          );
                        
                                          if (pickedTime != null) {
                                            print(pickedTime
                                                .format(context)); // Output: 10:51 PM
                                            /*DateTime parsedTime = DateFormat.jm().parse(
                                                pickedTime.format(context).toString());
                                            print(
                                                parsedTime); // Output: 1970-01-01 22:53:00.000
                                            String formattedTime =
                                            DateFormat('HH:mm').format(parsedTime);
                                            print(formattedTime);*/ // Output: 14:59:00
                                            startTimecon[i].text = pickedTime
                                                .format(context);
                                          } else {
                                            print("Time is not selected");
                                          }
                                        },
                                        controller: startTimecon[i],
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          fillColor: MyColorName.colorBg2,
                                          filled: true,
                                          labelText: "Start Time",
                                          counterText: '',
                                          labelStyle: TextStyle(color: Colors.black87),
                                          // prefixIcon: IconButton(
                                          //   onPressed: null,
                                          //   icon: Icon(
                                          //     Icons.call,
                                          //     color: MyColorName.primaryDark,
                                          //   ),
                                          // ),
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
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getWidth(
                                            context,
                                            2,
                                          )),
                                      child: TextFormField(
                                        onTap: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            initialTime: TimeOfDay.now(),
                                            context: context,
                                          );
                        
                                          if (pickedTime != null) {
                                            print(pickedTime
                                                .format(context)); // Output: 10:51 PM
                                            /*DateTime parsedTime = DateFormat("").parse(
                                                pickedTime.format(context).toString());
                                            print(
                                                parsedTime); // Output: 1970-01-01 22:53:00.000
                                            String formattedTime =
                                            DateFormat('HH:mm').format(parsedTime);
                                            print(formattedTime);*/ // Output: 14:59:00
                                            endTimecon[i].text = pickedTime.format(context);
                                          } else {
                                            print("Time is not selected");
                                          }
                                        },
                                        controller:  endTimecon[i],
                                        keyboardType: TextInputType.number,
                                        maxLength: 10,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          fillColor: MyColorName.colorBg2,
                                          filled: true,
                                          labelText: " End Time",
                                          counterText: '',
                                          labelStyle: TextStyle(color: Colors.black87),
                                          // prefixIcon: IconButton(
                                          //   onPressed: null,
                                          //   icon: Icon(
                                          //     Icons.call,
                                          //     color: MyColorName.primaryDark,
                                          //   ),
                                          // ),
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
                                  ),
                                ],
                              ),
                            ),
                            boxHeight(
                              context,
                              3,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(
                                    context,
                                    8,
                                  )),
                              child: TextFormField(
                                controller: pricelist[i],
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  fillColor: MyColorName.colorBg2,
                                  filled: true,
                                  labelText: "Rent",
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
                                3,
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){

                          stopage.removeAt(i);
                          startTimecon.removeAt(i);
                          endTimecon.removeAt(i);
                          dropDowncity.removeAt(i);
                          pricelist.removeAt(i);
                          print(stopage.length);
                          print(stopageid.length);
                          stopageid.isNotEmpty?stopage.length>=stopageid.length?null:deleteStopage(stopageid[i]):null;
                          setState(() {

                          });
                        },
                        child: CircleAvatar(
                          radius: 15,
                            backgroundColor: MyColorName.mainColor,
                            child: Icon(Icons.horizontal_rule,size: 14,)),
                      ),
                      SizedBox(width: 20,)
                    ],
                  ),
        ]

                ],
              ),
            ),
            commonButton(
              width: 70,
              onPressed: () {
                if (nameCon.text == "") {
                  setSnackbar("Enter Name", context);
                  return;
                }

                if (price.text == "") {
                  setSnackbar("Enter price", context);
                  return;
                }
                if (bikeNumberCon.text == "") {
                  setSnackbar("Enter Vehicle No", context);
                  return;
                }
                if (seatNoid ==null) {
                  setSnackbar(" Select Seat No", context);
                  return;
                }
                if (selectTypeac ==null&&selectMethod!="Auto") {
                  setSnackbar(" Select Type Ac/Non Ac ", context);
                  return;
                }
                // if (cityId ==null) {
                //   setSnackbar(" Select City ", context);
                //   return;
                // }
                if (fromaddid ==null) {
                  setSnackbar(" Select From Address ", context);
                  return;
                }
                if (toaddid ==null) {
                  setSnackbar(" Select To Address ", context);
                  return;
                }
                if (startTime.text ==""&&selectMethod!="Auto") {
                  setSnackbar(" Select Start Time ", context);
                  return;
                }
                if (endTime.text ==""&&selectMethod!="Auto") {
                  setSnackbar(" Select End Time ", context);
                  return;
                }


                // if (stateId == null) {
                //   setSnackbar("Select State", context);
                //   return;
                // }
                // if (cityId == null) {
                //   setSnackbar("Select City", context);
                //   return;
                // }


                // if (dropDowncity.length==0||dropDowncity[0]==null) {
                //   setSnackbar("Stopage select city", context);
                //   return;
                // }
                // if (startTimecon.length==0||startTimecon[0].text=="") {
                //   setSnackbar("Stopage select starTime", context);
                //   return;
                // }
                // if (endTimecon.length==0||endTimecon[0].text=="") {
                //   setSnackbar(" Stopage select starTime", context);
                //   return;
                // }
                // if (pricelist.length==0||pricelist[0].text=="") {
                //   setSnackbar(" Stopage select price", context);
                //   return;
                // }
                setState(() {
                  loading = true;
                });
                widget.isupdate?updateApi("${widget.vehicleData?.id}"):
                registerApi();
              },
              loading: loading,
              title: "Add Vehicle",
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  dynamic cityId;
  dynamic fromaddid;
  dynamic toaddid;
  String ?seatNoid;
  String ?selectTypeac;
  bool isloading=false;

  void registerApi() async {
    await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    "${fromaddid.id}";
    if (isNetwork) {

      try {
        Map<String, String> param = {
        "name":"${nameCon.text}",
          "type":"${selectMethod}".toLowerCase(),
        "bus_type":"${selectTypeac}",
        "seat_type":"Seater 2+2",
        "no_of_seat":"${seatNoid}",
        "address":"${fromaddid.id}",
        "to_address":"${toaddid.id}",
          "date":"${startdate.text}",
        "start_time":startTime.text,
    "end_time":endTime.text,
    "vehicle_no":bikeNumberCon.text,
    "amount":price.text,

    "stop":
    dropDowncity.isEmpty?"":  dropDowncity[0]==null?"": dropDowncity.map((dynamic value) {
        return value.id.toString();
        }).join(', '),
    "stop_fromtime":startTimecon.isEmpty?"":startTimecon[0].text==""?"":startTimecon.map((dynamic value) {
        return value.text.toString();
        }).join(', ')??"",
    "driver_id":"${curUserId}",
    "stop_totime":endTimecon.isEmpty?"":endTimecon[0].text==""?"":endTimecon.map((dynamic value) {
      return value.text.toString();
    }).join(', ')??"",
    "charge":pricelist.isEmpty?"":pricelist[0].text==""?"":pricelist.map((dynamic value) {
      return value.text.toString();
    }).join(', ')??"",
    "type":selectMethod.toLowerCase()
        };

        print(param);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "add_vehicle"),
        );
        Map<String, String> headers = {
          //"token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };
        if(profileImage!=null)
          request.files.add(
            http.MultipartFile(
              'vehicle_image',
              profileImage!.readAsBytes().asStream(),
              profileImage!.lengthSync(),
              filename: path.basename(profileImage!.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
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
    setSnackbar("Vehicle Add Succesfully", context);

          } else {
    setSnackbar("Faild", context);
          }
        }
       on TimeoutException catch (_) {
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
  void updateApi(String id) async {
    await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    "${fromaddid.id}";
    print(dropDowncity.length);
    if (isNetwork) {
      try {
        Map<String, String> param = {
          "service_id":id,
          "name":"${nameCon.text}",
          "type":"${selectMethod}".toLowerCase(),
          "bus_type":"${selectTypeac}",
          "seat_type":"Seater 2+2",
          "date":"${startdate.text}",
          "no_of_seat":"${seatNoid}",
          "address":"${fromaddid.id}",
          "to_address":"${toaddid.id}",
          "start_time":startTime.text,
          "end_time":endTime.text,
          "vehicle_no":bikeNumberCon.text,
          "amount":price.text,

          "stop":
          dropDowncity.isEmpty?"":  dropDowncity[0]==null?"":    dropDowncity.map((dynamic value) {
            return value.id.toString();
          }).join(', '),
          "stop_fromtime":startTimecon.isEmpty?"":startTimecon[0].text==""?"":startTimecon.map((dynamic value) {
            return value.text.toString();
          }).join(', ')??"",
          "driver_id":"${curUserId}",
          "stop_totime":endTimecon.isEmpty?"":endTimecon[0].text==""?"":endTimecon.map((dynamic value) {
            return value.text.toString();
          }).join(', ')??"",
          "charge":pricelist.isEmpty?"":pricelist[0].text==""?"":pricelist.map((dynamic value) {
            return value.text.toString();
          }).join(', ')??"",
          "type":selectMethod.toLowerCase()
        };

        print(param);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "add_vehicle"),
        );
        Map<String, String> headers = {
          //"token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };

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
          setSnackbar("Vehicle Update Succesfully", context);
          Navigator.pop(context);
          Navigator.pop(context);


        } else {
          setSnackbar("Faild", context);
        }
      }
      on TimeoutException catch (_) {
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

  bool loading = false;

  void getStateApi() async {
    try {
      Map param = {};
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_states"), param);
      setState(() {
        loading = false;
      });
      for (var v in response['data']) {
        setState(() {
          stateList.add(StateModel.fromJson(v));
        });
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

  void getSetting() async {
    try {
      var response = await apiBaseHelper
          .postAPICall(Uri.parse("${baseUrl}get_settings"), {});
      print(response.toString() + "((((((((((((((((((((((");
      getSettingModel = GetSettingModel.fromJson(response);

      setState(() {});
    } catch (e) {
    } finally {}
  }


}
