class RoleModel {
  final int id;
  final String code;
  final String? description;

  const RoleModel({
    required this.id,
    required this.code,
    this.description,
  });

  /// Create a `RoleModel` from a JSON map.
  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json['id'],
        code: json['code'] as String,
        description: json['description'] as String?, // may be null
      );

  /// Convert a `RoleModel` to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        if (description != null) 'description': description,
      };

  @override
  String toString() =>
      'RoleModel(id: $id, code: $code, description: $description)';
}
