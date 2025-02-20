import 'dart:convert';
import 'package:baithi/models/fooditem.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  // URL API để lấy danh sách món ăn
  static const String apiUrl = 'https://run.mocky.io/v3/f7b09090-fcaa-46aa-92f1-a1711c740c68';

  // Hàm lấy món ăn từ API
  static Future<List<FoodItem>> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl)); // Gửi request GET tới API

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Phân tích dữ liệu JSON
        return data.map((item) => FoodItem.fromJson(item)).toList(); // Chuyển đổi dữ liệu thành danh sách FoodItem
      } else {
        throw Exception('Failed to load foods'); // Xử lý lỗi nếu API trả về mã lỗi
      }
    } catch (error) {
      throw Exception('Error fetching data: $error'); // Xử lý lỗi khi kết nối API
    }
  }
}