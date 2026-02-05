// lib/screens/login/login_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../utils/common_utils.dart';
import 'signup_screen.dart';
import 'profile_setup_screen.dart'; // 프로필 설정 페이지 import
import 'find_id_screen.dart';
import 'find_pw_screen.dart';
import '../home_screen.dart'; // 메인 화면 import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  // [핵심 로직] 로그인/가입 성공 후 처리 함수
  // isNewUser: true면 프로필 설정으로, false면 바로 홈으로
  void _checkNewUserAndNavigate(bool isNewUser) {
    if (isNewUser) {
      showSnackBar(context, "신규 가입을 환영합니다! 프로필을 설정해주세요.");
      // 프로필 설정 페이지로 이동 (뒤로가기 시 로그인 페이지 안 나오게 pushReplacement 권장)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
      );
    } else {
      showSnackBar(context, "로그인되었습니다.");
      // 메인 홈으로 이동 (로그인 페이지 없애고 이동)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  // 소셜 로그인 처리
  Future<void> _handleSocialLogin(String provider) async {
    // ... (기존 URL 로직 생략, 너무 길어서) ...
    // 실제로는 백엔드 통신 후 토큰과 'isNewUser' 값을 받아옵니다.

    // [시뮬레이션] 1초 후 로그인 성공 처리
    showSnackBar(context, "$provider 로그인 페이지로 이동합니다...");
    await Future.delayed(const Duration(seconds: 1));

    // ★ 테스트를 위해 무조건 '신규 유저(true)'라고 가정하고 진행합니다.
    // (실제 앱에서는 백엔드가 준 값인 true/false를 넣어야 합니다)
    bool mockIsNewUser = true;

    _checkNewUserAndNavigate(mockIsNewUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Icon(Icons.rocket_launch_rounded, size: 60, color: Theme.of(context).primaryColor),
                // ... (제목 텍스트 등 기존 UI 동일) ...
                const SizedBox(height: 20),
                Text(
                  "환영합니다!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60),

                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: '아이디', prefixIcon: Icon(Icons.person_outline_rounded)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '비밀번호', prefixIcon: Icon(Icons.lock_outline_rounded)),
                ),
                const SizedBox(height: 24),

                // [일반 로그인 버튼]
                ElevatedButton(
                  onPressed: () {
                    // 일반 로그인은 '기존 유저'라고 가정 (false)
                    // 만약 테스트 아이디가 'new'라면 신규 유저로 처리해볼 수도 있음
                    bool isNew = _idController.text == 'new';
                    _checkNewUserAndNavigate(isNew);
                  },
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // [회원가입 버튼 수정됨]
                    _textLinkButton("회원가입", () async {
                      // 1. 회원가입 페이지로 이동하고 결과를 기다림
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage())
                      );

                      // 2. 만약 회원가입을 마치고 돌아왔다면(result == true)
                      if (result == true) {
                        // 3. 신규 유저로 처리 -> 프로필 설정으로 이동
                        _checkNewUserAndNavigate(true);
                      }
                    }),
                    _divider(),
                    _textLinkButton("아이디 찾기", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindIdPage()));
                    }),
                    _divider(),
                    _textLinkButton("비밀번호 찾기", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindPwPage()));
                    }),
                  ],
                ),
                // ... (간편 로그인 소셜 버튼 UI 코드들 기존 그대로 유지) ...
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      assetPath: "assets/icons/Google__logo.svg",
                      color: const Color(0xFFFFFFFF),
                      onTap: () => _handleSocialLogin('google'),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      assetPath: "assets/icons/KakaoTalk_logo.svg",
                      color: const Color(0xFFFEE500),
                      onTap: () => _handleSocialLogin('kakao'),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      assetPath: "assets/icons/google-play-store-icon.svg",
                      color: const Color(0xFFFFFFFF),
                      onTap: () => _handleSocialLogin('playstore'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ... (기존 _textLinkButton, _divider, _socialButton 함수들 유지) ...
  Widget _textLinkButton(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(text),
    );
  }

  Widget _divider() {
    return Container(
      height: 12,
      width: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _socialButton({
    required String assetPath,
    required Color color,
    required VoidCallback onTap,
    bool isWhiteIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: isWhiteIcon
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}