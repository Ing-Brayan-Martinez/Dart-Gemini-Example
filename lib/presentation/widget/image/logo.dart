import 'package:dart_gemini_example/domain/config/type_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  final Double width;

  const Logo({super.key, this.width = 228});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icons/logo-tienda-sierth.svg',
        width: width);
  }
}
