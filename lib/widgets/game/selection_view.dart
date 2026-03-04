//selection_view.dart
// 임시화면

import 'package:flutter/material.dart';
import 'package:liargame/screens/game/game_state.dart';
import '../../screens/game/game_screen.dart';
// import '../../screens/game/game_mode.dart';

class SelectionView extends StatefulWidget{
  const SelectionView ({super.key});

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView>{

  int selectedVoteTime = 30;
  int selectedExplainTime = 30;
  GameMode selectedMode = GameMode.normal;

  Widget _buildOptionButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected? const Color(0xFF8A3CFF):Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child:Text(
          text,
          style: TextStyle(
            color: selected? Colors.white:Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  void _startGame(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          voteTime: selectedVoteTime,
          explainTime: selectedExplainTime,
          mode: selectedMode,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("게임설정")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("투표시간", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildOptionButton(
                  text:"30초",
                  selected: selectedVoteTime == 30,
                  onTap:() => setState(() => selectedVoteTime = 30)
                ),
                _buildOptionButton(
                  text: "60초", 
                  selected: selectedVoteTime == 60, 
                  onTap: () => setState(() => selectedVoteTime = 60)
                ),
                _buildOptionButton(
                  text: "90초", 
                  selected: selectedVoteTime == 90, 
                  onTap: () => setState(() => selectedVoteTime = 90)
                ),
              ],
            ),

            const SizedBox(height:32),

            const Text("답변 시간", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildOptionButton(
                  text: "30초", 
                  selected: selectedExplainTime == 30, 
                  onTap: () => setState(() => selectedExplainTime = 30)
                ),
                _buildOptionButton(
                  text: "60초", 
                  selected: selectedExplainTime == 60, 
                  onTap: () => setState(() => selectedExplainTime = 60)
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text("게임 모드", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildOptionButton(
                  text: "기본 모드", 
                  selected: selectedMode == GameMode.normal, 
                  onTap: () => setState(() => selectedMode = GameMode.normal),
                ),
                _buildOptionButton(
                  text: "바보 모드", 
                  selected: selectedMode == GameMode.fool,
                  onTap: () => setState(() => selectedMode = GameMode.fool),
                ),
                _buildOptionButton(
                  text: "스파이 모드", 
                  selected: selectedMode == GameMode.spy, 
                  onTap: () => setState(() => selectedMode = GameMode.spy)
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text("게임 시작"),
              ),
            )
          ],
        ),
      ),
    );
  }
}