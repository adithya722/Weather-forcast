import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final double thickness;
  final double startIndent;
  final double endIndent;

   CustomDivider({
    this.color = Colors.grey,
    this.thickness = 2,
    this.startIndent = 0,
    this.endIndent = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: startIndent,
      endIndent: endIndent,
    );
  }
}
