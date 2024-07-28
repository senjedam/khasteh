import 'package:flutter/material.dart';
import '../utils/game_config.dart';
import '../utils/game_utils.dart';

class DropLineWidget extends StatelessWidget {
  final int pos;
  final int snakesDest;

  const DropLineWidget({super.key, required this.pos, required this.snakesDest});

  @override
  Widget build(BuildContext context) {
    var poses=GameUtils().getPoses(pos);
    var snakesDestPoses=GameUtils().getPoses(snakesDest);
    var rowDistance=poses["rowNum"]!-snakesDestPoses["rowNum"]!;

    List<Widget> lines=[];
    for(var i = 0; i < 3*rowDistance; i++){
      lines.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(width: 2,height: 10,decoration: BoxDecoration(color: Colors.black.withOpacity(0.15),borderRadius: const BorderRadius.all(Radius.circular(10))),),
      ),);
    }
    return Positioned(
        left:poses["leftPos"]!+GameConfig.fieldSize/2,
        bottom:snakesDestPoses["bottomPos"]!+GameConfig.fieldSize/2,
        child: Column(
          children: lines,
        )
    );
  }
}
