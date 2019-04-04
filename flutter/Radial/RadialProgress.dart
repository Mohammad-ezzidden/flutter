import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class RadialProgress extends StatefulWidget {
  final int progress;
  final double width;
  final double height;
  final Color color;
  RadialProgress({Key key, this.progress, this.width, this.height, this.color})
      : super(key: key);

  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  int newProgress;
  void initState() {
    super.initState();
    newProgress = 0;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200))
          ..addListener(() {
            setState(() {
              newProgress = (controller.value * widget.progress).toInt();
            });
          });
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          foregroundPainter: RadialProgressPainter(
              lineColor: Colors.grey,
              completeColor: widget.color,
              completePercent: newProgress,
              width: widget.height / 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: widget.width / 4,
                height: widget.height / 4,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5)),
                child: Icon(
                  Icons.mood,
                  color: widget.color,
                  size: widget.height / 8,
                ),
              ),
              Text(newProgress.toString() + "K",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.height / 5)),
              Container(
                width: widget.width / 4,
                height: widget.height / 150,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadialProgressPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  int completePercent;
  double width;
  RadialProgressPainter(
      {this.completeColor, this.completePercent, this.lineColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint baseCircle = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint completeCircle = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        pi - 0.5, pi + 1, false, baseCircle);
    //canvas.drawCircle(center, radius, baseCircle);
    double arcAngle = (pi + 1) * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        pi - 0.5, arcAngle, false, completeCircle);
  }

  @override
  bool shouldRepaint(RadialProgressPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(RadialProgressPainter oldDelegate) => false;
}
