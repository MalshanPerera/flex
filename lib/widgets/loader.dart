import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {

  final double size;
  final Color color;
  const Loader({
    this.size = 40.0,
    this.color = Colors.deepPurple,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: color,
      size: size,
      lineWidth: 4.0,
    );
  }
}
