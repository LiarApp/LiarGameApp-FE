import 'package:flutter/material.dart';

// [Friend 모델]
class Friend {
  final String nickname;
  final String status;
  final String lastSeen;
  final String avatarUrl;

  Friend({
    required this.nickname,
    required this.status,
    this.lastSeen = "",
    required this.avatarUrl,
  });
}

// [신고 데이터 모델]
class Report {
  final String targetNickname;
  final String reason;
  final DateTime date;

  Report({
    required this.targetNickname,
    required this.reason,
    required this.date,
  });
}

class FriendDataManager extends ChangeNotifier {
  static final FriendDataManager _instance = FriendDataManager._internal();
  factory FriendDataManager() => _instance;
  FriendDataManager._internal();

  // --- [기존 데이터] ---
  final List<Friend> friends = [
    Friend(nickname: "게임왕", status: "playing", avatarUrl: "https://picsum.photos/id/11/200/200"),
    Friend(nickname: "즐겜유저", status: "online", avatarUrl: "https://picsum.photos/id/12/200/200"),
  ];
  final List<Friend> recentPlayers = [
    Friend(nickname: "아무개1", status: "offline", lastSeen: "5분 전", avatarUrl: "https://picsum.photos/id/20/200/200"),
  ];
  final List<Friend> receivedRequests = [];
  final Set<String> pendingRequests = {};
  final int maxFriends = 50;

  // --- [NEW: 차단 및 신고 데이터] ---
  final List<Friend> blockedUsers = [
    Friend(nickname: "욕설유저", status: "offline", avatarUrl: "https://picsum.photos/id/100/200/200"),
  ];

  final List<Report> reports = [
    Report(targetNickname: "비매너유저", reason: "게임 중 심한 욕설", date: DateTime.now().subtract(const Duration(days: 1))),
  ];

  // --- [기존 Actions 생략...] ---
  void addFriend(String nickname) { /* ... */ }
  void removeFriend(int index) { /* ... */ }
  void sendRequest(String nickname) { /* ... */ }
  bool isPending(String nickname) => pendingRequests.contains(nickname);
  void acceptRequest(Friend requestSender) { /* ... */ }
  void rejectRequest(Friend requestSender) { /* ... */ }

  // --- [NEW: 차단 기능] ---
  void blockUser(Friend user) {
    // 1. 친구 목록에 있다면 삭제
    friends.removeWhere((f) => f.nickname == user.nickname);
    // 2. 대기/요청 목록에서도 삭제
    receivedRequests.removeWhere((f) => f.nickname == user.nickname);
    pendingRequests.remove(user.nickname);
    // 3. 차단 목록에 추가 (중복 방지)
    if (!blockedUsers.any((f) => f.nickname == user.nickname)) {
      blockedUsers.add(user);
    }
    notifyListeners();
  }

  void unblockUser(Friend user) {
    blockedUsers.remove(user);
    notifyListeners();
  }

  // --- [NEW: 신고 기능] ---
  void reportUser(String nickname, String reason) {
    reports.add(Report(
      targetNickname: nickname,
      reason: reason,
      date: DateTime.now(),
    ));
    notifyListeners();
  }

  void cancelReport(Report report) {
    reports.remove(report);
    notifyListeners();
  }
}