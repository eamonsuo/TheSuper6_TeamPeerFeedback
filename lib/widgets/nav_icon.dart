import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {

  final Icon icon;
  final String text;

  NavIcon(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(text),
            ],
          );
  }
}