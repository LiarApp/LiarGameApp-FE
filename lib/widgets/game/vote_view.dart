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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: '투표'),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.state.players.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, index) {
          final player = widget.state.players[index];
          final selected = selectedPlayer == player;

          return GestureDetector(
            onTap: () {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFB56CFF),
                    child: Text(
                      player.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    player.name,
                    style: GameTextStyles.normal,
                  ),

                  const SizedBox(height: 4),
                  Text(
                    'Lv.${player.level}',
                    style: GameTextStyles.gray,
                  ),

                  if (selected) ...[
                    const SizedBox(height: 10),
                    const Chip(
                      label: Text('선택됨'),
                      backgroundColor: Color(0xFFEDE4FF),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: '투표하기',
          onPressed: selectedPlayer == null
            ? null
            : (){
                final Player currentPlayer=
                  widget.state.players[0];

              widget.state.votes.add(
                Vote(
                  voter: currentPlayer,
                  target:selectedPlayer!, 
                ),
              );

              widget.state.calculateResult();

              widget.onFinish();
            },
        ),
      ),
    );
  }
}