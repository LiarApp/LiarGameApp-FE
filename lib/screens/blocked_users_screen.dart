// lib/screens/blocked_users_screen.dart
import 'package:flutter/material.dart';
import '../managers/friend_data_manager.dart';
import '../utils/common_utils.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = FriendDataManager();

    return Scaffold(
      appBar: AppBar(
        // 타이틀의 숫자만 다시 그리도록 감싸기
        title: ListenableBuilder(
          listenable: dataManager,
          builder: (context, _) => Text("차단 관리 (${dataManager.blockedUsers.length})"),
        ),
      ),
      // 바디 영역만 다시 그리도록 감싸기
      body: ListenableBuilder(
        listenable: dataManager,
        builder: (context, child) {
          if (dataManager.blockedUsers.isEmpty) {
            return const Center(
              child: Text("차단한 유저가 없습니다.", style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: dataManager.blockedUsers.length,
            itemBuilder: (context, index) {
              final blockedUser = dataManager.blockedUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(blockedUser.avatarUrl),
                ),
                title: Text(blockedUser.nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("차단됨", style: TextStyle(color: Colors.redAccent, fontSize: 12)),

                // 💡 에러 해결: trailing 위젯의 크기를 SizedBox로 제한했습니다.
                trailing: SizedBox(
                  width: 90,  // 버튼 너비 고정
                  height: 36, // 버튼 높이 고정
                  child: ElevatedButton(
                    onPressed: () {
                      dataManager.unblockUser(blockedUser);
                      showSnackBar(context, "${blockedUser.nickname}님을 차단 해제했습니다.");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.zero, // 버튼 안쪽 여백을 없애서 텍스트가 잘리지 않게 함
                    ),
                    child: const Text("차단 해제", style: TextStyle(fontSize: 13)),
                  ),
                ),

              );
            },
          );
        },
      ),
    );
  }
}