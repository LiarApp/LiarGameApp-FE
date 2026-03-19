// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import '../managers/friend_data_manager.dart';
import '../utils/common_utils.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = FriendDataManager();

    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: dataManager,
          builder: (context, _) {
            final count = dataManager.reports?.length ?? 0;
            return Text("신고 내역 ($count)");
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: dataManager,
        builder: (context, child) {
          final reportsList = dataManager.reports ?? [];

          if (reportsList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.report_off, size: 60, color: Colors.black12),
                  SizedBox(height: 16),
                  Text("신고 내역이 없습니다.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reportsList.length,
            itemBuilder: (context, index) {
              final report = reportsList[index];

              // 날짜 파싱 중 에러를 방지하기 위한 안전한 처리
              String dateStr = "날짜 미상";
              if (report.date != null) {
                dateStr = "${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}";
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "신고 대상: ${report.targetNickname ?? '알 수 없음'}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("사유: ${report.reason ?? '사유 없음'}", style: TextStyle(color: Colors.grey[800])),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: () {
                            dataManager.cancelReport(report);
                            showSnackBar(context, "신고를 취소했습니다.");
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text("신고 취소"),
                        ),
                      )
                    ],
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