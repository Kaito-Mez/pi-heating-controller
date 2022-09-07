import 'package:flutter/material.dart';
import 'widget/stacked_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  // Dart client
  IO.Socket socket = IO.io('http://192.168.1.203:5000', <String, dynamic>{
    'transports': ['websocket']
  });
  print("here");
  socket.onConnect((data) => print("CONNECTED"));
  socket.connect();
  socket.emit("message", ["TEST"]);
  print("done");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  static const MaterialColor accentColor =
      MaterialColor(0xFF57B8FF, accentPallete);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heater Controller',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: accentColor,
          scaffoldBackgroundColor: const Color(0xFF30343F)),
      home: const MyHomePage(title: 'Heater Router'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
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
