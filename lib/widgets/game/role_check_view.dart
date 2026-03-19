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
  // final player = state.currentPlayer;
  // 추후에 위와 같은 형태로 코드 수정

  final bool isFoolMode = state.mode == GameMode.fool;
  final bool isLiar = player.isLiar;
  final bool isSpy = state.mode == GameMode.spy&&player.isSpy;

  String keywordToShow;

  if(state.mode == GameMode.fool && player.isLiar)
  {
    keywordToShow = state.fakeKeyword;
  }
  else
  {
    keywordToShow = state.keyword;
  }

  //final bool isLiar = player.isLiar;

  return Scaffold(
    appBar: const GradientAppBar(title: '  '),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height:10),

          /// 🎭 역할 멘트
          Text(
            isFoolMode
              ?'제시어를 확인하세요'
              :isSpy
                ?'당신은 스파이입니다.'
                :isLiar ? '당신은 라이어입니다' : '당신은 시민입니다',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isFoolMode
                      ?Colors.green
                      :isSpy
                        ?Colors.blue
                        : (isLiar ? Colors.red : Colors.green),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          /// 🎭 안내 문구
          Text(
            isFoolMode
              ?'제시어를 확인하고\n라이어를 찾아보세요!'
              :isSpy
                ?'라이어가 제시어를 알아차릴 수 있게\n설명해보세요!'
              :isLiar
                ? '제시어는 공개되지 않습니다.\n'
                  '다른 플레이어들의 설명을 듣고\n'
                  '정체를 숨기세요!'
                : '제시어를 확인하고\n'
                  '라이어를 찾아보세요!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          /// 📌 주제 & 제시어 카드
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '주제',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.topic,
                      style: GameTextStyles.purple,
                      textAlign: TextAlign.center,
                    ),

                    if (isFoolMode||!isLiar || isSpy) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      const Text(
                        '제시어',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        keywordToShow,
                        style: GameTextStyles.pink.copyWith(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),

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