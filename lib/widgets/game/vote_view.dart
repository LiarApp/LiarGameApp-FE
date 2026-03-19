// vote_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../../models/player.dart';
import '../../models/vote.dart';
import '../common/gradient_app_bar.dart';
import '../common/game_button.dart';
import '../common/text_style.dart';

class VoteView extends StatefulWidget {
  final GameState state;
  final VoidCallback onFinish;

  const VoteView({
    super.key,
    required this.state,
    required this.onFinish,
  });

  @override
  State<VoteView> createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  Player? selectedPlayer;
  Timer? _timer;
  bool _finished = false;

  Player get currentPlayer => widget.state.players.first;

  @override
  void initState() {
    super.initState();
    widget.state.remainTime = widget.state.voteTime;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.state.remainTime > 0) {
        setState(() {
          widget.state.remainTime--;
        });
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_finished) return;

    _timer?.cancel();
    _finished = true;

    // 아무 투표도 저장하지 않고 종료
    widget.onFinish();
  }

  void _submitVote() {
    if (_finished || selectedPlayer == null) return;

    _timer?.cancel();
    _finished = true;

    widget.state.votes.add(
      Vote(
        voter: currentPlayer,
        target: selectedPlayer!,
      ),
    );

    widget.onFinish();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = widget.state.activeCandidates
        .where((p) => p != currentPlayer)
        .toList();

    final progress =
        widget.state.remainTime / widget.state.voteTime;

    return Scaffold(
      appBar: const GradientAppBar(title: ' '),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${widget.state.remainTime}초 남음',
                  style: GameTextStyles.normal,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, index) {
                final player = players[index];
                final selected = selectedPlayer == player;

                return GestureDetector(
                  onTap: _finished
                      ? null
                      : () {
                          setState(() {
                            selectedPlayer = player;
                          });
                        },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: selected
                            ? const Color(0xFF8A3CFF)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor:
                              const Color(0xFFB56CFF),
                          child: Text(
                            player.name[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(player.name,
                            style: GameTextStyles.normal),
                        const SizedBox(height: 4),
                        Text(
                          'Lv.${player.level}',
                          style: GameTextStyles.gray,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: '투표하기',
          onPressed:
              selectedPlayer == null || _finished
                  ? null
                  : _submitVote,
        ),
      ),
    );
  }
}