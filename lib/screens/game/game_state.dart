//game_state.dart

import '../../models/player.dart';
import '../../models/vote.dart';
import 'game_phase.dart';

enum GameResult {
  liarWin,
  citizenWin,
}
//
enum GameMode{
  normal,
  fool,
  spy,
}

class GameState {
  static const int maxExplainTime = 10;
  //추후에 수정하기

  int explainTime;
  int voteTime;
  GameMode mode;

  GamePhase phase;
  String topic;
  String keyword;
  String fakeKeyword;

  int remainTime;

  List<Player> players;
  List<Player> activeCandidates;
  List<Vote> votes;

  int currentVoterIndex = 0;

  GameResult? result;

  Player? finalVotedPlayer; // 최종 지목된 사람
  bool liarGuessedCorrectly = false;

  late Map<Player, String?> explanations;

  GameState({
    required this.phase,
    required this.topic,
    required this.keyword,
    required this.fakeKeyword,
    //required this.remainTime,
    required this.players,
    required this.votes,
    required this.explainTime,
    required this.voteTime,
    required this.mode,
  }) : remainTime = explainTime,
    activeCandidates = players {
    explanations = {
      for (final p in players) p: null,
    };
  }

  // ⏱ 토론 시간 감소
  void tickExplainTime() {
    if (remainTime > 0) {
      remainTime--;
    }
  }

  // 🗳 최다 득표자(동점 포함) 구하기
  List<Player> getMostVotedPlayers() {
    final Map<Player, int> count = {};

    for (final vote in votes) {
      count[vote.target] = (count[vote.target] ?? 0) + 1;
    }

    int max = 0;
    List<Player> result = [];

    count.forEach((player, c) {
      if (c > max) {
        max = c;
        result = [player];
      } else if (c == max) {
        result.add(player);
      }
    });

    return result;
  }

  // 🔁 동점 발생 시 상태 리셋
  void resetForTie(List<Player> tiedPlayers) {
    activeCandidates = tiedPlayers;
    votes.clear();

    for (final p in tiedPlayers) {
      explanations[p] = null;
    }

    remainTime = maxExplainTime;
  }

  void startVote(){
    votes.clear();
    currentVoterIndex = 0;
  }

  void finalizeResultAfterLiarGuess(){
    if(liarGuessedCorrectly){
      result = GameResult.liarWin;
    }else{
      result = GameResult.citizenWin;
    }
  }

  // 🎯 최종 결과 계산 (예시)
  void calculateResult() {
    final mostVoted = getMostVotedPlayers().first;

    finalVotedPlayer = mostVoted; //
    activeCandidates = players;

    if(mode == GameMode.spy&&mostVoted.isSpy){
      result = GameResult.citizenWin;
      return;
    }
    
    if(mostVoted.isLiar){
      result = GameResult.citizenWin;
      return;
    }

    result = GameResult.liarWin;
/*
    result = mostVoted.isLiar
        ? GameResult.citizenWin
        : GameResult.liarWin;
*/
  }
}
/*
Player getMostVotedPlayer()
{
  return getMostVotedPlayers().first;
}

bool isMostVotedPlayerLiar(){
  final player = getMostVotedPlayer();
  return player.isLiar;
}*/
/*
for(final p in state.players)
{
  if(p.isAI)
  {
    state.explanatinos[p] = '과일은 건강에 좋아요'';
  }
}
*/