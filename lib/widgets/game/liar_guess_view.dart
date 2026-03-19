//liar_guess_view.dart

import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';

import '../common/gradient_app_bar.dart';
import '../common/game_button.dart';

class LiarGuessView extends StatefulWidget{
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

class _LiarGuessViewState extends State<LiarGuessView>{
  final TextEditingController _controller = TextEditingController();

  void _submitGuess(){
    final guess = _controller.text.trim();
    
    if(guess.isEmpty) return;

    if(guess == widget.state.keyword){
      widget.state.liarGuessedCorrectly = true;
    }else{
      widget.state.liarGuessedCorrectly = false;
    }
    widget.state.finalizeResultAfterLiarGuess();
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context){
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
            
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '제시어를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),

            GameButton(
              text:'정답 제출',
              onPressed: _submitGuess,
            ),
          ],
        ),
      ),
    );
  }
}