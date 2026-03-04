//game_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';

import 'game_phase.dart';
import 'game_state.dart';

import '../../widgets/game/role_check_view.dart';
import '../../widgets/game/explain_view.dart';
import '../../widgets/game/vote_view.dart';
import '../../widgets/game/vote_reveal_view.dart';
import '../../widgets/game/result_view.dart';
import '../../models/player.dart';
import '../../widgets/game/liar_guess_view.dart';

class GameScreen extends StatefulWidget {

  final int voteTime;
  final int explainTime;
  final GameMode mode;

  const GameScreen({
    super.key,
    required this.voteTime,
    required this.explainTime,
    required this.mode,
    });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState state;

  @override
  void initState() {
    super.initState();

    state = GameState(
      phase: GamePhase.roleCheck,
      topic: '과일',
      keyword: '망고',
      explainTime: widget.explainTime,
      voteTime: widget.voteTime,
      mode: widget.mode,
      //remainTime: GameState.maxExplainTime,
      players: [
        Player(name:'ffff', isAI:false, isLiar: false, level:5, profileImage: "", winRate: 0.62),
        Player(name: '플레이어2', isAI: false, isLiar:false, level:12, profileImage: "", winRate: 0.5),
        Player(name: '플레이어3', isAI: false, isLiar:false, level:8, profileImage: "", winRate: 0.46),
        Player(name: 'AI 1', isAI:true, isLiar: true, level:13, profileImage: "", winRate: 0.71),
        Player(name: 'AI 2', isAI: true, isLiar:false, level:3, profileImage: "", winRate: 0.49),
        Player(name: 'AI 3', isAI: true, isLiar: false, level:19, profileImage: "", winRate: 0.81),
      ],
      votes: [],
    );
          state.explanations[state.players[1]] = '저는 망고를 주스로 자주 마셔요';

  }

  void _goToResultOrTie()
  {
    setState((){
      state.phase = GamePhase.voteReveal;
    });
  }

  /// 투표 종료 → 동점이면 재설명, 아니면 결과 공개
  /*
  void _goToResultOrTie() {
    final tiedPlayers = state.getMostVotedPlayers();

    if (tiedPlayers.length > 1) {
      setState(() {
        state.resetForTie(tiedPlayers);
        state.phase = GamePhase.explain;
      });
      return;
    }

    setState(() {
      state.phase = GamePhase.voteReveal;
    });
  }
  */

  void _goToFinalResult() {
    state.calculateResult();
    setState(() {
      state.phase = GamePhase.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (state.phase) {
      case GamePhase.roleCheck:
        return RoleCheckView(
          state: state,
          onConfirm: () {
            setState(() {
              state.phase = GamePhase.explain;
            });
          },
        );

      case GamePhase.explain:
        return ExplainView(
          state: state,
          currentPlayer: state.players.first,
          onSubmit: () {
            setState(() {
              state.startVote();
              state.phase = GamePhase.vote;
            });
          },
        );

      case GamePhase.vote:
        return VoteView(
          state: state,
          onFinish: _goToResultOrTie,
        );
/*
      case GamePhase.voteReveal:
        return VoteRevealView(
          state: state,
          onNext: _goToFinalResult,
        );
*/

      case GamePhase.voteReveal:
        return VoteRevealView(
          state: state,
          onNext: (nextPhase){
            setState(() {
              state.phase = nextPhase;
            });
          },
        );

      case GamePhase.result:
        return ResultView(
          state: state,
          currentPlayer: state.players.first,
        );

      case GamePhase.liarGuess:
        return LiarGuessView(
          state: state,
          onFinish:(){
            setState(() {
              state.phase = GamePhase.result;
            });
          },
        );
    }
  }
}