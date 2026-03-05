import 'package:flutter/material.dart';
import '../utils/common_utils.dart';
import '../managers/friend_data_manager.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _dataManager = FriendDataManager();

  // --- [친구 추가 다이얼로그] ---
  void _showAddFriendDialog() {
    if (_dataManager.friends.length >= _dataManager.maxFriends) {
      showSnackBar(context, "친구는 최대 ${_dataManager.maxFriends}명까지만 등록 가능합니다.");
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        if (controller.text.isEmpty) return;
                        _dataManager.addFriend(controller.text);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "'${_dataManager.friends[index].nickname}'님을\n친구 목록에서 삭제하시겠습니까?",
                style: const TextStyle(fontSize: 15),
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
                        _dataManager.removeFriend(index);
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
    // ListenableBuilder: 데이터 변경 시 자동 갱신
    return ListenableBuilder(
      listenable: _dataManager,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("친구 관리 (${_dataManager.friends.length}/${_dataManager.maxFriends})"),
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

              // ★ [NEW] 0. 받은 친구 요청 섹션 (요청이 있을 때만 표시) ★
              if (_dataManager.receivedRequests.isNotEmpty) ...[
                _buildSectionHeader("받은 친구 요청 (${_dataManager.receivedRequests.length})"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dataManager.receivedRequests.length,
                  itemBuilder: (context, index) {
                    final requester = _dataManager.receivedRequests[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(requester.avatarUrl),
                      ),
                      title: Text(requester.nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("친구 요청을 보냈습니다.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 수락 버튼
                          ElevatedButton(
                            onPressed: () {
                              _dataManager.acceptRequest(requester);
                              showSnackBar(context, "${requester.nickname}님과 친구가 되었습니다!");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(60, 32),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text("수락", style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          // 거절 버튼
                          OutlinedButton(
                            onPressed: () {
                              _dataManager.rejectRequest(requester);
                              showSnackBar(context, "친구 요청을 거절했습니다.");
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(60, 32),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: const Text("거절", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 30, thickness: 8, color: Color(0xFFF5F5F5)),
              ],

              // 1. 최근 플레이한 유저 섹션
              if (_dataManager.recentPlayers.isNotEmpty) ...[
                _buildSectionHeader("최근 같이 플레이한 유저"),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _dataManager.recentPlayers.length,
                    separatorBuilder: (c, i) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final player = _dataManager.recentPlayers[index];
                      final isPending = _dataManager.isPending(player.nickname);
                      final isAlreadyFriend = _dataManager.friends.any((f) => f.nickname == player.nickname);

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

                          if (isAlreadyFriend)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text("친구", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            )
                          else
                            TextButton(
                              onPressed: isPending ? null : () {
                                _dataManager.sendRequest(player.nickname);
                                showSnackBar(context, "${player.nickname}님에게 친구 요청을 보냈습니다.");
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 24),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                foregroundColor: isPending ? Colors.grey : Colors.blue,
                              ),
                              child: Text(
                                  isPending ? "요청중" : "친구신청",
                                  style: const TextStyle(fontSize: 11)
                              ),
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
              if (_dataManager.friends.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                      child: Text(
                          "등록된 친구가 없습니다.\n친구를 추가해보세요!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey)
                      )
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dataManager.friends.length,
                  itemBuilder: (context, index) {
                    final friend = _dataManager.friends[index];
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
      },
    );
  }

  // --- [Helper Methods] ---
  String _getStatusText(Friend friend) {
    switch (friend.status) {
      case 'playing': return "게임 중";
      case 'online': return "온라인";
      default: return "미접속 · ${friend.lastSeen}";
    }
  }

  Color _getStatusColor(Friend friend) {
    switch (friend.status) {
      case 'playing': return Colors.orange;
      case 'online': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}