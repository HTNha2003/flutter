import 'package:flutter/material.dart';
import 'package:baithi/APIserver.dart';
import 'package:baithi/models/cart.dart';
import 'package:baithi/models/fooditem.dart';

class FoodListScreen extends StatefulWidget {
  final Cart cart = Cart();

  FoodListScreen({Key? key}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  List<FoodItem> foodList = [];
  List<FoodItem> filteredFoodList = [];
  bool isLoading = true;
  String query = "";
  double minPrice = 0;
  double maxPrice = 20;
  double selectedRating = 0;

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    try {
      final fetchedFoods = await ApiService.fetchFoods();
      setState(() {
        foodList = fetchedFoods;
        filteredFoodList = fetchedFoods;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void filterFoods() {
    setState(() {
      filteredFoodList = foodList.where((food) {
        bool matchesQuery = food.name.toLowerCase().contains(query.toLowerCase());
        bool matchesPrice = food.price >= minPrice && food.price <= maxPrice;
        bool matchesRating = food.rating >= selectedRating;
        return matchesQuery && matchesPrice && matchesRating;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyFood',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            // Phần danh sách món ăn
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                        filterFoods();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for food...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : ListView.builder(
                            itemCount: filteredFoodList.length,
                            itemBuilder: (context, index) {
                              final food = filteredFoodList[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(food.imageUrl),
                                  ),
                                  title: Text(
                                    food.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('\$${food.price.toStringAsFixed(2)}'),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < food.rating ? Icons.star : Icons.star_border,
                                            color: Colors.amber,
                                            size: 18,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green),
                                    onPressed: () {
                                      widget.cart.addItem(food);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${food.name} added to cart!')),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            // Phần giỏ hàng
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Your Cart',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.cart.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = widget.cart.items[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(cartItem.food.imageUrl),
                            ),
                            title: Text(cartItem.food.name),
                            subtitle: Text('Quantity: ${cartItem.quantity}'),
                            trailing: Text(
                              '\$${(cartItem.food.price * cartItem.quantity).toStringAsFixed(2)}',
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Total: \$${widget.cart.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle order processing
                      },
                      child: const Text('Place Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
