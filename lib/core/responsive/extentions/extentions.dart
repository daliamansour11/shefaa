import 'package:flutter/material.dart';

extension Route on BuildContext {
  pushNamed(Widget pageRoute) {
    Navigator.push(this, MaterialPageRoute(builder: (_) => pageRoute));
  }
}
