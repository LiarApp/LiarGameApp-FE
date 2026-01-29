import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 디자인 테마 정의
    final baseColor = const Color(0xFF5E35B1); // Deep Purple
    final lightBgColor = const Color(0xFFF5F5F5);

    return MaterialApp(
      title: 'Modern Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: baseColor,
            brightness: Brightness.light,
            primary: baseColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: lightBgColor,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: baseColor, width: 1.5),
            ),
            prefixIconColor: Colors.grey[600],
            labelStyle: TextStyle(color: Colors.grey[600]),
            floatingLabelStyle: TextStyle(color: baseColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: baseColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              elevation: 2,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: baseColor,
                side: BorderSide(color: baseColor),
                minimumSize: const Size(80, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
          )
      ),
      home: const LoginPage(),
    );
  }
}

// ==========================================
// 1. 로그인 페이지
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

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
                Icon(Icons.rocket_launch_rounded,
                    size: 60, color: Theme.of(context).primaryColor),
                const SizedBox(height: 20),
                Text(
                  "환영합니다!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "서비스 이용을 위해 로그인해 주세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showSnackBar(context, "로그인 시도"),
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _textLinkButton("회원가입", () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()));
                    }),
                    _divider(),
                    _textLinkButton("아이디 찾기", () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const FindIdPage()));
                    }),
                    _divider(),
                    _textLinkButton("비밀번호 찾기", () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const FindPwPage()));
                    }),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("간편 로그인",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      assetPath: "assets/icons/Google__logo.svg",
                      color: const Color(0xFFFFFFFF),
                      onTap: () => _showSnackBar(context, "구글 로그인"),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      assetPath: "assets/icons/KakaoTalk_logo.svg",
                      color: const Color(0xFFFEE500),
                      onTap: () => _showSnackBar(context, "카카오 로그인"),
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      assetPath: "assets/icons/google-play-store-icon.svg",
                      color: const Color(0xFFFFFFFF),
                      onTap: () => _showSnackBar(context, "구글 플레이스토어 로그인"),
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
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn): null,

        ),
      )
    );
  }
}

// ==========================================
// 2. 회원가입 페이지 (기본 정보)
// ==========================================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isAgeVerified = false;
  bool _isIdChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입 (1/2)")),
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

              _buildInputWithActionButton(
                hint: "아이디",
                icon: Icons.person_outline_rounded,
                buttonText: "중복확인",
                onActionPressed: () {
                  setState(() => _isIdChecked = true);
                  _showSnackBar(context, "사용 가능한 아이디입니다.");
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

              _buildInputWithActionButton(
                hint: "휴대폰 번호",
                icon: Icons.phone_android_rounded,
                buttonText: "인증요청",
                inputType: TextInputType.phone,
                onActionPressed: () => _showSnackBar(context, "인증번호가 발송되었습니다."),
              ),
              const SizedBox(height: 16),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '인증번호 입력',
                  prefixIcon: Icon(Icons.mark_email_read_outlined),
                ),
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
                  if (!_isAgeVerified) {
                    _showSnackBar(context, "만 14세 이상만 가입 가능합니다.");
                    return;
                  }
                  if (!_isIdChecked) {
                    _showSnackBar(context, "아이디 중복 확인을 해주세요.");
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

  Widget _buildInputWithActionButton({
    required String hint,
    required IconData icon,
    required String buttonText,
    required VoidCallback onActionPressed,
    TextInputType inputType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: inputType,
            decoration: InputDecoration(
              labelText: hint,
              prefixIcon: Icon(icon),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: onActionPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}

// ==========================================
// 3. 프로필 설정 페이지 (닉네임/사진)
// ==========================================
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nicknameController = TextEditingController();
  bool _isNicknameChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필 설정 (2/2)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "마지막 단계입니다!\n프로필을 꾸며보세요.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Text("닉네임 설정",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임',
                      prefixIcon: Icon(Icons.face),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isNicknameChecked = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    if (_nicknameController.text.isEmpty) {
                      _showSnackBar(context, "닉네임을 입력해주세요.");
                      return;
                    }
                    setState(() {
                      _isNicknameChecked = true;
                    });
                    _showSnackBar(context, "사용 가능한 닉네임입니다.");
                  },
                  child: const Text("중복확인"),
                ),
              ],
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                if (!_isNicknameChecked) {
                  _showSnackBar(context, "닉네임 중복 확인을 해주세요.");
                  return;
                }

                _showSnackBar(context, "회원가입이 완료되었습니다!");

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("가입 완료"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. 아이디 찾기 페이지 (구현됨)
// ==========================================
class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
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

            // 휴대폰 번호 + 전송 버튼
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
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => _showSnackBar(context, "인증번호가 발송되었습니다."),
                  child: const Text("인증요청"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 인증번호 입력
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '인증번호 6자리',
                prefixIcon: Icon(Icons.mark_email_read_outlined),
              ),
            ),

            const Spacer(),

            // 아이디 찾기 버튼
            ElevatedButton(
              onPressed: () {
                if(_phoneController.text.isEmpty || _codeController.text.isEmpty) {
                  _showSnackBar(context, "정보를 모두 입력해주세요.");
                  return;
                }
                // 결과 다이얼로그 띄우기
                _showResultDialog(context, "회원님의 아이디는\n[ test_id ] 입니다.");
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

// ==========================================
// 5. 비밀번호 찾기 페이지 (구현됨)
// ==========================================
class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  State<FindPwPage> createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> {
  final _idController = TextEditingController();
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

            // 휴대폰 번호 + 전송
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
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => _showSnackBar(context, "인증번호가 발송되었습니다."),
                  child: const Text("인증요청"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 인증번호 입력
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '인증번호 6자리',
                prefixIcon: Icon(Icons.mark_email_read_outlined),
              ),
            ),

            const Spacer(),

            // 비밀번호 찾기 버튼
            ElevatedButton(
              onPressed: () {
                if(_idController.text.isEmpty || _phoneController.text.isEmpty || _codeController.text.isEmpty) {
                  _showSnackBar(context, "정보를 모두 입력해주세요.");
                  return;
                }
                // 결과 다이얼로그 띄우기
                _showResultDialog(context, "회원님의 비밀번호는\n[ pw1234!@ ] 입니다.");
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

// 공통 스낵바
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ),
  );
}

// 결과 알림창 (아이디/비번 보여주기용)
void _showResultDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Color(0xFF5E35B1), size: 48),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    },
  );
}