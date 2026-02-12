// role_check_view.dart

import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../common/gradient_app_bar.dart';
import '../common/role_chip.dart';
import '../common/text_style.dart';
import '../common/game_button.dart';

class RoleCheckView extends StatelessWidget {
  final GameState state;
  final VoidCallback onConfirm;

  const RoleCheckView({
    super.key,
    required this.state,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final player = state.players.first;
    final bool isLiar = player.isLiar;

    return Scaffold(
      appBar: const GradientAppBar(title: '역할 확인'),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 역할 칩 (공통 위젯)
                RoleChip(
                  text: isLiar?'라이어':'시민',
                  isLiar: isLiar,
                ),
                const SizedBox(height: 20),

                const Text('주제'),
                const SizedBox(height: 6),
                Text(
                  state.topic,
                  style: GameTextStyles.purple,
                ),

                const Divider(height: 32),

                if(!isLiar) ...[
                  const Text('제시어'),
                  const SizedBox(height:6),
                  Text(
                    state.keyword,
                    style: GameTextStyles.pink,
                  ),
                ]else... [
                  const Text(
                    '당신은 라이어입니다',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height:8),
                  const Text(
                    '제시어는 공개되지 않습니다\n'
                    '다른 플레이어들의 설명을 잘 듣고\n'
                    '정체를 숨겨보세요!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),

      /// 🔥 공통 버튼 사용
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: '확인',
          onPressed: onConfirm,
        ),
      ),
    );
  }
}
