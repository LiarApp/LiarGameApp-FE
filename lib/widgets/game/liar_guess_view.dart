// liar_guess_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liargame/screens/game/game_state.dart';
import '../../models/player.dart';

import '../common/gradient_app_bar.dart';
import '../common/game_button.dart';

class LiarGuessView extends StatefulWidget {
  final GameState state;
  final VoidCallback onFinish;

  const LiarGuessView({
    super.key,
    required this.state,
    required this.onFinish,
    });

  @override
  State<LiarGuessView> createState() => _LiarGuessViewState();
}

class _LiarGuessViewState extends State<LiarGuessView> {
  final TextEditingController _controller = TextEditingController();

  Timer? _timer;
  int _remainingSeconds = 20;
  bool _submitted = false;

  Player get currentPlayer => widget.state.players.first;

  bool get isLiar => currentPlayer.isLiar;
/*
  bool get isLiar {
    final liar = widget.state.players.firstWhere((p) => p.isLiar);
    return liar.isLiar;
  }
*/
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
/*
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _timeOut();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }
*/

  void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        _remainingSeconds--;
      });
      if(_remainingSeconds <=0){
        timer.cancel();
        _timeOut();
      }
    });
  }
  
  void _timeOut() {
    if (_submitted) return;

    _submitted = true;

    widget.state.liarGuessedCorrectly = false;
    widget.state.finalizeResultAfterLiarGuess();

    widget.onFinish();
  }

  void _submitGuess() {
    if (_submitted) return;

    final guess = _controller.text.trim();

    if (guess.isEmpty) return;

    _submitted = true;

    _timer?.cancel();

    if (guess == widget.state.keyword) {
      widget.state.liarGuessedCorrectly = true;
    } else {
      widget.state.liarGuessedCorrectly = false;
    }

    widget.state.finalizeResultAfterLiarGuess();

    widget.onFinish();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: '제시어 추리'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '라이어가 정답을 맞히면 승리합니다!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '주제: ${widget.state.topic}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                '남은 시간: $_remainingSeconds초',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (isLiar) ...[
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '제시어를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),

              const Spacer(),

              GameButton(
                text: '정답 제출',
                onPressed: _submitGuess,
              ),
            ] else ...[
              const Spacer(),

              const Center(
                child: Text(
                  '라이어가 제시어를 추리하는 중입니다...\n잠시만 기다려 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}