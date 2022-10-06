import 'package:flutter/material.dart';
import 'widget/stacked_widget.dart';

/*
*
* Set up the stacked widget file such that it doesnt require any args
*
* Make it such that the floorplan pictures could easily be swapped out
*
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Material Colour pallete
  static const Map<int, Color> accentPallete = {
    50: Color.fromRGBO(88, 184, 255, .1),
    100: Color.fromRGBO(88, 184, 255, .2),
    200: Color.fromRGBO(88, 184, 255, .3),
    300: Color.fromRGBO(88, 184, 255, .4),
    400: Color.fromRGBO(88, 184, 255, .5),
    500: Color.fromRGBO(88, 184, 255, .6),
    600: Color.fromRGBO(88, 184, 255, .7),
    700: Color.fromRGBO(88, 184, 255, .8),
    800: Color.fromRGBO(88, 184, 255, .9),
    900: Color.fromRGBO(88, 184, 255, 1),
  };
  //Accent colour for UI
  static const MaterialColor accentColor =
      MaterialColor(0xFF57B8FF, accentPallete);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heat Router',
      theme: ThemeData(
          primarySwatch: accentColor,
          scaffoldBackgroundColor: const Color(0xFF30343F)),
      home: const MyHomePage(title: 'Route Heating'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            widget.title,
          ),
        ),
        body: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: FloorState(
                frontHeat: "assets/images/frontHeat.png",
                frontWireframe: "assets/images/frontWireframe.png",
                frontBackground: "assets/images/frontBackground.png",
                backHeat: "assets/images/backHeat.png",
                backWireframe: "assets/images/backWireframe.png",
                backBackground: "assets/images/backBackground.png")));
  }
}
