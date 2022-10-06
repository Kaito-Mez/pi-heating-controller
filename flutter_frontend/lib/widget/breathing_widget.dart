import 'package:flutter/material.dart';

/// A widget that applies a breathing animation
/// to an image. Used for direction indicator arrows.
class BreathingWidget extends StatefulWidget {
  /// Image Path
  final String image;

  /// Reference to the widgets state
  late _BreathingWidgetState state;
  BreathingWidget(this.image, {super.key}) {
    state = _BreathingWidgetState();
  }
  @override
  State<BreathingWidget> createState() => state;
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  late CurvedAnimation _breatheAnimation;
  late String image;
  bool _breathing = false;
  int _milliseconds = 2000;
  _BreathingWidgetState() {
    image = widget.image;
  }

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
