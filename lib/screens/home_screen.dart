// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'login/login_screen.dart'; // 로그인 페이지로 돌아가기 위해 필요

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메인 화면"),
        centerTitle: true,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_rounded, size: 100, color: Color(0xFF5E35B1)),
            const SizedBox(height: 20),
            const Text(
              "로그인 성공!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("여기가 앱의 메인 화면입니다."),
            const SizedBox(height: 50),

            // [추가된 기능] 처음으로 돌아가기 (임시 로그아웃)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ElevatedButton.icon(
                onPressed: () {
                  // 이전의 모든 라우트(화면 기록)를 지우고 로그인 페이지로 이동
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("처음으로 (로그아웃)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}