import 'package:dart_gemini_example/domain/config/type_helper.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final Double width;

  const Logo({super.key, this.width = 228});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/gemini.jpg', width: width);
  }
}
