import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http_parser/http_parser.dart';



import 'package:smr_driver/Model/state_model.dart';
import 'package:smr_driver/Model/user_model.dart';
import 'package:smr_driver/utils/ApiBaseHelper.dart';
import 'package:smr_driver/utils/colors.dart';
import 'package:smr_driver/utils/common.dart';
import 'package:smr_driver/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../utils/Session.dart';
import '../utils/location_details1.dart';


class EditProfileScreen extends StatefulWidget {

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> method = ["Auto","Bus", "Car"];
  String selectMethod = "Auto";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  bool obscure = true;
  double adrLat = 0,adrLng = 0;
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
    getStateApi();
  }
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
        nameCon.text = userModel!.name ?? "";
        mobileCon.text = userModel!.mobile ?? "";
        emailCon.text = userModel!.email ?? "";
        selectMethod = userModel!.type ?? "";
        addressCon.text = userModel!.address ?? "";
        adrLng = double.parse(userModel!.longitude ?? "0");
        adrLat = double.parse(userModel!.latitude ?? "0");
        //passCon.text = userModel!.p ?? "";
      }
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
          "Edit Profile",
        ),
      ),

      body: SafeArea(
        child: !loading?SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                boxHeight(context,1, ),
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
                        readOnly: true,
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
                    boxHeight(context,2, ),
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
                          suffixIcon:IconButton(
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
                                        adrLat = result.geometry!.location.lat;
                                        adrLng = result.geometry!.location.lng;
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
                          getImage(context, 1);
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
                    profileImage!=null?Image.file(profileImage!,width: 300,height: 100,):userModel!.proPic!=null?Image.network(userModel!.proPic!,width: 300,height: 100,):const SizedBox(),
                    boxHeight(context,2),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        //controller: addressCon,
                        readOnly: true,
                        onTap: (){
                          getImage(context, 2);
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
                    licenseImage!=null?Image.file(licenseImage!,width: 300,height: 100,):userModel!.licence!=null?Image.network(userModel!.licence!,width: 300,height: 100,):const SizedBox(),
                    boxHeight(context,2),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getWidth(context,8,)),
                      child: TextFormField(
                        //controller: addressCon,
                        readOnly: true,
                        onTap: (){
                          getImage(context, 3);
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
                    rcImage!=null?Image.file(rcImage!,width: 300,height: 100,):userModel!.rcCard!=null?Image.network(userModel!.rcCard!,width: 300,height: 100,):const SizedBox(),
                    boxHeight(context,2),
                    cityList.isNotEmpty?Padding(
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
                          },
                        ),
                      ),
                    ):SizedBox(),

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
                      setSnackbar("Enter Valid Email", context);
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
                    setState(() {
                      loading = true;
                    });
                    registerApi();
                  },
                  loading: loading,
                  title: "Update",
                  context: context,
                ),
              ],
            ),
          ),
        ):const Center(child: CircularProgressIndicator(),),
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
  String? stateId, cityId;
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
          "password": passCon.text,
          "confirm_password": passCon.text,
          "address": addressCon.text,
          "type": selectMethod,
          "driver_id": curUserId!,
          "latitude": adrLat.toString(),
          "longitude": adrLng.toString(),
          "state": stateList[stateList.indexWhere((element) => element.id == stateId)].name.toString(),
          "city": cityList[cityList.indexWhere((element) => element.id == cityId)].name.toString(),
        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "update_driver"),
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
          if (data['status']) {
            Navigator.pop(context,true);
            setSnackbar(data['message'].toString(), context);

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

      for (var v in response['data']) {
        setState(() {
          stateList.add(StateModel.fromJson(v));
        });
      }
      int index = stateList.indexWhere((element) => element.name == userModel!.state);
      if(index!=-1){
        stateId = stateList[index].id;
        getCityApi();
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

  void getCityApi() async {
    try {
      Map param = {
        'state_id': stateId,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_cities"), param);

      for (var v in response['data']) {
        setState(() {
          cityList.add(CityModel.fromJson(v));
        });
      }
      int index = cityList.indexWhere((element) => element.name == userModel!.city);
      if(index!=-1){
        cityId = cityList[index].id;
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
