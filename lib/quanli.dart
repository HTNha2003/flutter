import 'package:baithi/models/fooditem.dart';


class Cart {
  final List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addItem(FoodItem food) {
    _items.add(food);
  }

  void removeItem(FoodItem food) {
    _items.remove(food);
  }

  // Tính tổng tiền
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }
}

