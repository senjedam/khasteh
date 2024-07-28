class GameConfig {
  static const double maxBoardWidth = 600.0;
  static const double paddingBetween = 0.0;
  static const double fieldSize = 60.0;

  static const Map<int, int> snakesMap = {
    14:7,
    22:2,
    30:10,
    58:43,
    66:6,
    72:49,
    87:67,
    96:85,
    99:79
  };

  static const Map<int, int> laddersMap = {
    4:16,
    13:33,
    24:45,
    34:54,
    40:60,
    65:83,
  };

  static const Map<String,String> catImages={'running':'assets/cat/cat_run.gif','sitting':'assets/cat/cat_sit_odd_crop.gif','falling':'assets/cat/catFalling.png'};
}