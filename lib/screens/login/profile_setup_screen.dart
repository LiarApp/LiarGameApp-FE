// lib/screens/login/profile_setup_screen.dart
import 'package:flutter/material.dart';
import '../../utils/common_utils.dart';
import '../home_screen.dart'; // 메인 화면으로 이동하기 위해

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nicknameController = TextEditingController();
  bool _isNicknameChecked = false;

  // 선택된 이미지 인덱스 (기본값 0번)
  int _selectedProfileIndex = 0;

  // 프로필 이미지 목록 (테스트용 URL)
  // 나중에 실제 에셋이 준비되면 'assets/images/profile1.png' 등으로 바꾸세요.
  final List<String> _profileImages = [
    "https://picsum.photos/id/64/200/200", // 1번 (여자)
    "https://picsum.photos/id/65/200/200", // 2번 (여자)
    "https://picsum.photos/id/91/200/200", // 3번 (남자)
    "https://picsum.photos/id/177/200/200", // 4번 (풍경/기타)
    "https://picsum.photos/id/237/200/200", // 5번 (강아지)
    "https://picsum.photos/id/433/200/200", // 6번 (곰)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("프로필 설정")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              "환영합니다!\n마음에 드는 프로필 사진을 골라보세요.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // [1. 대형 선택된 이미지 표시 영역]
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(_profileImages[_selectedProfileIndex]),
                        fit: BoxFit.cover,
                      ),
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
                      child: const Icon(Icons.check, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // [2. 6개 이미지 선택 그리드]
            const Text("기본 이미지 선택", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true, // 스크롤 뷰 안에 있으므로 필수
              physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
              itemCount: _profileImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // 정사각형
              ),
              itemBuilder: (context, index) {
                final isSelected = _selectedProfileIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProfileIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Theme.of(context).primaryColor, width: 3) // 선택되면 테두리 강조
                          : Border.all(color: Colors.transparent, width: 3),
                    ),
                    padding: const EdgeInsets.all(2), // 테두리와 이미지 사이 간격
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_profileImages[index]),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // [3. 닉네임 설정]
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(
                      labelText: '닉네임',
                      prefixIcon: Icon(Icons.face),
                    ),
                    onChanged: (value) => setState(() => _isNicknameChecked = false),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    if (_nicknameController.text.isEmpty) return;
                    setState(() => _isNicknameChecked = true);
                    showSnackBar(context, "사용 가능한 닉네임입니다.");
                  },
                  child: const Text("중복확인"),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // [4. 완료 버튼]
            ElevatedButton(
              onPressed: () {
                if (!_isNicknameChecked) {
                  showSnackBar(context, "닉네임 중복 확인을 해주세요.");
                  return;
                }

                // 나중에 여기서 서버로 _selectedProfileIndex(이미지 번호)와 닉네임을 전송하면 됩니다.
                showSnackBar(context, "가입이 완료되었습니다!");

                // 메인 화면으로 이동 (로그인, 가입 페이지 기록 삭제)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("시작하기"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}