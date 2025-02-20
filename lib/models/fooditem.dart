import 'dart:math';

class FoodItem {
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  String note; // Biến ghi chú có thể thay đổi
  int quantity; // Số lượng món ăn

  FoodItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.note,
    this.quantity = 1, // Giá trị mặc định là 1
  });

  // Tạo FoodItem từ JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] ?? 'Unknown', // Giá trị mặc định nếu không có 'name'
      imageUrl: json['imageUrl'] ?? '', // Giá trị mặc định nếu không có 'imageUrl'
      price: (json['price'] != null)
          ? json['price'].toDouble()
          : 0.0, // Giá trị mặc định nếu không có 'price'
      rating: (json['rating'] != null)
          ? json['rating'].toDouble()
          : 1 + (5 * Random().nextDouble()), // Random rating nếu không có
      note: json['note'] ?? 'No note available', // Mặc định cho ghi chú
      quantity: json['quantity'] ?? 1, // Mặc định là 1 nếu không có 'quantity'
    );
  }

  // Chuyển FoodItem thành JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'note': note,
      'quantity': quantity, // Thêm số lượng vào JSON
    };
  }

  // Cập nhật số lượng
  void updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      quantity = newQuantity;
    }
  }

  @override
  String toString() {
    return 'FoodItem(name: $name, price: $price, rating: $rating, note: $note, quantity: $quantity)';
  }
}
