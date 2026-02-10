//game_state.dart

import '../../models/player.dart';
import '../../models/vote.dart';
import 'game_phase.dart';

enum GameResult {
  liarWin,
  citizenWin,
}

class GameState {
  static const int maxExplainTime = 60;

  GamePhase phase;
  String topic;
  String keyword;
  int remainTime;

  List<Player> players;
  List<Player> activeCandidates;
  List<Vote> votes;

  int currentVoterIndex = 0;

  GameResult? result;

  late Map<Player, String?> explanations;

  GameState({
    required this.phase,
    required this.topic,
    required this.keyword,
    required this.remainTime,
    required this.players,
    required this.votes,
  }) : activeCandidates = players {
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

  // 🎯 최종 결과 계산 (예시)
  void calculateResult() {
    final mostVoted = getMostVotedPlayers().first;

    activeCandidates = players;

    result = mostVoted.isLiar
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