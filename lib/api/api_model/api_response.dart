class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? token;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.token,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    bool isSuccess = json['success'] ?? (json['data'] != null);

    return ApiResponse<T>(
      success: isSuccess,
      message: json['message'],
      token: json['token'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'data': data,
    };
  }
}

class AuthResponse {
  final String? token;

  AuthResponse({this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['data'],
    );
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? avaterId;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avaterId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avaterId: json['avaterId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avaterId': avaterId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  copyWith({required String name, required String phone, int? avaterId}) {}



}