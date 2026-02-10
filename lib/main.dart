// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart'; // import 경로 확인

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 디자인 테마 정의
    final baseColor = const Color(0xFF5E35B1);
    final lightBgColor = const Color(0xFFF5F5F5);

    return MaterialApp(
      title: 'Modern Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: baseColor,
            brightness: Brightness.light,
            primary: baseColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: lightBgColor,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: baseColor, width: 1.5),
            ),
            prefixIconColor: Colors.grey[600],
            labelStyle: TextStyle(color: Colors.grey[600]),
            floatingLabelStyle: TextStyle(color: baseColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: baseColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              elevation: 2,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: baseColor,
                side: BorderSide(color: baseColor),
                minimumSize: const Size(80, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
          )
      ),
      home: const LoginPage(),
    );
  }
}