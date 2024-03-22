import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smr_driver/Auth/Login/UI/login_page.dart';

import 'package:smr_driver/new_screens/verification_screen.dart';

import 'package:smr_driver/Model/state_model.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../Model/get_setting_model.dart';
import '../Model/taluka_model.dart';
import '../Model/village_model.dart';
import '../utils/Session.dart';
import '../utils/location_details1.dart';


class RegisterScreen extends StatefulWidget {
  final String phoneNumber;

  RegisterScreen({this.phoneNumber = ""});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> method = ["Auto","Bus", "Car"];
  String selectMethod = "Auto";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController bikeNumberCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  bool obscure = true;
  double adrLat = 0,adrLng = 0;
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
  GetSettingModel getSettingModel=GetSettingModel();
  VilliageModel villiageModel=VilliageModel();
  TalukaModel talukaModel=TalukaModel();

  void getTalukaApi() async {
    try {
      Map param = {
        'city_id': cityId,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_taluka"), param);
      talukaModel=TalukaModel.fromJson(response);
      setState(() {
        loading = false;
      });

      // if(widget.model!.city!=null){
      //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
      //   if(index!=-1){
      //     cityId = cityList[index].id;
      //
      //   }
      // }
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
  void getVillageApi() async {
    try {
      Map param = {
        'taluka_id': talukaId.id,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_village"), param);
      setState(() {
        loading = false;
      });
      villiageModel=VilliageModel.fromJson(response);
      // if(widget.model!.city!=null){
      //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
      //   if(index!=-1){
      //     cityId = cityList[index].id;
      //
      //   }
      // }
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileCon.text = widget.phoneNumber;
    GetLocation location = new GetLocation((result) {
      if (mounted) {
        setState(() {
          address = result.first.streetAddress;
          latitude = latitudeFirst;
          longitude = longitudeFirst;
          addressCon.text = address;
        });
      }
    });
    location.getLoc();
    // GetLocation getLocation=GetLocation();
    //
    //   getLocation.requestLocationPermission();
    getStateApi();
    getSetting();
  }

  void _showBottomSheet(BuildContext context,int pos) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Select from Gallery'),
                onTap: () {

                  getImage(context, pos);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () {

                  getImagefromcamera(context,pos);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                        "Sign Up",
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
                Column(
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: getWidth(context,3, ),
                      runSpacing: getHeight(context,2),
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
                    boxHeight(context,2,),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
                      child: TextFormField(
                        controller: nameCon,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Name",
                          counterText: '',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.person,
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
                    boxHeight(context,2,),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        controller: emailCon,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Email Address",
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
                    boxHeight(context,2),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
                      child: TextFormField(
                        controller: mobileCon,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Mobile Number",
                          counterText: '',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.call,
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
                    boxHeight(context,2),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
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
                    boxHeight(context,2, ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColorName.colorBg2,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(context,4, )),
                        child: DropdownButton<String>(
                          hint: Text("Select State",style: TextStyle(color: Colors.black87),),
                          value: stateId,
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: MyColorName.primaryDark,
                          ),
                          items: stateList.map((StateModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.name!),
                            );
                          }).toList(),
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? value) {
                            setState(() {
                              stateId = value;
                              cityId = null;
                              cityList.clear();
                            });
                            getCityApi();
                          },
                        ),
                      ),
                    ),

                    cityList.isNotEmpty?Column(
                      children: [
                        boxHeight(context,2),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(context,4, )),
                            child: DropdownButton<String>(
                              hint: Text("Select City",style: TextStyle(color: Colors.black87),),
                              value: cityId,
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: MyColorName.primaryDark,
                              ),
                              items: cityList.map((CityModel value) {
                                return DropdownMenuItem<String>(
                                  value: value.id,
                                  child: Text(value.name!),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (String? value) {
                                setState(() {
                                  cityId = value;
                                });
                                getTalukaApi();
                              },
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox.shrink(),

                    talukaModel.data?.isNotEmpty??false?Column(
                      children: [
                        boxHeight(context,2),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: getWidth( context,8)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(context,4)),
                            child: DropdownButton<dynamic>(
                              hint: Text("Select Taluka",style: TextStyle(color: Colors.black87),),
                              value: talukaId,
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: MyColorName.secondColor,
                              ),
                              items: talukaModel.data?.map(( value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value.name!),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (value) {
                                setState(() {
                                  talukaId = value;
                                  print(value.id);
                                  getVillageApi();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox.shrink(),

                    villiageModel.data?.isNotEmpty??false?Column(
                      children: [
                        boxHeight(context,2),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: getWidth( context,8)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColorName.colorBg2,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth( context,4)),
                            child: DropdownButton<dynamic>(
                              hint: Text("Select Village",style: TextStyle(color: Colors.black87),),
                              value: villageId,
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: MyColorName.secondColor,
                              ),
                              items: villiageModel.data?.map(( value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value.name!),
                                );
                              }).toList(),
                              isExpanded: true,
                              underline: SizedBox(),
                              onChanged: (value) {
                                setState(() {
                                  villageId = value;
                                  print(value.id);
                                });

                              },
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox.shrink(),
                    boxHeight(context,2, ),

                    Column(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                          child: TextFormField(
                            controller: addressCon,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: MyColorName.colorBg2,
                              filled: true,
                              labelText: "Address",
                              counterText: '',
                              labelStyle: TextStyle(color: Colors.black87),
                              prefixIcon: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.location_on_outlined,
                                  color: MyColorName.primaryDark,
                                ),
                              ),
                              suffixIcon:getSettingModel.data?[0].googleKey.toString()=="1"?
                              IconButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlacePicker(
                                        apiKey: Platform.isAndroid
                                            ? "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0"
                                            : "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0",
                                        onPlacePicked: (result) {
                                          setState(() {
                                            addressCon.text =
                                                result.formattedAddress.toString();
                                            latitude = result.geometry!.location.lat;
                                            longitude = result.geometry!.location.lng;
                                          });

                                          Navigator.of(context).pop();
                                        },
                                        initialPosition: LatLng(latitude, longitude),
                                        useCurrentLocation: true,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.location_searching,
                                  color: MyColorName.primaryDark,
                                ),
                              ):SizedBox.shrink(),
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
                    boxHeight(context,2),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        //controller: addressCon,
                        readOnly: true,
                        onTap: (){
                          _showBottomSheet(context, 1);
                         // getImage(context, 1);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Profile Image",
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
                    profileImage!=null?Image.file(profileImage!,width: 300,height: 100,):const SizedBox(),


                    boxHeight(context,2,),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8, )),
                      child: TextFormField(
                        controller: bikeNumberCon,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "Vehicle Number",
                          counterText: '',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.document_scanner,
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



                    boxHeight(context,2),





                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        //controller: addressCon,
                        readOnly: true,
                        onTap: (){
                          _showBottomSheet(context, 2);
                        //  getImage(context, 2);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "License Image",
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
                    licenseImage!=null?Image.file(licenseImage!,width: 300,height: 100,):const SizedBox(),
                    boxHeight(context,2),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        //controller: addressCon,
                        readOnly: true,
                        onTap: (){
                          _showBottomSheet(context, 3);
                        //  getImage(context, 3);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: MyColorName.colorBg2,
                          filled: true,
                          labelText: "RC Image",
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
                    rcImage!=null?Image.file(rcImage!,width: 300,height: 100,):const SizedBox(),

                  ],
                ),
                boxHeight(context,5, ),
                commonButton(
                  width: 70,
                  onPressed: () {
                    if (nameCon.text == "") {
                      setSnackbar("Enter Name", context);
                      return;
                    }
                    if (emailCon.text == "" ||
                        !emailCon.text.contains("@") ||
                        !emailCon.text.contains(".")) {
                      setSnackbar("Please Enter Email Address", context);
                      return;
                    }
                    if (mobileCon.text == "" || mobileCon.text.length != 10) {
                      setSnackbar("Enter Valid Mobile Number", context);
                      return;
                    }
                    if (passCon.text == "" || passCon.text.length < 6) {
                      setSnackbar("Enter Password Minimum Character 6", context);
                      return;
                    }
                    if (stateId==null) {
                      setSnackbar("Select State", context);
                      return;
                    }
                    if (cityId == null) {
                      setSnackbar("Select City", context);
                      return;
                    }
                    // if (talukaId == null) {
                    //   setSnackbar("Select Taluka", context);
                    //   return;
                    // }
                    // if (villageId == null) {
                    //   setSnackbar("Select Village", context);
                    //   return;
                    // }
                    if (profileImage == null) {
                      setSnackbar("Select Profile", context);
                      return;
                    }
                    if (bikeNumberCon.text == "") {
                      setSnackbar("Select RC Card", context);
                      return;
                    }
                    if (licenseImage == null) {
                      setSnackbar("Select License", context);
                      return;
                    }
                    if (rcImage == null) {
                      setSnackbar("Select RC Card", context);
                      return;
                    }

                    setState(() {
                      loading = true;
                    });
                    registerApi();
                  },
                  loading: loading,
                  title: "Sign Up",
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  File? licenseImage,rcImage,profileImage;
  Future getImage(BuildContext context, int pos) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File tempFile = File(result.files.first.path!);
      if(pos==1){
        setState(() {
          profileImage =tempFile;
        });
      }else if(pos==2){
        setState(() {
          licenseImage =tempFile;
        });
      }else{
        setState(() {
          rcImage =tempFile;
        });
      }
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
  Future getImagefromcamera(BuildContext context, int pos) async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.image,
    // );
    final ImagePicker picker = ImagePicker();
    var result = await picker.getImage(source: ImageSource.camera);



    if (result != null) {
      File tempFile = File(result.path!);
      if(pos==1){
        setState(() {
          profileImage =tempFile;
        });
      }else if(pos==2){
        setState(() {
          licenseImage =tempFile;
        });
      }else{
        setState(() {
          rcImage =tempFile;
        });
      }
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
  String? stateId, cityId;
  dynamic talukaId,villageId;
  void registerApi() async {
    await App.init();

    ///MultiPart request
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map<String, String> param = {
          "name": nameCon.text,
          "mobile": mobileCon.text,
          "email": emailCon.text,
          "fcm_id":"${fcmToken}",
          "password": passCon.text,
          "confirm_password": passCon.text,
          "address": addressCon.text,
          "type": selectMethod,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "state": stateList[stateList.indexWhere((element) => element.id == stateId)].name.toString(),
          "city": cityList[cityList.indexWhere((element) => element.id == cityId)].name.toString(),
          "vehicle_number":bikeNumberCon.text,
          "taluka":talukaId!=null?"${talukaId.name??""}":"",
          "village":villageId!=null?"${villageId.name??""}":""
        };
        print(param.toString());
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(baseUrl + "user_register"),
          );
          Map<String, String> headers = {
            "token": App.localStorage.getString("token").toString(),
            "Content-type": "multipart/form-data"
          };
          if(licenseImage!=null)
            request.files.add(
              http.MultipartFile(
                'licence',
                licenseImage!.readAsBytes().asStream(),
                licenseImage!.lengthSync(),
                filename: path.basename(licenseImage!.path),
                contentType: MediaType('image', 'jpeg'),
              ),
            );
        if(rcImage!=null)
          request.files.add(
            http.MultipartFile(
              'rc_card',
              rcImage!.readAsBytes().asStream(),
              rcImage!.lengthSync(),
              filename: path.basename(rcImage!.path),
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        if(profileImage!=null)
          request.files.add(
            http.MultipartFile(
              'pro_pic',
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
            Map data = jsonDecode(respStr.toString());
            if (!data['error']) {
              Map info = data['data'];
              setSnackbar(data['message'].toString(), context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()),
                      (route) => false);
             /* navigateScreen(
                  context, VerificationScreen(info['mobile'], info['otp'].toString()));*/

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
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
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

      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_settings"), {});
      print(response.toString()+"((((((((((((((((((((((");
      getSettingModel=GetSettingModel.fromJson(response);

      setState(() {

      });

    } catch (e) {

    } finally {

    }
  }
  void getCityApi() async {
    try {
      Map param = {
        'state_id': stateId,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_cities"), param);
      setState(() {
        loading = false;
      });
      for (var v in response['data']) {
        setState(() {
          cityList.add(CityModel.fromJson(v));
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
}
