// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/common_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = "친절한 라마";
  int _level = 12;
  int _selectedImageIndex = 0;
  int _winCount = 45;
  int _loseCount = 30;
  bool _allowInvite = true;
  DateTime _lastNicknameUpdate = DateTime.now().subtract(const Duration(days: 20));

  final List<String> _profileImages = [
    "https://picsum.photos/id/64/200/200",
    "https://picsum.photos/id/65/200/200",
    "https://picsum.photos/id/91/200/200",
    "https://picsum.photos/id/177/200/200",
    "https://picsum.photos/id/237/200/200",
    "https://picsum.photos/id/433/200/200",
  ];

  String get _winRate {
    int total = _winCount + _loseCount;
    if (total == 0) return "0%";
    double rate = (_winCount / total) * 100;
    return "${rate.toStringAsFixed(1)}%";
  }

  bool _canEditNickname() => DateTime.now().difference(_lastNicknameUpdate).inDays >= 14;

  void _showEditNicknameDialog() {
    if (!_canEditNickname()) {
      final daysLeft = 14 - DateTime.now().difference(_lastNicknameUpdate).inDays;
      showSnackBar(context, "닉네임은 2주마다 수정 가능합니다.\n($daysLeft일 남음)");
      return;
    }
    final controller = TextEditingController();
    bool isChecked = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("닉네임 변경"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(hintText: "새 닉네임"),
                          onChanged: (val) => setStateDialog(() => isChecked = false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          if (controller.text.isEmpty) return;
                          setStateDialog(() => isChecked = true);
                          showSnackBar(context, "사용 가능한 닉네임입니다.");
                        },
                        child: const Text("중복확인"),
                      ),
                    ],
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!isChecked) {
                              showSnackBar(context, "중복 확인을 해주세요.");
                              return;
                            }
                            setState(() {
                              _nickname = controller.text;
                              _lastNicknameUpdate = DateTime.now();
                            });
                            Navigator.pop(context);
                            showSnackBar(context, "닉네임이 변경되었습니다.");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text("변경", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey[300]!),
                            foregroundColor: Colors.grey[700],
                          ),
                          child: const Text("취소"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("프로필 이미지 선택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: _profileImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedImageIndex = index);
                        Navigator.pop(context);
                        showSnackBar(context, "프로필 이미지가 변경되었습니다.");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _selectedImageIndex == index ? Theme.of(context).primaryColor : Colors.grey[300]!, width: 3),
                        ),
                        child: CircleAvatar(backgroundImage: NetworkImage(_profileImages[index])),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: const Text("프로필")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _showImagePickerSheet,
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        image: DecorationImage(image: NetworkImage(_profileImages[_selectedImageIndex]), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerSheet,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                  child: Text("Lv.$_level", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(width: 8),
                Text(_nickname, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                IconButton(onPressed: _showEditNicknameDialog, icon: const Icon(Icons.edit, size: 18, color: Colors.grey), tooltip: "닉네임 변경", constraints: const BoxConstraints(), padding: const EdgeInsets.all(8))
              ],
            ),
            const Text("닉네임은 2주마다 수정 가능해요.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildStatCard("승리 횟수", "$_winCount회", Icons.emoji_events_rounded, Colors.amber)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard("승률", _winRate, Icons.pie_chart_rounded, Colors.blue)),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)]),
              child: SwitchListTile(
                value: _allowInvite,
                onChanged: (value) {
                  setState(() => _allowInvite = value);
                  showSnackBar(context, value ? "초대를 받습니다." : "초대를 거부합니다.");
                },
                title: const Text("게임 초대 허용", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("초대를 허용하면 친구들이\n나를 게임에 초대할 수 있어요."),
                activeColor: primaryColor,
                secondary: Icon(_allowInvite ? Icons.notifications_active_rounded : Icons.notifications_off_rounded, color: _allowInvite ? primaryColor : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)]),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}