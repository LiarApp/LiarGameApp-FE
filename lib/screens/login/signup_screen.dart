// lib/screens/login/signup_screen.dart
import 'package:flutter/material.dart';
import '../../utils/common_utils.dart';
import 'profile_setup_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isAgeVerified = false;
  bool _isIdChecked = false;

  bool _isCodeSent = false;
  bool _isPhoneVerified = false;
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("기본 정보 입력",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // 아이디 입력
              _buildInputWithActionButton(
                hint: "아이디",
                icon: Icons.person_outline_rounded,
                buttonText: "중복확인",
                onActionPressed: () {
                  setState(() => _isIdChecked = true);
                  showSnackBar(context, "사용 가능한 아이디입니다.");
                },
                onChanged: (value) => _isIdChecked = false,
              ),
              const SizedBox(height: 16),

              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 30),

              const Text("본인 인증",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // [수정 1] 휴대폰 번호 입력 + 버튼 높이 맞춤
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
                    height: 56, // 입력창 높이와 동일하게 강제 설정
                    width: 90,  // 버튼 너비 고정 (선택사항)
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
                        showSnackBar(context, "인증번호가 발송되었습니다.");
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // 입력창 테두리와 동일하게
                        ),
                        padding: EdgeInsets.zero, // 텍스트 중앙 정렬을 위해 여백 제거
                      ),
                      child: Text(_isCodeSent ? "재전송" : "인증요청"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // [수정 2] 인증번호 입력 + 확인 버튼 높이 맞춤
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
                      height: 56, // 높이 맞춤
                      width: 90,  // 너비 맞춤
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

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  value: _isAgeVerified,
                  onChanged: (value) => setState(() => _isAgeVerified = value!),
                  title: const Text("만 14세 이상입니다. (필수)", style: TextStyle(fontSize: 15)),
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (!_isIdChecked) {
                    showSnackBar(context, "아이디 중복 확인을 해주세요.");
                    return;
                  }
                  if (!_isPhoneVerified) {
                    showSnackBar(context, "휴대폰 인증을 완료해주세요.");
                    return;
                  }
                  if (!_isAgeVerified) {
                    showSnackBar(context, "만 14세 이상만 가입 가능합니다.");
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileSetupPage())
                    );
                  }
                },
                child: const Text("다음"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper 위젯도 높이 맞춤 적용
  Widget _buildInputWithActionButton({
    required String hint,
    required IconData icon,
    required String buttonText,
    required VoidCallback onActionPressed,
    Function(String)? onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: hint,
              prefixIcon: Icon(icon),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56, // 높이 고정
          width: 90,
          child: OutlinedButton(
            onPressed: onActionPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}