import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  bool settingAngle = false;
  bool showDebug = false;

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

  double currAngle = 0;
  double targetAngle = 0;
  int direction = 0;
  dynamic directionToString = {
    0: "Vent Is Stationary",
    1: "Vent Is Closing",
    -1: "Vent Is Opening"
  };

  String statusString = "";
  late IO.Socket socket;

  BreathingWidget closingArrow =
      BreathingWidget("assets/images/closingArrow.png");
  BreathingWidget openingArrow =
      BreathingWidget("assets/images/openingArrow.png");

  void onChangeStart(double initialVal) {
    setState(() {
      settingAngle = true;
      openingArrow.state.stopBreathing(500);
      closingArrow.state.stopBreathing(500);
      statusString = "Setting New Route";
    });
  }

  void onChangeEnd(double finalVal) {
    setState(() {
      settingAngle = false;
    });
    if (socket.connected) {
      socket.emit('change_target', {"target": targetAngle});
    } else {
      socket.connect();
    }
  }

  void onChanged(double value) {
    setState(() {
      _sliderVal = value;
      opacity = 1 - value;
      opacity2 = value;
      ventRotation = 1.5708 - (1.5708 * value);
      targetAngle = value * 90;
    });
  }

  void onInit(dynamic jsonData) {
    onUpdate(jsonData);
    _sliderVal = (0.0 + jsonData['target']) / 90;
    targetAngle = jsonData['target'] + 0.0;
  }

  void onUpdate(dynamic jsonData) {
    setState(() {
      if (!settingAngle) {
        currAngle = jsonData['current'];
        direction = jsonData['direction'];
        statusString = directionToString[direction];
        double val = currAngle / 90;
        opacity = val;
        opacity2 = 1 - val;
        ventRotation = 1.5708 - (1.5708 * val);
        if (direction == 1) {
          openingArrow.state.stopBreathing(500);
          closingArrow.state.startBreathing(2000);
        } else if (direction == -1) {
          closingArrow.state.stopBreathing(500);
          openingArrow.state.startBreathing(2000);
        } else if (direction == 0) {
          closingArrow.state.stopBreathing(2000);
          openingArrow.state.stopBreathing(2000);
        }
      }
    });
  }

  void toggleDebug() {
    print("PResed");
    setState(() {
      if (showDebug) {
        showDebug = false;
      } else {
        showDebug = true;
      }
    });
  }

  _MyWidgetState(this.frontHeat, this.frontWireframe, this.frontBackground,
      this.backHeat, this.backWireframe, this.backBackground);

  @override
  void initState() {
    socket = IO.io('ws://192.168.1.150:5000', <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('update', ((data) => onUpdate(data)));
    socket.on('init', ((data) => onInit(data)));
    socket.onConnect((data) => print("FLOORSTATE CONNECTED"));
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
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

    return Scaffold(
      body: Column(children: [
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
                  )),
              openingArrow,
              closingArrow
            ],
          ),
        ),
        Flexible(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Slider(
            value: _sliderVal,
            thumbColor: const Color(0xFFfa7d15),
            inactiveColor: const Color(0xFF57B8FF),
            onChanged: onChanged,
            onChangeStart: (value) => onChangeStart(value),
            onChangeEnd: (value) => onChangeEnd(value),
          ),
        ))
      ]),
      bottomSheet: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            alignment: Alignment.center,
            height: 60,
            color: const Color.fromARGB(255, 88, 184, 255),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 15),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Text(
                statusString,
                style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(""),
              ),
              IconButton(
                iconSize: 10,
                icon: Image.asset(
                  "assets/images/debug.png",
                ),
                onPressed: () => toggleDebug(),
              )
            ])),
        showDebug
            ? Text(
                "DEBUG: Target: $targetAngle, Current $currAngle, Direction: $direction",
                style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    backgroundColor: Color(0xFFfa7d15)),
              )
            : Container(
                color: const Color.fromARGB(255, 88, 184, 255),
              )
      ]),
    );
  }
}

class BreathingWidget extends StatefulWidget {
  final String image;
  late _BreathingWidgetState state;

  BreathingWidget(this.image, {super.key}) {
    state = _BreathingWidgetState(image);
  }
  @override
  State<BreathingWidget> createState() => state;
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  late CurvedAnimation _breatheAnimation;
  final String image;
  bool _breathing = false;
  int _milliseconds = 2000;
  _BreathingWidgetState(this.image);

  void startBreathing(int ms) {
    bool pre = _breathing;
    setState(() {
      _breathing = true;
      _milliseconds = ms;
      _fadeController.duration = Duration(milliseconds: _milliseconds);
    });
    if (pre == false) {
      _breathIn();
    }
  }

  void stopBreathing(int ms) {
    setState(() {
      _milliseconds = ms;
      _breathing = false;
      _fadeController.duration = Duration(milliseconds: _milliseconds);
    });
    _breathOut();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _milliseconds));
    _breatheAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _breathIn() {
    TickerFuture future = _fadeController.forward(from: 0.0);
    future.whenCompleteOrCancel(() => {_breathOut()});
    Stream<void> stream = future.asStream();
  }

  void _breathOut() {
    TickerFuture future2 = _fadeController.reverse(from: _fadeController.value);
    future2.whenComplete(() => {
          if (_breathing) {_breathIn()}
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _breatheAnimation,
        builder: ((context, child) {
          return Opacity(
            opacity: _breatheAnimation.value,
            child: Image.asset(image),
          );
        }));
  }
}
