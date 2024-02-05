import 'dart:io';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

import 'package:smr_driver/Provider/UserProvider.dart';
import 'package:smr_driver/Theme/style.dart';
import 'package:smr_driver/new_screens/splash_screen.dart';
import 'package:smr_driver/utils/Demo_Localization.dart';
import 'package:smr_driver/utils/PushNotificationService.dart';
import 'package:smr_driver/utils/Session.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'DrawerPages/Settings/language_cubit.dart';
import 'DrawerPages/Settings/theme_cubit.dart';

import 'Routes/page_routes.dart';

Future<void> handleNotificationPermission() async {
  const permission = Permission.notification;
  final status = await permission.status;
  if (status.isGranted) {
    print('User granted this permission before');
  } else {
    final before = await permission.shouldShowRequestRationale;
    final rs = await permission.request();
    final after = await permission.shouldShowRequestRationale;

    if (rs.isGranted) {
      print('User granted notication permission');
    } else if (!before && after) {
      print('Show permission request pop-up and user denied first time');
    } else if (before && !after) {
      print('Show permission request pop-up and user denied a second time');
    } else if (!before && !after) {
      print('No more permission pop-ups displayed');
    }
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
 await handleNotificationPermission();
 // MapUtils.getMarkerPic();
 // MobileAds.instance.initialize();
  String? locale = prefs.getString('locale');
  bool? isDark = prefs.getBool('theme');
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: AppTheme.primaryColor, // status bar color
  ));



  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LanguageCubit(locale)),
    BlocProvider(create: (context) => ThemeCubit(isDark ?? false)),
  ], child: ShareMyRideDriver()));
}

class ShareMyRideDriver extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _ShareMyRideDriverState state =
        context.findAncestorStateOfType<_ShareMyRideDriverState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<ShareMyRideDriver> createState() => _ShareMyRideDriverState();
}

class _ShareMyRideDriverState extends State<ShareMyRideDriver> {
 
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider())
        ],
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, theme) {
                return MaterialApp(
                  locale: _locale,
                  supportedLocales: [
                    Locale("en", "US"),
                    Locale("ne", "NPL"),
                  ],
                  localizationsDelegates: [
                    DemoLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale!.languageCode &&
                          supportedLocale.countryCode == locale.countryCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  theme: theme,
                  home: SplashScreen(),
                  routes: PageRoutes().routes(),
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        ),
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
