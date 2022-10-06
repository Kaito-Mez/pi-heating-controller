import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'breathing_widget.dart';

/// Stateful widget that contains the
/// Floorplan graphic, Vent Graphic and
/// slider.
class Floor extends StatefulWidget {
  /// Front Heat image path
  final String frontHeat;

  /// Front Wireframe image path
  final String frontWireframe;

  /// Front Background image path
  final String frontBackground;

  /// Back Heat image path
  final String backHeat;

  /// Back Wireframe image path
  final String backWireframe;

  /// Back Background image path
  final String backBackground;

  const Floor(
      {required this.frontHeat,
      required this.frontWireframe,
      required this.frontBackground,
      required this.backHeat,
      required this.backWireframe,
      required this.backBackground,
      super.key});

  @override
  State<Floor> createState() => _FloorState();
}

/// State for the Floor object
class _FloorState extends State<Floor> {
  bool settingAngle = false;
  bool showDebug = false;

  /// Front Heat image path
  late String frontHeat;

  /// Front Wireframe image path
  late String frontWireframe;

  /// Front Background image path
  late String frontBackground;

  /// Back Heat image path
  late String backHeat;

  /// Back Wireframe image path
  late String backWireframe;

  /// Back Background image path
  late String backBackground;

  /// The slider's position (0 to 1)
  double _sliderVal = 0.5;

  /// The opacity of the first floorplans
  /// heat image
  double opacity = 0.5;

  /// The opacity of the second floorplans
  /// heat image
  double opacity2 = 0.5;

  /// The current angle of rotation of the
  /// vent image (radians)
  double ventRotation = 0;

  /// Last reported angle of the servo (degrees)
  double currAngle = 0;

  /// The target angle of the servo (degrees)
  double targetAngle = 0;

  /// Direction of motion of the servo
  int direction = 0;

  /// Maps the direction to a string
  dynamic directionToString = {
    0: "Vent Is Stationary",
    1: "Vent Is Closing",
    -1: "Vent Is Opening"
  };

  /// String displayed at the bottom of the
  /// screen that says what the servo is currently
  /// doing.
  String statusString = "";

  /// Socket object
  late IO.Socket socket;

  /// The arrow that blinks when the vent is closing
  BreathingWidget closingArrow =
      BreathingWidget("assets/images/closingArrow.png");

  /// The arrow that blinks when the vent is opening
  BreathingWidget openingArrow =
      BreathingWidget("assets/images/openingArrow.png");

  /// Initialises images
  _FloorState() {
    frontHeat = widget.frontHeat;
    frontWireframe = widget.frontWireframe;
    frontBackground = widget.frontBackground;

    backHeat = widget.backHeat;
    backWireframe = widget.backWireframe;
    backBackground = widget.backBackground;
  }

  /// When the Slider begins being moved
  /// the UI displays the target angle that
  /// the user is inputting instead of the
  /// actual current angle.
  void onChangeStart(double initialVal) {
    setState(() {
      settingAngle = true;
      openingArrow.state.stopBreathing(500);
      closingArrow.state.stopBreathing(500);
      statusString = "Setting New Route";
    });
  }

  /// When the Slider is let go the UI
  /// returns to showing what the current
  /// state of the motor is.
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

  /// Sets the target angle of the servo
  /// when the slider is moved
  void onChanged(double value) {
    setState(() {
      _sliderVal = value;
      opacity = 1 - value;
      opacity2 = value;
      ventRotation = (1.5708 * value);
      targetAngle = 90 - (value * 90);
    });
  }

  /// Sets up init vals
  void onInit(dynamic jsonData) {
    onUpdate(jsonData);
    _sliderVal = 1 - ((0.0 + jsonData['target']) / 90);
    targetAngle = jsonData['target'] + 0.0;
  }

  /// Called whenever the socket receives
  /// an update from the server. Updates UI
  /// elements and variables depending on the
  /// new info.
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

  /// Toggles whether the debug widget
  /// should be shown
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
        // Floorplan Graphic
        Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left Floorplan images
                Flexible(
                  child: Stack(children: leftItems),
                ),
                // Right Floorplan images
                Flexible(
                  child: Stack(children: rightItems),
                )
              ],
            )),

        // Vent Graphic
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
        // Slider
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
      // Lower Status Bar
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
        // Debug Widget
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
