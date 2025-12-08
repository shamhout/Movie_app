import 'package:flutter/material.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth_api.dart';
import '../../main.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/custom_elevated_button.dart';
import '../../utils/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isCensored = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final res = await AuthMangerApi.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      if (res.success && res.data != null) {
        final token = res.data!.token;

        if (token != null && token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          try {
            final profileResponse = await AuthMangerApi.getProfile();
            if (profileResponse.success && profileResponse.data != null) {
              await AuthMangerApi.saveUserData(profileResponse.data!);
            } else {}
          } catch (e) {}
          await prefs.remove('user_data');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(res.message ?? "Login successful!"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
          }
          return;
        }
      }
      _showErrorSnackBar(res.message ?? "Incorrect email or password");
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showErrorSnackBar(e.toString());
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * .07),
                Image.asset(AppAssets.logo),
                SizedBox(height: height * .07),
                CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Image.asset(AppAssets.emailIcon),
                  hint: "Email",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter your email adress";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "incorrect email adress";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: passwordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isCensored,
                  hint: "Password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your password";
                    }
                    if (value.length < 6) {
                      return "password should be at least 6 chars or more";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCensored = !isCensored;
                      });
                    },
                    child: isCensored
                        ? Image.asset(AppAssets.eyeoff)
                        : const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.forgetPassword);
                      },
                      child: const Text(
                        "Forget Password ?",
                        style: AppStyle.reglur14yellow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .035),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: _handleLogin,
                    text: isLoading ? "loading" : "login",
                  ),
                ),
                SizedBox(height: height * .024),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dont Have Account ?",
                      style: AppStyle.reglur14white,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.registerScreen);
                      },
                      child: const Text(
                        "Create One",
                        style: AppStyle.reglur14yellow,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColor.yellow,
                        indent: 80,
                        endIndent: 15,
                      ),
                    ),
                    Text(
                      "or",
                      style: AppStyle.reglur14yellow,
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColor.yellow,
                        indent: 15,
                        endIndent: 80,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .03),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("success login with google"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    hasIcon: true,
                    iconWidget: Image.asset(AppAssets.googleIcon),
                    text: " Login With Google",
                    mainAxisAlignment: MainAxisAlignment.center,
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
