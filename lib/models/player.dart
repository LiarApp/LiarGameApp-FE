class Player{
  final String name;
  final bool isLiar;
  final bool isAI;
  final bool isSpy;

  final int level;

  final String profileImage;
  final double winRate;

  Player({
    required this.name,
    required this.isLiar,
    required this.isSpy,
    required this.isAI,
    required this.level,
    required this.profileImage,
    required this.winRate,
  });
}