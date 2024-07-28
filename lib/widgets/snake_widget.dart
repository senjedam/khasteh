import 'package:flutter/material.dart';
import '../utils/game_config.dart';
import '../utils/game_utils.dart';

class SnakeWidget extends StatelessWidget {
  final int pos;
  const SnakeWidget({super.key, required this.pos});

  @override
  Widget build(BuildContext context) {
    var poses=GameUtils().getPoses(pos);

    return Positioned(
        left:poses["leftPos"],
        bottom:poses["bottomPos"],
        // child: Transform(
        //     alignment: Alignment.center,
        // transform: poses["rowNum"]!%2==0?(Matrix4.identity()..scale(-1.0, 1.0)):(Matrix4.identity()..scale(1.0, 1.0)),
        child: SizedBox(
            width: GameConfig.fieldSize,
            height: GameConfig.fieldSize,
            child: Image.asset('assets/cat/catWithKnife.png',fit: BoxFit.cover,alignment: Alignment.bottomCenter,color: Color(0xff404040),))
        // )
    );
  }
}
