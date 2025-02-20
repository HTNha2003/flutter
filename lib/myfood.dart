import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:baithi/APIserver.dart';
import 'package:baithi/cart.dart';
import 'package:baithi/models/cart.dart';
import 'package:baithi/models/fooditem.dart';
import 'package:baithi/models/user.dart';

class MyFood extends StatefulWidget {
  final User user;
  final Cart cart = Cart(); // Shared cart for the session

  MyFood({Key? key, required this.user}) : super(key: key);

  @override
  State<MyFood> createState() => _MyFoodState();
}

class _MyFoodState extends State<MyFood> {
  List<FoodItem> foodList = [];
  List<FoodItem> filteredFoodList = [];
  bool isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredFoodList = foodList
            .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user.email}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: widget.cart),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search for food...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Expanded(
                  child: filteredFoodList.isEmpty
                      ? const Center(child: Text('No foods found!'))
                      : ListView.builder(
                          itemCount: filteredFoodList.length,
                          itemBuilder: (context, index) {
                            final food = filteredFoodList[index];
                            return ListTile(
                              leading: Image.network(
                                food.imageUrl,
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                              title: Text(food.name),
                              subtitle:
                                  Text('\$${food.price.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  widget.cart.addItem(food);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('${food.name} added to cart!')),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
