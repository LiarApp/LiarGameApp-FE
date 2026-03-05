// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../managers/friends_screen.dart';
import '../managers/friend_data_manager.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = FriendDataManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text("메인 화면"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ★ ListenableBuilder로 감싸서 데이터 변경 시 즉시 리빌드
            ListenableBuilder(
              listenable: dataManager,
              builder: (context, child) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                  accountName: const Text("친절한 라마", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  // 친구 수가 변경되면 이 텍스트가 자동으로 바뀝니다.
                  accountEmail: Text("친구 수: ${dataManager.friends.length} / ${dataManager.maxFriends}"),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: NetworkImage("https://picsum.photos/id/64/200/200"),
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('내 프로필'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_rounded),
              title: const Text('친구 관리'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('설정'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            const Divider(),
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
            const Text("로그인 성공!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("여기가 앱의 메인 화면입니다."),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextButton.icon(
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