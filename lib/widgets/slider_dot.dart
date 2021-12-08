import 'package:flutter/material.dart';

class SliderDot extends StatelessWidget {
  final bool isActive;

  const SliderDot({Key? key,required this.isActive}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:const Duration(milliseconds: 99),
      margin:const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 12 : 5,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius:const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
