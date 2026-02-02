import 'package:flutter/material.dart';
import 'package:liar_game/widgets/common/gradient_app_bar.dart';
import '../../screens/game/game_state.dart';
import '../../models/player.dart';
import '../common/game_button.dart';

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
  State<ExplainView> createState() =>_ExplainViewState();
}

class _ExplainViewState extends State<ExplainView>{
  final TextEditingController _controller = TextEditingController();

  bool get isSubmitted =>
    widget.state.explanations[widget.currentPlayer]!=null;

  bool _isRevealTime = false;

    @override
    void dispose()
    {
      _controller.dispose();
      super.dispose();
    }

    void _submit(){
      if(_controller.text.trim().isEmpty) return ;

    setState((){
      widget.state.explanations[widget.currentPlayer] =
        _controller.text.trim();

        _isRevealTime = true;
    });
  }

  void _goNext(){
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      appBar: const GradientAppBar(title: '토론'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('토론 시간'),
                Text(
                  '${state.remainTime}초',
                  style: const TextStyle(
                    color: Color(0xFF8A3CFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value:
                  state.remainTime / GameState.maxExplainTime,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF8A3CFF),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: state.players.map((p)
                {
                  final explanation = state.explanations[p];

                  return Card(
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        explanation == null
                        ?'작성 중...'
                        :_isRevealTime
                          ? explanation
                          :'제출 완료',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if(!isSubmitted&&!_isRevealTime) ...[
              const SizedBox(height:12),
              TextField(
                controller: _controller,
                maxLines:2,
                decoration: const InputDecoration(
                  hintText: '설명을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: GameButton(
          text: isSubmitted ? '다음으로':'제출',
          onPressed: isSubmitted? _goNext:_submit,
        ),
      ),
    );
  }
}