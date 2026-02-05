// lib/screens/login/find_id_screen.dart
import 'package:flutter/material.dart';
import '../../utils/common_utils.dart'; // 유틸리티 import

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  // 인증 상태 관리 변수
  bool _isCodeSent = false;
  bool _isPhoneVerified = false;

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("아이디 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "가입 시 등록한 휴대폰 번호를 입력해주세요.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

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
                      // 번호 수정 시 인증 상태 초기화
                      setState(() {
                        _isCodeSent = false;
                        _isPhoneVerified = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 56, // 버튼 높이 고정
                  width: 90,
                  child: OutlinedButton(
                    onPressed: _isPhoneVerified
                        ? null // 인증 완료되면 비활성화
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

            // 2. 인증번호 입력 + 확인 버튼 (발송된 경우에만 표시)
            if (_isCodeSent)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      enabled: !_isPhoneVerified, // 인증 완료되면 수정 불가
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

            // 3. 아이디 찾기 버튼
            ElevatedButton(
              onPressed: () {
                if (_phoneController.text.isEmpty) {
                  showSnackBar(context, "휴대폰 번호를 입력해주세요.");
                  return;
                }
                // 휴대폰 인증이 완료되었는지 확인
                if (!_isPhoneVerified) {
                  showSnackBar(context, "휴대폰 인증을 완료해주세요.");
                  return;
                }

                // 결과 다이얼로그 띄우기
                showResultDialog(context, "회원님의 아이디는\n[ test_id ] 입니다.");
              },
              child: const Text("아이디 찾기"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}