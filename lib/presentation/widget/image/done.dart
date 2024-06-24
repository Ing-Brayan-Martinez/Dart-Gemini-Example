import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoneImage extends StatelessWidget {
  const DoneImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: SvgPicture.asset('assets/icons/done.svg'),
    );
  }
}

class SmallDoneImage extends StatelessWidget {
  const SmallDoneImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: SvgPicture.asset('assets/icons/done.svg'),
    );
  }
}
