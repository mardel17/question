class User {
  String id;
  String username;
  String email;
  String avatar;

  String customer;

  User({
    this.id,
    this.username,
    this.email,
    this.avatar,
    this.customer,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'customer': customer,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['uuid'] ?? "",
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      avatar: map['avatar'] ?? "",
      customer: map['customer'] ?? "",
    );
  }
}
