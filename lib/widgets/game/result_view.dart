//result_view.dart

import 'dart:async';

import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../../models/player.dart';
import '../common/gradient_app_bar.dart';
import '../common/info_row.dart';
import '../common/text_style.dart';

class ResultView extends StatelessWidget {
  final GameState state;
  final Player currentPlayer;

  const ResultView({
    super.key,
    required this.state,
    required this.currentPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final GameResult result = state.result!;
    final bool isLiarWin = result == GameResult.liarWin;

    final bool isMeLiar = currentPlayer.isLiar;

    final bool isMyWin =
        (isLiarWin && isMeLiar) ||
        (!isLiarWin && !isMeLiar);

    final String resultTitle =
        isLiarWin ? '라이어 승리!' : '시민 승리!';

    return Scaffold(
      appBar: const GradientAppBar(title: ' '),
      body: SingleChildScrollView(   // 🔥 전체 스크롤 가능
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// ===============================
            /// 🔥 승패 영역
            /// ===============================

            Icon(
              isMyWin
                  ? Icons.sentiment_very_satisfied   // 🔥 내가 이기면 긍정
                  : Icons.sentiment_very_dissatisfied, // 🔥 내가 지면 부정
              size: 72,
              color: isMyWin ? Colors.green : Colors.red,
            ),

            const SizedBox(height: 12),

            Text(
              resultTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isMyWin ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isMyWin ? '승리 🎉' : '패배 😢',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            /// ===============================
            /// 🔥 게임정보 영역
            /// ===============================

            const SizedBox(height: 16),
            const Text(
              '게임정보',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// 🔥 주제 컨테이너
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '주제: ${state.topic}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),

            /// 🔥 제시어 컨테이너
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '제시어: ${state.keyword}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            /// ===============================
            /// 🔥 플레이어 역할 영역
            /// ===============================

            const SizedBox(height: 16),
            const Text(
              '플레이어 역할',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Column(
              children: state.players.map((p) {
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.name),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: state.mode == GameMode.spy && p.isSpy
                          ?Colors.blue
                          :p.isLiar
                              ? Colors.red
                              : Colors.black,
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                        child: Text(
                          state.mode == GameMode.spy && p.isSpy
                          ?'스파이'
                          :p.isLiar
                              ? '라이어'
                              : '시민',
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Divider(),

            /// ===============================
            /// 🔥 보상 영역
            /// ===============================

            const SizedBox(height: 16),
            const Text(
              '보상',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _rewardBox('경험치', isMyWin ? '+50' : '+10'),
                _rewardBox('코인', isMyWin ? '+30' : '+5'),
                _rewardBox('랭킹점수', isMyWin ? '+20' : '-10'),
              ],
            ),

            const SizedBox(height: 24),

            /// 버튼 영역
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context,
                          (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey.shade300,
                      foregroundColor:
                          Colors.black,
                      minimumSize:
                          const Size.fromHeight(48),
                    ),
                    child: const Text('홈으로'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style:ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('한 판 더'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardBox(String title, String value) {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}