import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'models/fooditem.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<int, TextEditingController> _noteControllers = {};

  @override
  void initState() {
    super.initState();
    // Khởi tạo TextEditingController cho từng món ăn
    for (var i = 0; i < widget.cart.items.length; i++) {
      _noteControllers[i] = TextEditingController(
        text: widget.cart.items[i].note,
      );
    }
  }

  @override
  void dispose() {
    // Giải phóng bộ điều khiển khi không sử dụng
    for (var controller in _noteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.cart.items.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cart.items[index];
                      final noteController = _noteControllers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          children: [
                            // Ảnh món ăn
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                cartItem.food.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Chi tiết món ăn
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.food.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${cartItem.food.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Ô nhập ghi chú
                                    TextField(
                                      controller: noteController,
                                      decoration: InputDecoration(
                                        hintText: 'Add a note',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          cartItem.note = value; // Cập nhật ghi chú
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Cột số lượng và nút cộng/trừ
                            Column(
                              children: [
                                // Nút cộng
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      cartItem.quantity++;
                                    });
                                  },
                                ),
                                // Hiển thị số lượng
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                // Nút trừ
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      if (cartItem.quantity > 1) {
                                        cartItem.quantity--;
                                      } else {
                                        widget.cart.removeItem(cartItem.food);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Hiển thị tổng giá
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${widget.cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // Nút thanh toán
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
              ),
              onPressed: widget.cart.items.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checkout successful!')),
                      );
                      setState(() {
                        widget.cart.clear();
                      });
                    },
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
