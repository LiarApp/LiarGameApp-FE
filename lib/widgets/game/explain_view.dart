//explain_view.dart
import 'package:flutter/material.dart';
import '../../screens/game/game_state.dart';
import '../../models/player.dart';
import '../common/game_button.dart';
import '../common/gradient_app_bar.dart';

enum ExplainPhase {
  writing,
  reveal,
}

class ExplainView extends StatefulWidget {
  final GameState state;
  final Player currentPlayer;
  final VoidCallback onSubmit;

  const ExplainView({
    super.key,
    required this.state,
    required this.currentPlayer,
    required this.onSubmit,
  });

  @override
  State<ExplainView> createState() => _ExplainViewState();
}

class _ExplainViewState extends State<ExplainView> {
  final TextEditingController _controller = TextEditingController();
  bool _timerRunning = false;

  ExplainPhase _phase = ExplainPhase.writing;
  int _revealRemainTime = 30;

  bool get isSubmitted =>
      widget.state.explanations[widget.currentPlayer] != null;

  @override
  void initState() {
    super.initState();
    _startExplainTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ⏱ 작성 타이머
  void _startExplainTimer() {
    if (_timerRunning) return;
    _timerRunning = true;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        widget.state.tickExplainTime();
      });

      if (widget.state.remainTime == 0) {
        _onExplainTimeOver();
        return false;
      }
      return true;
    }).whenComplete(() {
      _timerRunning = false;
    });
  }

  void _onExplainTimeOver() {
  setState(() {
    widget.state.explanations.forEach((player, explanation) {
      if (explanation == null) {
        widget.state.explanations[player] = '어려워요';
      }
    });

    _phase = ExplainPhase.reveal;
  });

  _startRevealTimer();
}

  // 👀 공개 타이머
  void _startRevealTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _revealRemainTime--;
      });

      if (_revealRemainTime <= 0) {
        widget.onSubmit();
        return false;
      }
      return true;
    });
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      widget.state.explanations[widget.currentPlayer] =
          _controller.text.trim();
    });
  }

  String _buildExplanationText(Player p) {
    final explanation = widget.state.explanations[p];

    // 📢 공개 단계 → 전부 공개
    if (_phase == ExplainPhase.reveal) {
      return explanation ?? '';
    }

    // ✍ 작성 단계

    final bool meSubmitted = widget.state.explanations[widget.currentPlayer] != null;

    if (p == widget.currentPlayer) {
      return explanation ?? '작성 중...';
    }

    if (explanation == null) {
      return '작성 중...';
    }
    
    if(meSubmitted)
    {
      return explanation;
    }

    return '제출 완료';
  }

  @override
  Widget build(BuildContext context) {

    final List<Player> explainTargets =
      widget.state.activeCandidates.length == widget.state.players.length
        ? widget.state.players
        : widget. state.activeCandidates;
        
    final state = widget.state;

    return Scaffold(
      appBar: const GradientAppBar(title: '토론'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ⏱ 타이머
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _phase == ExplainPhase.writing
                      ? '토론 시간'
                      : '답변 공개',
                ),
                Text(
                  _phase == ExplainPhase.writing
                      ? '${state.remainTime}초'
                      : '$_revealRemainTime초',
                  style: const TextStyle(
                    color: Color(0xFF8A3CFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📋 설명 리스트
            Expanded(
              child: ListView(
                children: explainTargets.map((p) {
                  return Card(
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(_buildExplanationText(p)),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ✍ 입력창 (작성 단계 + 미제출)
            if (_phase == ExplainPhase.writing && !isSubmitted) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: '설명을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),

      // ⬇ 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: _phase == ExplainPhase.writing
              ? (isSubmitted ? '대기 중' : '제출')
              : '다음으로',
          onPressed: _phase == ExplainPhase.writing
              ? (isSubmitted ? null : _submit)
              : widget.onSubmit,
        ),
      ),
    );
  }
}

