import 'dart:ui';
import 'package:snake_and_ladders/utils/game_config.dart';

class GameUtils {
  Map<String, double> getPoses(int pos){
    int rowNum=((pos-1)~/10);
    int colNum=(((pos-1)%10));
    double horizontalDistance=(colNum*GameConfig.fieldSize+GameConfig.paddingBetween);
    double leftPos=((rowNum%2)==0)?horizontalDistance:(GameConfig.maxBoardWidth-horizontalDistance-GameConfig.fieldSize);
    double bottomPos=rowNum*GameConfig.fieldSize+GameConfig.paddingBetween;
    return {"leftPos":leftPos,"bottomPos":bottomPos,"rowNum":rowNum.toDouble()};
  }

  List<Object> pathMaker(int previousPos, int currentPos, bool isDirectPath){
    var poses=getPoses(currentPos);
    var leftPos=poses["leftPos"]!;
    var bottomPos=poses["bottomPos"]!;
    int rowNum=poses["rowNum"]!.toInt();
    Path? _path;
    PathMetrics? pathMetrics;
    PathMetric? _pathMetric;

    poses=getPoses(previousPos);
    var previousLeftPos=poses["leftPos"]!;
    var previousBottomPos=poses["bottomPos"]!;
    int previousRowNum=poses["rowNum"]!.toInt();

    if(isDirectPath){
      _path = Path()
        ..moveTo(previousLeftPos, previousBottomPos)
        ..quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
    }
    else if(previousRowNum!=rowNum){//upperRow
      if(previousPos%10==0){//اگر از گوشه داشت میرفت طبقه بعدی
        if(currentPos==(previousPos+1)){//اگر میرف یه اجر بالاتر
          _path = Path()
            ..moveTo(previousLeftPos, previousBottomPos)
            ..quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
        }
        else{//اگ بیش از یه اجر پیش رف
          var poses=getPoses(previousPos+1);//82
          double tmpleftPos=poses["leftPos"]!;
          double tmpbottomPos=poses["bottomPos"]!;
          _path = Path()
            ..moveTo(previousLeftPos, previousBottomPos)
          // ..quadraticBezierTo(previousLeftPos, tmpbottomPos, tmpleftPos,tmpbottomPos)
          // ..quadraticBezierTo(leftPos, tmpbottomPos, tmpleftPos,tmpbottomPos)
            ..quadraticBezierTo(tmpleftPos, tmpbottomPos, tmpleftPos,tmpbottomPos)
            ..quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
          // rowNum
        }
      }
      else{//اگر از جایی غیر گوشه داشت میرفت طبقه بعدی
        if(currentPos%10==1){// اگه به اجر بالا میخواس بره
          _path = Path()
            ..moveTo(previousLeftPos, previousBottomPos)
            ..quadraticBezierTo(leftPos, previousBottomPos, leftPos,previousBottomPos)
            ..quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
        }//اگه مقصد جایی غیر از یه اجر بالتر بود
        else{
          var poses=getPoses(((previousRowNum+1)*10-1));
          double tmpleftPos=poses["leftPos"]!;
          double tmpbottomPos=poses["bottomPos"]!;

          _path = Path()
            ..moveTo(previousLeftPos, previousBottomPos)
            ..quadraticBezierTo(tmpleftPos, tmpbottomPos, tmpleftPos,tmpbottomPos);
          _path.quadraticBezierTo(tmpleftPos, tmpbottomPos, tmpleftPos,tmpbottomPos);
          _path.quadraticBezierTo(tmpleftPos+(rowNum%2!=0?GameConfig.fieldSize:(-GameConfig.fieldSize)), (bottomPos+tmpbottomPos)/2, tmpleftPos,bottomPos);
          // _path.quadraticBezierTo(tmpleftPos, bottomPos, tmpleftPos,bottomPos);
          _path.quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
        }
      }
    }
    else{//currentRow
      _path = Path()
        ..moveTo(previousLeftPos, previousBottomPos)
        ..quadraticBezierTo(leftPos, bottomPos, leftPos,bottomPos);
    }
    pathMetrics = _path.computeMetrics();
    _pathMetric = pathMetrics.first;
    double _pathLength = _pathMetric.length;

    return [_pathMetric,_pathLength];
  }

  static Offset getOffsetForAnimation(double value,double pathLength,PathMetric? pathMetric) {
    double distance = pathLength * value;
    Tangent? tangent = pathMetric!.getTangentForOffset(distance);
    return tangent!.position;
  }
}