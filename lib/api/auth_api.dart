import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_model/api_response.dart';


class AuthMangerApi {
static Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "please login first");
      }

      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse<UserModel>.fromJson(
          jsonResponse,
          (data) => UserModel.fromJson(data),
        );
      } else if (response.statusCode == 401) {
        await logout();
        return ApiResponse(success: false, message: "session ended");
      } else {
        return ApiResponse(success: false, message: "failed get the data");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "$e");
    }
  }

  static Future<ApiResponse<void>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) async {
    try {
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        return ApiResponse(
          success: false,
          message: "please Login first!",
        );
      }

      Map<String, dynamic> body = {};
      if (email != null) body["email"] = email;
      if (name != null) body["name"] = name;
      if (phone != null) body["phone"] = phone;

      if (avatar != null) {
        int? id = int.tryParse(avatar);
        if (id != null) body["avaterId"] = id;
      }

      final response = await http.patch(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: "profile updated successfully",
        );
      } else if (response.statusCode == 401) {
        await logout();
        return ApiResponse(
          success: false,
          message: "session ended",
        );
      } else {
        return ApiResponse(
          success: false,
          message: "failed update profile",
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<ApiResponse<void>> deleteProfile() async {
    try {
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        return ApiResponse(
          success: false,
          message: "please login first",
        );
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/user"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["status"] == true) {
          await logout();
          return ApiResponse(
            success: true,
            message: json["message"] ?? "account deleted",
          );
        } else {
          return ApiResponse(
            success: false,
            message: json["message"] ?? "failed deleting the account",
          );
        }
      } else {
        return ApiResponse(
          success: false,
          message: "connection error",
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }

  static Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {}
  }

  static Future<UserModel?> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('user_data');
      if (userData == null) return null;
      return UserModel.fromJson(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveUserData(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toJson()));
    } catch (e) {}
  }
  
  static const String baseUrl = 'https://route-movie-apis.vercel.app';

  static Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final auth = AuthResponse.fromJson(json);
        if (auth.token != null && auth.token!.isNotEmpty) {
          return ApiResponse(success: true, message: json["message"] ?? "login success!", data: auth);
        }
        return ApiResponse(success: false, message: "");
      }
      return ApiResponse(success: false, message: json["message"] ?? "login failed, please try again");
    } catch (e) {
      return ApiResponse(success: false, message: "$e");
    }
  }

 
 

  static Future<void> _fetchAndSaveUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["status"] == true && json["user"] != null) {
          final user = UserModel.fromJson(json["user"]);
          await saveUserData(user);
        }
      }
    } catch (_) {}
  }

  static Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String avatar,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty || phone.trim().isEmpty || avatar.isEmpty) {
      return ApiResponse(success: false, message: "all fields are required");
    }
    if (password != confirmPassword) return ApiResponse(success: false, message: "passwords isn't match");
    if (password.length < 8) return ApiResponse(success: false, message: "password must be at least 8 chars");
    final strongPasswordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$'
    );

    if (!strongPasswordRegex.hasMatch(password)) {
      return ApiResponse(
        success: false,
        message: "The password must contain at least one lowercase letter, one uppercase letter, and one special character such as @",
      );
    }

    String formattedPhone = phone.trim();
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '+2$formattedPhone';
    } else if (!formattedPhone.startsWith('+')) formattedPhone = '+20$formattedPhone';
    try {
      final avaterId = int.tryParse(avatar);
      if (avaterId == null) return ApiResponse(success: false, message: "error");
      final requestBody = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password,
        "confirmPassword": confirmPassword,
        "phone": formattedPhone,
        "avaterId": avaterId,
      };
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.trim().startsWith('{')) {
          final json = jsonDecode(response.body);
          if (json["message"] != null && json["message"].toString().contains("successfully")) {
            return ApiResponse(success: true, message: "register complete please login!", data: null);
          } else if (json["status"] == true) {
            final auth = AuthResponse.fromJson(json);
            if (auth.token != null && auth.token!.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString("token", auth.token!);
            }
            return ApiResponse(success: true, message: json["message"] ?? "login successfully", data: auth);
          } else {
            return ApiResponse(success: false, message: json["message"] ?? "login failed");
          }
        }
        return ApiResponse(success: false, message: "server didn't answer");
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        try {
          final json = jsonDecode(response.body);
          String errorMessage = json["message"] ?? "login failed";
          if (errorMessage.toLowerCase().contains("already") || errorMessage.toLowerCase().contains("exist")) {
            errorMessage = "emailAdress already Exist please login!";
          }
          return ApiResponse(success: false, message: errorMessage);
        } catch (_) {
          return ApiResponse(success: false, message: "unexpected error");
        }
      } else {
        try {
          final json = jsonDecode(response.body);
          return ApiResponse(success: false, message: json["message"] ?? "network error");
        } catch (_) {
          return ApiResponse(success: false, message: "${response.statusCode})");
        }
      }
    } catch (e) {
      String errorMessage = "error while processing";
      if (e.toString().contains("SocketException") || e.toString().contains("Failed host lookup")) {
        errorMessage = "check your network connection";
      } else if (e.toString().contains("TimeoutException")) {
        errorMessage = "please try again";
      }
      return ApiResponse(success: false, message: errorMessage);
    }
  }

  static Future<ApiResponse<bool>> checkEmailExists(String email) async {
    try {
      if (email.trim().isEmpty) return ApiResponse(success: false, message: "please enter you emailAddress", data: false);

      final response = await http.get(
        Uri.parse('$baseUrl/user/check-email?email=${email.trim()}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) return ApiResponse(success: true, message: "emailAdress Exist", data: true);
      if (response.statusCode == 404) return ApiResponse(success: false, message: "emailAdress Not Found", data: false);
      return ApiResponse(success: false, message: "error while checking on emailAddress", data: false);
    } catch (_) {
      return ApiResponse(success: false, message: "unExpected error happend try again", data: false);
    }
  }

  static Future<ApiResponse<void>> ForgetPassword({required String email, required String newPassword}) async {
    try {
      if (email.trim().isEmpty || newPassword.isEmpty) return ApiResponse(success: false, message: "emailAdress and password are required");

      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email.trim(), "newPassword": newPassword}),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResponse(success: json["status"] == true, message: json["message"] ?? "password Changed successfully");
      } else if (response.statusCode == 404) return ApiResponse(success: false, message: "emailAdress not Found");
      return ApiResponse(success: false, message: "error while connecting to network");
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  

 

 

  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveToken(String token) async {
    try {
      if (token.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
    } catch (_) {}
  }
}