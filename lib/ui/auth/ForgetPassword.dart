import 'package:flutter/material.dart';
import '../../api/auth_api.dart';
import '../../utils/Custom_text_field.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/custom_elevated_button.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;
  bool emailVerified = false;

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });
    try {
      final res = await AuthMangerApi.ForgetPassword(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      if (res.success) {
        _showSuccessSnackBar(res.message ?? "Password changed successfully");
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        _showErrorSnackBar(res.message ?? "Password change failed");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar("An error occurred : ${e.toString()}");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.yellow),
        title: const Text(
          "ForgetPassword",
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(AppAssets.forgetPasswordPhoto),
                const Text(
                  "Enter your email and new password",
                  style: AppStyle.reglur16white,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * .025),
                CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Image.asset(AppAssets.emailIcon),
                  hint: "Email",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Invalid email address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .025),
                CustomTextFormField(
                  controller: newPasswordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isPasswordObscured,
                  hint: "New password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the new password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters long";
                    }
                    final strongPasswordRegex = RegExp(r'^(?=.[a-z])(?=.[A-Z])(?=.*\d).{8,}$');
                    if (!strongPasswordRegex.hasMatch(value)) {
                      return "Must contain an uppercase letter, a lowercase letter, and a number";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordObscured = !isPasswordObscured;
                      });
                    },
                    child: isPasswordObscured ? Image.asset(AppAssets.eyeoff) : const Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                  ),
                ),
                SizedBox(height: height * .025),
                CustomTextFormField(
                  controller: confirmPasswordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isConfirmPasswordObscured,
                  hint: "Confirm new password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isConfirmPasswordObscured = !isConfirmPasswordObscured;
                      });
                    },
                    child: isConfirmPasswordObscured ? Image.asset(AppAssets.eyeoff) : const Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                  ),
                ),
                SizedBox(height: height * .035),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(onPressed: _resetPassword, text: isLoading ? "Changing..." : "Change Password"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Back to login",
                    style: AppStyle.reglur14yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}