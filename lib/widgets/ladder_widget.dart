import 'package:flutter/material.dart';
import 'package:snake_and_ladders/theme/app_colors.dart';
import 'dart:math';
import '../utils/game_config.dart';
import '../utils/game_utils.dart';

class LadderWidget extends StatelessWidget {
  final int pos;
  final int destPos;

  const LadderWidget({super.key, required this.pos, required this.destPos});

  @override
  Widget build(BuildContext context) {
    var poses=GameUtils().getPoses(pos);
    var destPoses=GameUtils().getPoses(destPos);
    double angleRad =(destPoses["leftPos"]!-poses["leftPos"]!)==0?(pi/2):atan((destPoses["bottomPos"]!-poses["bottomPos"]!)/(destPoses["leftPos"]!-poses["leftPos"]!));
    double vatarDistance=(((angleRad==pi/2)?1:1/sin(angleRad))*(destPoses["bottomPos"]!-poses["bottomPos"]!).abs()).abs();
    double ladderStepSize=30;
    double paddingStepSize=1;

    List<Widget> lines=[];
    print(angleRad/pi*180);
    for(var i = 0; i < (vatarDistance/(ladderStepSize+paddingStepSize)); i++){
      lines.add(Padding(
        padding: EdgeInsets.symmetric(vertical: paddingStepSize),
        child: SizedBox(width: ladderStepSize,height: ladderStepSize,
            child: Image.asset('assets/ladders/footStep.png',fit: BoxFit.cover,alignment: Alignment.bottomCenter,//color: Colors.grey
              color:AppColors.accentColor,
            )),
      ),);
    }
    return Positioned(
        left:poses["leftPos"]!+GameConfig.fieldSize/2-(ladderStepSize+paddingStepSize)/2,
        bottom:poses["bottomPos"]!+GameConfig.fieldSize/2,
        child: Transform.rotate(
          angle: (angleRad==pi/2)?0:(angleRad<0?angleRad:(pi/2-angleRad)),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: lines,
          ),
        )
    );
  }
}