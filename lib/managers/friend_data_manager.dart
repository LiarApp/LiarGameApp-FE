import 'package:flutter/material.dart';

// [Friend 모델]
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

// [데이터 매니저]
class FriendDataManager extends ChangeNotifier {
  static final FriendDataManager _instance = FriendDataManager._internal();
  factory FriendDataManager() => _instance;
  FriendDataManager._internal();

  // --- [Data] ---

  // 1. 내 친구 목록
  final List<Friend> friends = [
    Friend(nickname: "게임왕", status: "playing", avatarUrl: "https://picsum.photos/id/11/200/200"),
    Friend(nickname: "즐겜유저", status: "online", avatarUrl: "https://picsum.photos/id/12/200/200"),
    Friend(nickname: "초보에요", status: "offline", lastSeen: "2시간 전", avatarUrl: "https://picsum.photos/id/13/200/200"),
    Friend(nickname: "스피드레이서", status: "playing", avatarUrl: "https://picsum.photos/id/14/200/200"),
  ];

  // 2. 최근 플레이 유저
  final List<Friend> recentPlayers = [
    Friend(nickname: "아무개1", status: "offline", lastSeen: "5분 전", avatarUrl: "https://picsum.photos/id/20/200/200"),
    Friend(nickname: "고수등장", status: "online", avatarUrl: "https://picsum.photos/id/21/200/200"),
  ];

  // 3. [NEW] 나에게 온 친구 요청 (확인용 가짜 데이터)
  final List<Friend> receivedRequests = [
    Friend(nickname: "친해지고싶어", status: "online", avatarUrl: "https://picsum.photos/id/40/200/200"),
    Friend(nickname: "버스기사", status: "offline", lastSeen: "1일 전", avatarUrl: "https://picsum.photos/id/41/200/200"),
  ];

  // 4. 내가 보낸 요청 대기 목록 (닉네임만 저장)
  final Set<String> pendingRequests = {};

  final int maxFriends = 50;

  // --- [Actions] ---

  // 친구 직접 추가 (검색 등으로)
  void addFriend(String nickname) {
    friends.add(Friend(
      nickname: nickname,
      status: "offline",
      lastSeen: "방금 전",
      avatarUrl: "https://picsum.photos/200/300",
    ));
    pendingRequests.remove(nickname);
    notifyListeners();
  }

  // 친구 삭제
  void removeFriend(int index) {
    if (index >= 0 && index < friends.length) {
      friends.removeAt(index);
      notifyListeners();
    }
  }

  // 내가 친구 요청 보내기
  void sendRequest(String nickname) {
    pendingRequests.add(nickname);
    notifyListeners();
  }

  // 내가 보낸 요청인지 확인
  bool isPending(String nickname) {
    return pendingRequests.contains(nickname);
  }

  // --- [NEW] 받은 요청 처리 기능 ---

  // 요청 수락
  void acceptRequest(Friend requestSender) {
    // 친구 목록에 추가
    friends.insert(0, requestSender); // 목록 맨 앞에 추가
    // 요청 목록에서 제거
    receivedRequests.remove(requestSender);
    notifyListeners();
  }

  // 요청 거절
  void rejectRequest(Friend requestSender) {
    receivedRequests.remove(requestSender);
    notifyListeners();
  }
}