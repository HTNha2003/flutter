class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String image;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.image,
  });

  // Chuyển đổi từ JSON sang User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Chuyển đổi từ User object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone)';
  }
}
