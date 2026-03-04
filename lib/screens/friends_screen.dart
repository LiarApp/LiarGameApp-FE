// lib/screens/friends_screen.dart
import 'package:flutter/material.dart';
import '../utils/common_utils.dart'; // 스낵바 사용

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

// 친구 데이터 모델
class Friend {
  final String nickname;
  final String status; // 'online', 'playing', 'offline'
  final String lastSeen; // 오프라인일 때만 사용
  final String avatarUrl;

  Friend({
    required this.nickname,
    required this.status,
    this.lastSeen = "",
    required this.avatarUrl,
  });
}

class _FriendsScreenState extends State<FriendsScreen> {
  // --- [Mock Data] ---
  final List<Friend> _friends = [
    Friend(nickname: "게임왕", status: "playing", avatarUrl: "https://picsum.photos/id/11/200/200"),
    Friend(nickname: "즐겜유저", status: "online", avatarUrl: "https://picsum.photos/id/12/200/200"),
    Friend(nickname: "초보에요", status: "offline", lastSeen: "2시간 전", avatarUrl: "https://picsum.photos/id/13/200/200"),
    Friend(nickname: "스피드레이서", status: "playing", avatarUrl: "https://picsum.photos/id/14/200/200"),
  ];

  final List<Friend> _recentPlayers = [
    Friend(nickname: "아무개1", status: "offline", lastSeen: "5분 전", avatarUrl: "https://picsum.photos/id/20/200/200"),
    Friend(nickname: "고수등장", status: "online", avatarUrl: "https://picsum.photos/id/21/200/200"),
  ];

  final int _maxFriends = 50;

  // --- [친구 추가 다이얼로그] ---
  void _showAddFriendDialog() {
    if (_friends.length >= _maxFriends) {
      showSnackBar(context, "친구는 최대 $_maxFriends명까지만 등록 가능합니다.");
      return;
    }

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("친구 추가", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // [수정 1] 텍스트 좌측 정렬
            children: [
              const Text("친구의 닉네임을 입력해주세요.", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "닉네임 검색",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          // [수정 2] 버튼 배치 (추가 2 : 취소 1)
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                // 왼쪽 2/3: 추가 버튼
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isEmpty) return;
                        // 가짜 친구 추가 로직
                        setState(() {
                          _friends.add(Friend(
                            nickname: controller.text,
                            status: "offline",
                            lastSeen: "방금 전",
                            avatarUrl: "https://picsum.photos/200/300",
                          ));
                        });
                        Navigator.pop(context);
                        showSnackBar(context, "${controller.text}님을 친구로 추가했습니다.");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("추가", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 오른쪽 1/3: 취소 버튼
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
  }

  // --- [친구 삭제 다이얼로그] ---
  void _deleteFriend(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("친구 삭제", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 좌측 정렬
            children: [
              Text("'${_friends[index].nickname}'님을\n친구 목록에서 삭제하시겠습니까?", style: const TextStyle(fontSize: 15)),
            ],
          ),
          // [수정 3] 버튼 배치 (삭제 2 : 취소 1)
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                // 왼쪽 2/3: 삭제 버튼 (빨간색)
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _friends.removeAt(index);
                        });
                        Navigator.pop(context);
                        showSnackBar(context, "친구가 삭제되었습니다.");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("삭제", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 오른쪽 1/3: 취소 버튼
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("친구 관리 (${_friends.length}/$_maxFriends)"),
        actions: [
          IconButton(
            onPressed: _showAddFriendDialog,
            icon: const Icon(Icons.person_add),
            tooltip: "친구 추가",
          ),
        ],
      ),
      body: ListView(
        children: [
          // 1. 최근 플레이한 유저 섹션
          if (_recentPlayers.isNotEmpty) ...[
            _buildSectionHeader("최근 같이 플레이한 유저"),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _recentPlayers.length,
                separatorBuilder: (c, i) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final player = _recentPlayers[index];
                  return Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(player.avatarUrl),
                          ),
                          if (player.status != 'offline')
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(player.nickname, style: const TextStyle(fontSize: 12)),
                      TextButton(
                        onPressed: () {
                          showSnackBar(context, "${player.nickname}님에게 친구 요청을 보냈습니다.");
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 24),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("친구신청", style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)),
          ],

          // 2. 내 친구 목록 섹션
          _buildSectionHeader("내 친구 목록"),
          if (_friends.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: Text("등록된 친구가 없습니다.\n친구를 추가해보세요!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(friend.avatarUrl),
                      ),
                      if (friend.status != 'offline')
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: friend.status == 'playing' ? Colors.orange : Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(friend.nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    _getStatusText(friend),
                    style: TextStyle(
                      color: _getStatusColor(friend),
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 게임 참여 버튼
                      if (friend.status == 'playing')
                        ElevatedButton(
                          onPressed: () {
                            showSnackBar(context, "${friend.nickname}님의 방에 입장합니다...");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(60, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text("참여", style: TextStyle(fontSize: 12)),
                        ),

                      const SizedBox(width: 8),

                      // 삭제 메뉴
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') _deleteFriend(index);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('친구 삭제', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _getStatusText(Friend friend) {
    switch (friend.status) {
      case 'playing':
        return "게임 중";
      case 'online':
        return "온라인";
      default:
        return "미접속 · ${friend.lastSeen}";
    }
  }

  Color _getStatusColor(Friend friend) {
    switch (friend.status) {
      case 'playing':
        return Colors.orange;
      case 'online':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}