import 'package:baithi/models/user.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myfood.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng điền đầy đủ thông tin!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var dio = Dio();
      final response = await dio.get('https://run.mocky.io/v3/68d238ad-781b-4b65-a81a-24ef95ca3e70');

      if (response.statusCode == 200) {
        final List users = response.data['users'];
        bool userFound = false;

        for (var userJson in users) {
          if (userJson['email'] == email && userJson['password'] == password) {
            User user = User.fromJson(userJson);

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userEmail', email);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyFood(user: user),
              ),
            );
            userFound = true;
            break;
          }
        }

        if (!userFound) {
          setState(() {
            _errorMessage = 'Email hoặc mật khẩu không đúng!';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Lỗi kết nối: ${response.statusMessage}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      if (_errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Frosted Glass Effect
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.cyan],
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Input
                          const Text(
                            "Email",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Nhập email",
                              prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập email";
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Email không hợp lệ";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Password Input
                          const Text(
                            "Mật khẩu",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Nhập mật khẩu",
                              prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng nhập mật khẩu";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _loginUser();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Đăng nhập",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
