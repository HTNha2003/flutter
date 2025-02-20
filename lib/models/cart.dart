import 'package:baithi/models/fooditem.dart';

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items); // Đảm bảo không sửa đổi trực tiếp từ bên ngoài

  // Thêm món ăn vào giỏ hoặc tăng số lượng
  void addItem(FoodItem item, {String note = ''}) {
    final existingItemIndex = _items.indexWhere(
      (cartItem) => cartItem.food.name == item.name,
    );

    if (existingItemIndex != -1) {
      _items[existingItemIndex].quantity += 1;
      if (note.isNotEmpty) {
        _items[existingItemIndex].note = note;
      }
    } else {
      _items.add(CartItem(food: item, note: note, quantity: 1));
    }
  }

  // Giảm số lượng món ăn, nếu số lượng bằng 0 thì xóa món ăn
  void decreaseQuantity(FoodItem item) {
    final existingItemIndex = _items.indexWhere(
      (cartItem) => cartItem.food.name == item.name,
    );

    if (existingItemIndex != -1) {
      final cartItem = _items[existingItemIndex];
      if (cartItem.quantity > 1) {
        cartItem.quantity -= 1;
      } else {
        removeItem(item); // Xóa nếu số lượng bằng 0
      }
    }
  }

  // Xóa một món ăn khỏi giỏ
  void removeItem(FoodItem item) {
    _items.removeWhere((cartItem) => cartItem.food.name == item.name);
  }

  // Xóa tất cả món ăn trong giỏ
  void clear() {
    _items.clear();
  }

  // Tính tổng giá trị giỏ hàng
  double get totalPrice {
    return _items.fold(
      0,
      (sum, cartItem) => sum + (cartItem.food.price * cartItem.quantity),
    );
  }

  // Kiểm tra xem món ăn đã có trong giỏ hay chưa
  bool containsItem(FoodItem item) {
    return _items.any((cartItem) => cartItem.food.name == item.name);
  }

  // Lấy số lượng món ăn trong giỏ
  int getQuantity(FoodItem item) {
    final existingItem = _items.firstWhere(
      (cartItem) => cartItem.food.name == item.name,
      orElse: () => CartItem(food: item, note: '', quantity: 0),
    );
    return existingItem.quantity;
  }
}

class CartItem {
  final FoodItem food;
  String note; // Ghi chú cho món ăn trong giỏ hàng
  int quantity; // Số lượng món ăn

  CartItem({
    required this.food,
    required this.note,
    required this.quantity,
  });
}
