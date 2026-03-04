// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'friends_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메인 화면"),
        centerTitle: true,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
        // actions를 비워두면 endDrawer가 있을 때 자동으로 '줄 3개' 아이콘이 생깁니다.
      ),

      // ★★★ 우측 드로어 (햄버거 메뉴) 추가 ★★★
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 드로어 헤더 (디자인용)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName: const Text("플러터고수", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: const Text("Lv.12"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage("https://picsum.photos/id/64/200/200"),
                backgroundColor: Colors.white,
              ),
            ),

            // 1. 프로필 이동 메뉴
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('내 프로필'),
              onTap: () {
                Navigator.pop(context); // 드로어 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),

            // 2. 친구 관리 메뉴 추가
            ListTile(
              leading: const Icon(Icons.people_alt_rounded),
              title: const Text('친구 관리'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsScreen()),
                );
              },
            ),

            // 3. 설정 이동 메뉴
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('설정'),
              onTap: () {
                Navigator.pop(context); // 드로어 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),

            const Divider(), // 구분선

            // 4. 로그아웃 메뉴
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text('로그아웃', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
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

            const SizedBox(height: 20),

            // 처음으로(로그아웃)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextButton.icon( // 스타일 조금 변경
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text("로그아웃"),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}