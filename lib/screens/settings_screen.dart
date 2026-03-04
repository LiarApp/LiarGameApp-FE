// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../utils/common_utils.dart';
import 'login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- [설정 상태 변수] ---
  bool _isBgmOn = true;      // 배경음악 ON/OFF
  double _bgmVolume = 0.5;   // 배경음악 볼륨 (0.0 ~ 1.0)

  bool _isSfxOn = true;      // 효과음 ON/OFF
  double _sfxVolume = 0.5;   // 효과음 볼륨 (0.0 ~ 1.0)

  // --- [회원 탈퇴 로직] ---
  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("회원 탈퇴", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다."),
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
                        Navigator.pop(context);
                        showSnackBar(context, "회원 탈퇴가 완료되었습니다.");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("탈퇴하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Scaffold(
      appBar: AppBar(title: const Text("설정")),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // 1. 사운드 설정 섹션
          _buildSectionHeader("사운드"),

          // [배경음악 설정]
          _buildVolumeControl(
            title: "배경음악",
            icon: _isBgmOn ? Icons.music_note : Icons.music_off,
            isOn: _isBgmOn,
            volume: _bgmVolume,
            onSwitchChanged: (val) {
              setState(() {
                _isBgmOn = val;
                if (val) {
                  // 켜질 때 볼륨이 0이면 50%로 설정
                  if (_bgmVolume == 0) _bgmVolume = 0.5;
                } else {
                  // 꺼질 때 볼륨 0으로
                  _bgmVolume = 0.0;
                }
              });
            },
            onSliderChanged: (val) {
              setState(() {
                _bgmVolume = val;
                // 슬라이더 값에 따라 ON/OFF 자동 결정
                if (_bgmVolume > 0) {
                  _isBgmOn = true;
                } else {
                  _isBgmOn = false;
                }
              });
            },
          ),

          const Divider(height: 30),

          // [효과음 설정]
          _buildVolumeControl(
            title: "효과음",
            icon: _isSfxOn ? Icons.graphic_eq : Icons.volume_off,
            isOn: _isSfxOn,
            volume: _sfxVolume,
            onSwitchChanged: (val) {
              setState(() {
                _isSfxOn = val;
                if (val) {
                  if (_sfxVolume == 0) _sfxVolume = 0.5;
                } else {
                  _sfxVolume = 0.0;
                }
              });
            },
            onSliderChanged: (val) {
              setState(() {
                _sfxVolume = val;
                if (_sfxVolume > 0) {
                  _isSfxOn = true;
                } else {
                  _isSfxOn = false;
                }
              });
            },
          ),

          const Divider(height: 40, thickness: 1),

          // 2. 계정 관리 섹션
          _buildSectionHeader("계정 관리"),

          ListTile(
            leading: const Icon(Icons.person_off_rounded, color: Colors.red),
            title: const Text("회원 탈퇴", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: _deleteAccount,
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "App Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 섹션 헤더 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 볼륨 조절 위젯 (스위치 + 슬라이더 통합)
  Widget _buildVolumeControl({
    required String title,
    required IconData icon,
    required bool isOn,
    required double volume,
    required ValueChanged<bool> onSwitchChanged,
    required ValueChanged<double> onSliderChanged,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        // 스위치 타일
        SwitchListTile(
          title: Text(title),
          subtitle: Text(
            isOn ? "켜짐 (${(volume * 100).toInt()}%)" : "꺼짐",
            style: TextStyle(
                color: isOn ? primaryColor : Colors.grey,
                fontWeight: isOn ? FontWeight.bold : FontWeight.normal
            ),
          ),
          value: isOn,
          activeColor: primaryColor,
          onChanged: onSwitchChanged,
          secondary: Icon(
            icon,
            color: isOn ? primaryColor : Colors.grey,
          ),
        ),
        // 슬라이더 (타일 바로 아래 배치)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.volume_mute, size: 20, color: Colors.grey[400]),
              Expanded(
                child: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20, // 5% 단위로 끊김
                  label: "${(volume * 100).toInt()}%",
                  activeColor: primaryColor,
                  inactiveColor: Colors.grey[200],
                  onChanged: onSliderChanged,
                ),
              ),
              Icon(Icons.volume_up, size: 20, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }
}