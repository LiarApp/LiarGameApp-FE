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
    return Scaffold(
      appBar: const GradientAppBar(title: '주제 확인'),
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
                  text: '시민',
                  isLiar: false,
                ),
                const SizedBox(height: 20),

                const Text('주제'),
                const SizedBox(height: 6),
                Text(
                  state.topic,
                  style: GameTextStyles.purple,
                ),

                const Divider(height: 32),

                const Text('제시어'),
                const SizedBox(height: 6),
                Text(
                  state.keyword,
                  style: GameTextStyles.pink,
                ),
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
