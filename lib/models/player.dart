class Player{
  final String name;
  final bool isLiar;
  final bool isAI;

  final int level;

  final String profileImage;
  final double winRate;

  Player({
    required this.name,
    required this.isLiar,
    required this.isAI,
    required this.level,
    required this.profileImage,
    required this.winRate,
  });
}