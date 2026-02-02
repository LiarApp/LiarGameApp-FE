import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../../models/player.dart';
import '../common/gradient_app_bar.dart';
import '../common/info_row.dart';
import '../common/text_style.dart';

class ResultView extends StatelessWidget {
  final GameState state;

  const ResultView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {

    final GameResult result = state.result!;
    final bool isLiarWin = result == GameResult.liarWin;

    final Player liar =
        state.players.firstWhere((p) => p.isLiar);

    final IconData resultIcon = isLiarWin
        ?Icons.sentiment_very_dissatisfied
        :Icons.sentiment_very_satisfied;

    final TextStyle resultColorStyle = isLiarWin
        ?GameTextStyles.pink
        :GameTextStyles.purple;

    final String resultTitle =
        isLiarWin?'라이어 승리!':'시민 승리!';

    return Scaffold(
      appBar: const GradientAppBar(title: '게임 결과'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              resultIcon,
              size: 72,
              color: resultColorStyle.color,
            ),
            const SizedBox(height: 12),
            Text(
              resultTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 40),

            /// 🔥 공통 InfoRow 사용
            InfoRow(title: '주제', value: state.topic),
            InfoRow(title: '제시어', value: state.keyword),

            const SizedBox(height: 24),
            const Text(
              '라이어',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// 🔥 공통 TextStyle 사용
            Text(
              liar.name,
              style: GameTextStyles.pink,
            ),

            const SizedBox(height: 32),
            const Text(
              '플레이어 역할',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: state.players.map(
                      (p) => ListTile(
                        title: Text(p.name),
                        trailing: Text(
                          p.isLiar ? '라이어' : '시민',
                          style: p.isLiar
                              ? GameTextStyles.pink
                              : GameTextStyles.purple,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}