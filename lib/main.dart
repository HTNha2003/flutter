import 'package:baithi/foodlist.dart';
import 'package:baithi/login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

/// Ứng dụng chính
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tiêu đề của ứng dụng
      title: 'Food Ordering App',
      debugShowCheckedModeBanner: false,
    
      // Giao diện chủ đề của ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu chủ đạo của ứng dụng
      ),

      // Màn hình chính của ứng dụng
      home: const Login(),
    );
  }
}
