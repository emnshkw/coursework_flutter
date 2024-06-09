import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:coursework/pages/auth_page.dart';
import 'package:coursework/pages/landing_page.dart';


MaterialApp MyApp(){
  return MaterialApp(
    theme: ThemeData(
        fontFamily: 'Ubuntu',
        primaryColor: Color(0xff0e59c9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xff0e59c9),
        ),
        scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: MaterialStateProperty.all(true),
            thickness: MaterialStateProperty.all(7),
            thumbColor: MaterialStateProperty.all(const Color(0xff4e94bf)),
            radius: const Radius.circular(10),
            minThumbLength: 100),
    ),

    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ru', 'RU'),
    ],
    initialRoute: '/landing',
    routes: {
      '/landing':(context) => LandingPage()
    },
  );
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  // runApp(MyApp());

  runApp(MyApp());

}