class UserModel {
  final String id;
  final String name;
  final String email;
  final double wallet;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        wallet: (json['wallet'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'wallet': wallet,
      };
}
