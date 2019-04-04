import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phonedailer/Ui/Ui1.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1600));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animation.addListener(() => this.setState(() {}));
    _animationController.forward();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            
            context,
            MaterialPageRoute(builder: (context) => Ui1Page())));
  }

  @override
  Widget build(BuildContext context) {
    final sized = Tween<double>(begin: 0.0, end: 2.0);
    return MaterialApp(
        home: Scaffold(
            body: new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Opacity(
                  opacity: _animation.value,
                  child: Transform.scale(
                    scale: sized.evaluate(_animation),
                    child: Image.asset('icon.png'),
                  )),
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    )));
  }
}
