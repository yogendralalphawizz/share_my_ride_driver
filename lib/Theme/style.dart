import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smr_driver/utils/colors.dart';

class AppTheme {
  static String fontFamily = '';
  static Color primaryColor = Color(0xffF57B0E);
  static Color hintColor = Colors.black;
  static Color ratingsColor = Color(0xff51971B);
  static Color starColor = Color(0xffB6E025);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: primaryColor,
    hintColor: hintColor,
    backgroundColor: Color(0xff000000),
    primaryColorLight: Colors.white,
    dividerColor: hintColor,
    cardColor: Color(0xff202020),

    ///appBar theme
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
    ),

    ///text theme
    textTheme: TextTheme(
      headline4: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      button: TextStyle(fontSize: 18),
      bodyText2: TextStyle(fontWeight: FontWeight.bold),
      caption: TextStyle(color: Colors.black),
    ).apply(),
  );

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: MyColorName.colorBg1,
    //backgroundColor: Color(0xfff9f9f9),
    // primaryColor: Color(0xff2176c6),
    // primaryColorLight: Color(0xff0dbaff),
    primaryColor: Color(0xffd22027),
    primaryColorLight: Color(0xffF57B0E),
    dividerColor: Colors.grey[100],
    hintColor: hintColor,
    scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        thickness: MaterialStateProperty.all(2),
        thumbColor: MaterialStateProperty.all<Color>(Colors.black54)),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.openSans(
        fontSize: 12.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: GoogleFonts.openSans(
        fontSize: 14.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      fillColor: Colors.white,
      isDense: true,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:  MyColorName.colorTextSecondary,),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:MyColorName.primaryLite,),
      ),
    ),
    appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white)),

    //text theme
    textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          //default text style of Text Widget
          /*   bodyText1: TextStyle(color: scaffoldBackgroundColor),
      bodyText2: TextStyle(),
      subtitle1: TextStyle(),
      subtitle2: TextStyle(fontWeight: FontWeight.w500),
      headline3: TextStyle(),
      headline5: TextStyle(),
      headline6: TextStyle(letterSpacing: 2, fontSize: 16),
      caption: TextStyle(),
      overline: TextStyle(),
      button: TextStyle(color: scaffoldBackgroundColor, fontSize: 18)*/)),
  );
}

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
