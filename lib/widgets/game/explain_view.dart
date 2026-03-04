//explain_view.dart
import 'package:flutter/gestures.dart';
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
  late int _initialExplainTime;

  final TextEditingController _controller = TextEditingController();
  bool _timerRunning = false;

  ExplainPhase _phase = ExplainPhase.writing;
  int _revealRemainTime = 30;

  bool get isSubmitted =>
      widget.state.explanations[widget.currentPlayer] != null;

  @override
  void initState() {
    super.initState();
    _initialExplainTime = widget.state.remainTime;
    _startExplainTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getProgressValue(){
    if(_phase == ExplainPhase.writing){
      return widget.state.remainTime/_initialExplainTime;
    }else{
      return _revealRemainTime/30; // reveal time을 30초로 고정해뒀기때문
    }
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

  void _showPlayerProfile(Player player){
    showDialog(
      context: context,
      builder: (context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(player.profileImage),
                ),
                const SizedBox(height: 12),

                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text("레벨: ${player.level}"),
                Text("승률: ${(player.winRate*100).toStringAsFixed(1)}%"),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8A3CFF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("친구추가"),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("차단"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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

  Widget _buildChatBubble({
    required Player player,
    required String message,
  }){
    final bool isMe = player == widget.currentPlayer;
    //final bool isReveal = _phase == ExplainPhase.reveal;

    return GestureDetector(
    onTap: () => _showPlayerProfile(player),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isMe?Alignment.centerRight:Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(!isMe) Padding(
              padding: const EdgeInsets.only(right:8),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(player.profileImage),
              ),
            ),

            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                constraints: const BoxConstraints(
                  maxWidth: 260,
                ),
                decoration: BoxDecoration(
                  color: isMe
                    ?const Color(0xFF8A3CFF)
                    : Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe
                      ?const Radius.circular(16)
                      :const Radius.circular(4),
                    bottomRight: isMe
                      ?const Radius.circular(4)
                      :const Radius.circular(16),
                  ),
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(!isMe)
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    if(!isMe) const SizedBox(height: 4),
                    Text(
                      message,
                      style:TextStyle(
                        color: isMe?Colors.white: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(isMe)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  radius:18,
                  backgroundImage: AssetImage(player.profileImage),
                ),
              ),
          ],
        ),
      ),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {

    final List<Player> explainTargets =
      widget.state.activeCandidates.length == widget.state.players.length
        ? widget.state.players
        : widget. state.activeCandidates;
        
    final state = widget.state;

    return Scaffold(
      appBar: const GradientAppBar(title: ' '),
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
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _getProgressValue(),
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _phase == ExplainPhase.writing
                  ? const Color(0xFF8A3CFF)
                  : const Color.fromARGB(255, 127, 54, 244),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "주제",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.state.topic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            if(!widget.currentPlayer.isLiar)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom:12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "내 제시어",
                      style: TextStyle(
                        fontSize:12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.state.keyword,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A3CFF),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical:8),
                children: explainTargets.map((p){
                  final text = _buildExplanationText(p);

                  return _buildChatBubble(player: p, message: text);
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
              : '투표하러가기',
          onPressed: _phase == ExplainPhase.writing
              ? (isSubmitted ? null : _submit)
              : widget.onSubmit,
        ),
      ),
    );
  }
}

