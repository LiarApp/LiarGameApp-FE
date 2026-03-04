// vote_reveal_view.dart

import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../../screens/game/game_phase.dart';
import '../../models/vote.dart';

import '../common/gradient_app_bar.dart';
import '../common/game_button.dart';
import '../common/text_style.dart';

class VoteRevealView extends StatelessWidget {
  final GameState state;
  //final VoidCallback onNext;

  final void Function(GamePhase nextPhase) onNext;

  const VoteRevealView({
    super.key,
    required this.state,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: ' '),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.votes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (_, index) {
          final Vote vote = state.votes[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 투표한 사람
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFB56CFF),
                  child: Text(
                    vote.voter.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  vote.voter.name,
                  style: GameTextStyles.normal,
                ),

                const SizedBox(height: 8),
                const Icon(Icons.arrow_downward, color: Colors.grey),
                const SizedBox(height: 8),

                /// 찍힌 사람
                Text(
                  vote.target.name,
                  style: GameTextStyles.purple,
                ),

                const SizedBox(height: 6),

                const Chip(
                  label: Text('투표 대상'),
                  backgroundColor: Color(0xFFEDE4FF),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: '결과 확인',
          onPressed: (){
            final tiedPlayers = state.getMostVotedPlayers();

            if(tiedPlayers.length>1)
            {
              state.resetForTie(tiedPlayers);
              onNext(GamePhase.explain);
            }
            else
            {
              state.calculateResult();

              if(state.finalVotedPlayer!.isLiar){
                onNext(GamePhase.liarGuess);
              }else{
                state.result = GameResult.liarWin;
                onNext(GamePhase.result);
              }
              /*
              state.calculateResult();
              onNext(GamePhase.result);
              */
            }
          },
        ),
      ),
    );
  }
}