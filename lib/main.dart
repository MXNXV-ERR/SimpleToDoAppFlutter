import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:google_fonts/google_fonts.dart';
import 'package:todos/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          //textTheme: FontFac.comicNeueTextTheme(
          // Theme.of(context).textTheme,
          //),
          ),
      home: Homepage(
        isdarkMode: true,
      ),
    );
  }
}
