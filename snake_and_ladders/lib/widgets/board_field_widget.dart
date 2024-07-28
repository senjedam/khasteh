import 'package:flutter/material.dart';
import 'package:snake_and_ladders/theme/app_colors.dart';

class BoardFieldWidget extends StatelessWidget {
  final int num;

  const BoardFieldWidget(
      {required this.num, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.25),
      child: Container(
        decoration:
            const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2)),
              color: AppColors.textColor,),
        height: 100,
        width: 50,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            num.toString(),
            style: TextStyle(fontSize: 11,color: Colors.black.withOpacity(0.2)),
          ),
        ), //12
      ),
    );
  }
}