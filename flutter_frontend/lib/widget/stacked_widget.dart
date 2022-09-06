import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class FloorState extends StatefulWidget {
  final String frontHeat;
  final String frontWireframe;
  final String frontBackground;

  final String backHeat;
  final String backWireframe;
  final String backBackground;

  const FloorState(
      {required this.frontHeat,
      required this.frontWireframe,
      required this.frontBackground,
      required this.backHeat,
      required this.backWireframe,
      required this.backBackground,
      super.key});

  @override
  State<FloorState> createState() => _MyWidgetState(frontHeat, frontWireframe,
      frontBackground, backHeat, backWireframe, backBackground);
}

class _MyWidgetState extends State<FloorState> {
  String frontHeat;
  String frontWireframe;
  String frontBackground;

  String backHeat;
  String backWireframe;
  String backBackground;

  double _sliderVal = 0.5;
  double opacity = 0.5;
  double opacity2 = 0.5;
  double ventRotation = 0;

  Socket socket;

  void onChanged(double value) {
    setState(() {
      _sliderVal = value;
      opacity = 1 - value;
      opacity2 = value;
      ventRotation = 1.5708 - (1.5708 * value);
    });
  }

  initSocket() {
    socket = io("localhost:5000", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  _MyWidgetState(this.frontHeat, this.frontWireframe, this.frontBackground,
      this.backHeat, this.backWireframe, this.backBackground);

  @override
  void init_state() {
    initSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var leftItems = [
      Image.asset(
        backBackground,
        fit: BoxFit.fitHeight,
      ),
      Image.asset(
        backWireframe,
        fit: BoxFit.fitHeight,
      ),
      Opacity(
          opacity: opacity,
          child: Image.asset(
            backHeat,
            fit: BoxFit.fitHeight,
          )),
    ];

    final rightItems = [
      Image.asset(
        frontBackground,
        fit: BoxFit.fitHeight,
      ),
      Image.asset(
        frontWireframe,
        fit: BoxFit.fitHeight,
      ),
      Opacity(
          opacity: opacity2,
          child: Image.asset(
            frontHeat,
            fit: BoxFit.fitHeight,
          )),
    ].map((item) {
      final value = SizedBox(child: item);
      return value;
    }).toList();

    return Column(children: [
      Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Stack(children: leftItems),
              ),
              Flexible(
                child: Stack(children: rightItems),
              )
            ],
          )),
      Flexible(
        flex: 1,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/vent.png",
              scale: 0.1,
            ),
            Transform.rotate(
                angle: ventRotation,
                child: Image.asset(
                  "assets/images/ventThrottle.png",
                  scale: 0.1,
                ))
          ],
        ),
      ),
      Slider(value: _sliderVal, onChanged: onChanged),
    ]);
  }
}
