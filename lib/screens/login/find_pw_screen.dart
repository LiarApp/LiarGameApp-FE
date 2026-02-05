// lib/screens/login/find_pw_screen.dart
import 'package:flutter/material.dart';
import '../../utils/common_utils.dart'; // 유틸리티 import

class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  State<FindPwPage> createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> {
  final _idController = TextEditingController();

  // 인증 상태 관리 변수
  bool _isCodeSent = false;
  bool _isPhoneVerified = false;

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("비밀번호 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "비밀번호를 찾고자 하는\n아이디와 휴대폰 번호를 입력해주세요.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 아이디 입력
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: '아이디',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),

            // 1. 휴대폰 번호 입력 + 인증요청 버튼
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '휴대폰 번호',
                      prefixIcon: Icon(Icons.phone_android_rounded),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _isCodeSent = false;
                        _isPhoneVerified = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56,
                  width: 90,
                  child: OutlinedButton(
                    onPressed: _isPhoneVerified
                        ? null
                        : () {
                      if (_phoneController.text.isEmpty) {
                        showSnackBar(context, "번호를 입력해주세요.");
                        return;
                      }
                      setState(() {
                        _isCodeSent = true;
                        _isPhoneVerified = false;
                      });
                      showSnackBar(context, "인증번호가 발송되었습니다. (123456)");
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(_isCodeSent ? "재전송" : "인증요청"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. 인증번호 입력 + 확인 버튼
            if (_isCodeSent)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      enabled: !_isPhoneVerified,
                      decoration: InputDecoration(
                        labelText: '인증번호 입력',
                        prefixIcon: const Icon(Icons.mark_email_read_outlined),
                        focusedBorder: _isPhoneVerified
                            ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.green),
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    width: 90,
                    child: OutlinedButton(
                      onPressed: _isPhoneVerified
                          ? null
                          : () {
                        if (_codeController.text == "123456") {
                          setState(() => _isPhoneVerified = true);
                          showSnackBar(context, "인증이 완료되었습니다.");
                        } else {
                          showSnackBar(context, "인증번호가 일치하지 않습니다.");
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _isPhoneVerified ? Colors.green : null,
                        side: _isPhoneVerified ? const BorderSide(color: Colors.green) : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(_isPhoneVerified ? "완료" : "확인"),
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // 3. 비밀번호 찾기 버튼
            ElevatedButton(
              onPressed: () {
                if (_idController.text.isEmpty) {
                  showSnackBar(context, "아이디를 입력해주세요.");
                  return;
                }
                if (!_isPhoneVerified) {
                  showSnackBar(context, "휴대폰 인증을 완료해주세요.");
                  return;
                }

                showResultDialog(context, "회원님의 비밀번호는\n[ pw1234!@ ] 입니다.");
              },
              child: const Text("비밀번호 찾기"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}