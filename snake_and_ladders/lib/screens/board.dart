import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:snake_and_ladders/theme/app_colors.dart';
import 'dart:math';
import 'package:snake_and_ladders/utils/game_config.dart';
import 'package:snake_and_ladders/utils/game_utils.dart';
import 'package:snake_and_ladders/widgets/board_field_widget.dart';
import 'package:snake_and_ladders/widgets/custom_overlay_widget.dart';
import 'package:snake_and_ladders/widgets/ladder_widget.dart';
import 'package:snake_and_ladders/widgets/snake_widget.dart';
import '../widgets/custom_dice_widget.dart';
import '../widgets/drop_line_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget>
    with SingleTickerProviderStateMixin {
  int? diceNumber;

  Offset offset1 = const Offset(0, 0);
  String? currentPlayerImage;

  final ValueNotifier<int?> _diceNumberNotifier = ValueNotifier<int?>(0);

  final ValueNotifier<double> _positionNotifier = ValueNotifier<double>(0);

  AnimationController? _controller;
  Animation<double>? _animation;
  bool isAnimationCompleted = true;

  PathMetric? _pathMetric;
  double _pathLength = 0.0;

  late List<int> snakes;
  late List<int> snakesDest;
  late List<int> ladders;
  late List<int> laddersDest;

  late Box gameBox;

  bool _isPlayer1Turn = true;
  int _player1Pos = 1;

  @override
  void initState() {
    super.initState();

    snakes = GameConfig.snakesMap.keys.toList();
    snakesDest = GameConfig.snakesMap.values.toList();
    ladders = GameConfig.laddersMap.keys.toList();
    laddersDest = GameConfig.laddersMap.values.toList();

    currentPlayerImage = GameConfig.catImages['sitting'];

    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _animation!.addListener(() {
      if (_animation!.value == 1) {
        isAnimationCompleted = true;
      }

      // if(!_isPlayer1Turn) {
        offset1 = GameUtils.getOffsetForAnimation(
            _animation!.value, _pathLength, _pathMetric);
        _positionNotifier.value = _animation!.value;
      // }
    });

    gameBox = Hive.box('gameBox');
  }

  @override
  void dispose() {
    super.dispose();
    _positionNotifier.dispose();
    _controller?.dispose();
  }

  void _addResult() {
    var score = gameBox.get('score', defaultValue: 0);
    gameBox.put('playerName', 'Player1');
    gameBox.put('score', score + 1);
    // setState(() {});
  }

  // void getGameResult() {
  //   var box = Hive.box('gameBox');
  //   String playerName = box.get('playerName');
  //   int score = box.get('score');
  //   print('Player: $playerName, Score: $score');
  // }

  @override
  Widget build(BuildContext context) {
    // String playerName = gameBox.get('playerName', defaultValue: 'No Player');

    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: GameConfig.maxBoardWidth,
              // height: GameConfig.maxBoardWidth*1.5,
              child: Stack(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 100,
                    padding: const EdgeInsets.all(0), //20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 10,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      int num = 100 -
                          ((index % 20) < 10
                              ? index
                              : (((index ~/ 10) * 20) + 9 - index));
                      return BoardFieldWidget(num: num);
                    },
                  ),
                  for (int i = 0; i < snakes.length; i++) ...{
                    DropLineWidget(
                      pos: snakes[i],
                      snakesDest: snakesDest[i],
                    ),
                    SnakeWidget(pos: snakes[i]),
                  },
                  for (int i = 0; i < ladders.length; i++)
                    LadderWidget(pos: ladders[i], destPos: laddersDest[i]),
                  ValueListenableBuilder<double>(
                    valueListenable: _positionNotifier,
                    builder: (context, value, child) {
                      if (isAnimationCompleted) {
                        currentPlayerImage = GameConfig.catImages['sitting'];
                        if (GameConfig.snakesMap.containsKey(_player1Pos)) {
                          runChangePositionAnimation(
                              GameConfig.catImages['falling'],
                              GameConfig.snakesMap[_player1Pos]!,
                              true);
                        } else if (GameConfig.laddersMap
                            .containsKey(_player1Pos)) {
                          runChangePositionAnimation(
                              GameConfig.catImages['sitting'],
                              GameConfig.laddersMap[_player1Pos]!,
                              true);
                        }
                      }
                      return Positioned(
                        left: _player1Pos <= 100 ? offset1.dx : 0,
                        bottom: _player1Pos <= 100 ? offset1.dy : 600,
                        child: Transform(
                            alignment: Alignment.center,
                            transform:
                                (offset1.dy / GameConfig.fieldSize % 2) >= 1 ||
                                        currentPlayerImage ==
                                            GameConfig.catImages['falling']
                                    ? (Matrix4.identity()..scale(-1.0, 1.0))
                                    : (Matrix4.identity()..scale(1.0, 1.0)),
                            child: SizedBox(
                                width: GameConfig.fieldSize *
                                    (currentPlayerImage ==
                                            GameConfig.catImages['running']
                                        ? 1.5
                                        : 1),
                                height: GameConfig.fieldSize * 1,
                                child: Image.asset(
                                  currentPlayerImage!,
                                  fit: (currentPlayerImage ==
                                          GameConfig.catImages['running']
                                      ? BoxFit.fitWidth
                                      : BoxFit.fitHeight),
                                  color: Colors.black,
                                ))),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                // width: 400,
                // color: AppColors.accentColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<int?>(
                      valueListenable: _diceNumberNotifier,
                      builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            if (isAnimationCompleted) {
                              diceNumber = await runDice();
                              _diceNumberNotifier.value = diceNumber;
                              // _controller.playerMove(pos);
                            }
                          },
                          child: _isPlayer1Turn
                              ? CustomDiceWidget(diceNumber)
                              : Container(),
                        );
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 50.0),
                    //   child: Container(
                    //       decoration: const BoxDecoration(
                    //         color: AppColors.primaryColor,
                    //         borderRadius: BorderRadius.all(Radius.circular(5)),),
                    //       width:90,
                    //       child: Image.asset(GameConfig.catImages['sitting']!)
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> runDice() async {
    Random random = Random();
    int randomNumber = random.nextInt(6) + 1;
    int newPos = randomNumber + _player1Pos;

    // if (_isPlayer1Turn) {
      runChangePositionAnimation(
          GameConfig.catImages['running'], newPos, false);
      // _isPlayer1Turn = !_isPlayer1Turn;
      // _computerMove();
    // } else {
    //   // offset2=offset;
    //   // newPos = randomNumber + _player2Pos;
    //   // _computerMove();
    // }

    if (newPos > 100) {
      newPos = 100;
    }
    if (newPos == 100) {
      _addResult();
      int score = gameBox.get('score', defaultValue: 0);

      await Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return CustomOverlayWidget(score);
          },
        ),
      );

      diceNumber = null;
      newPos = 1;
      _diceNumberNotifier.value = null;
      _player1Pos = 1;
      offset1 = const Offset(0, 0);
      setState(() {});
      return 0;
    }
    return randomNumber;
  }

  runChangePositionAnimation(String? catImage, int newPos, bool isDirectPath) {
    List pathMakerObj =
        GameUtils().pathMaker(_player1Pos, newPos, isDirectPath);
    _pathMetric = pathMakerObj[0];
    _pathLength = pathMakerObj[1];
    // pos = newPos;
    _player1Pos = newPos;
    _controller!.reset();
    isAnimationCompleted = false;
    _controller!.forward();
    currentPlayerImage = catImage;
  }
}