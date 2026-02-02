import '../../models/player.dart';
import '../../models/vote.dart';
import 'game_phase.dart';

enum GameResult{
  liarWin,
  citizenWin
}

class GameState {

  static const int maxExplainTime=60;

  GamePhase phase;
  String topic;
  String keyword;
  int remainTime;

  List<Player> players;
  List<Vote> votes;

  GameResult? result;

  late Map<Player, String?> explanations;

  GameState({
    required this.phase,
    required this.topic,
    required this.keyword,
    required this.remainTime,
    required this.players,
    required this.votes,
    this.result,
  }){
    explanations = {
      for(final p in players) p: null,
    };
  }

  bool get isAllSubmitted{
    return players.every((p) => explanations[p]!=null);
  }

  void handleExplainTimeout() {
    for(final p in players){
      explanations[p] ??= '어려워요';
    }  
  }

  void calculateResult()
  {
    final Map<Player, int> voteCount = {};

    for(final vote in votes)
    {
      voteCount[vote.target] =
          (voteCount[vote.target] ?? 0) + 1;
    }

    Player? selectedPlayer;
    int maxVotes = -1;

    voteCount.forEach((player, count){
      if(count>maxVotes)
      {
        maxVotes = count;
        selectedPlayer = player;
      }
    });

    if(selectedPlayer == null)
    {
      result = GameResult.liarWin;
      return;
    }

    result = selectedPlayer!.isLiar
      ? GameResult.citizenWin
      : GameResult.liarWin;
  }
}

/*
for(final p in state.players)
{
  if(p.isAI)
  {
    state.explanatinos[p] = '과일은 건강에 좋아요'';
  }
}
*/