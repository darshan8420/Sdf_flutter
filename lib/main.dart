import 'package:flutter/material.dart';
import 'package:sdf_flutter/Sdf_painter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SDF in Dart')),
        body: Center(
          child: CustomPaint(
            size: Size(400, 400),
            painter: SDFPainter(),
          ),
        ),
      ),
    );
  }
}





