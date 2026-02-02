import 'dart:async';
import 'package:flutter/material.dart';

import 'game_phase.dart';
import 'game_state.dart';
import '../../models/player.dart';
import '../../models/vote.dart';

import '../../widgets/game/role_check_view.dart';
import '../../widgets/game/explain_view.dart';
import '../../widgets/game/vote_view.dart';
import '../../widgets/game/result_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState state;
  Timer? _timer;

  int _currentExplainIndex = 0;

  Player get _currentPlayer => state.players[_currentExplainIndex];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    state = GameState(
      phase: GamePhase.roleCheck,
      topic: '과일',
      keyword: '망고',
      remainTime: GameState.maxExplainTime,
      players: [
        Player(name: 'ffff', isAI: false, isLiar: false, level: 5),
        Player(name: '플레이어2', isAI: false, isLiar: false, level: 12),
        Player(name: '플레이어3', isAI: false, isLiar: false, level: 8),
        Player(name: 'AI 1', isAI: true, isLiar: true, level: 13),
        Player(name: 'AI 2', isAI: true, isLiar: false, level: 3),
        Player(name: 'AI 3', isAI: true, isLiar: false, level: 19),
      ],
      votes: [],
    );

      state.explanations[state.players[1]] ='저는 망고를 주스로 자주 마셔요';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainTime <= 0) {
        timer.cancel();

        state.handleExplainTimeout();
        _goToVote();
      } else {
        setState(() {
          state.remainTime--;
        });
      }
    });
  }

  void _goToExplain() {
    setState(() {
      state.phase = GamePhase.explain;
      state.remainTime = GameState.maxExplainTime;
      _currentExplainIndex = 0;
    });
    _startTimer();
  }

  void _onExplainSubmitted(){
    if(state.isAllSubmitted){
      _goToVote();
    }else{
      setState(()
      {
        _currentExplainIndex++;
      });
    }
  }

  void _goToVote() {
    _timer?.cancel();
    setState(() {
      state.phase = GamePhase.vote;
    });
  }

  void _goToResult() {
    setState(() {
      state.phase = GamePhase.result;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (state.phase) {
      case GamePhase.roleCheck:
        return RoleCheckView(
          state: state,
          onConfirm: _goToExplain,
        );

      case GamePhase.explain:
        return ExplainView(
          state: state,
          currentPlayer: _currentPlayer,
          onSubmit: _goToVote,
        );

      case GamePhase.vote:
        return VoteView(
          state: state,
          onFinish: _goToResult,
        );

      case GamePhase.result:
        return ResultView(state: state);
    }
  }
}