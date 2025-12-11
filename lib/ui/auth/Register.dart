import 'package:flutter/material.dart';
import 'package:movie_app/l10n/app_localizations.dart';
import 'package:movie_app/ui/auth/animated_toggle_switch/animated_toggle_switch.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth_api.dart';
import '../../utils/Custom_text_field.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/custom_elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedAvatar = 1;
  bool isPasswordObscured = true;
  bool isRePasswordObscured = true;
  late PageController avatarController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    avatarController =
        PageController(viewportFraction: 0.32, initialPage: selectedAvatar);
  }

  @override
  void dispose() {
    avatarController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final res = await AuthMangerApi.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        phone: phoneController.text.trim(),
        avatar: (selectedAvatar + 1).toString(),
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (res.success) {
        if (res.data != null && res.data!.token != null) {
          final token = res.data!.token;

          if (token != null && token.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("token", token);
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(AppRoute.homeTab);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(res.message ?? "account register complete!"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ??
                  "account register complete! you need to login now!"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        _showErrorSnackBar(res.message ??
            "error while register this account please try again later");
      }
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
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.blackColor,
        title: Text(appLocalizations.register, style: AppStyle.reglur16yellow),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.yellow),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.01),
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: avatarController,
                    itemCount: 9,
                    onPageChanged: (index) {
                      setState(() {
                        selectedAvatar = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final bool isSelected = selectedAvatar == index;
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            avatarController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              selectedAvatar = index;
                            });
                          },
                          child: AnimatedScale(
                            scale: isSelected ? 1.25 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Container(
                              width: isSelected ? 110 : 80,
                              height: isSelected ? 110 : 80,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/avatar${index + 1}.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(appLocalizations.avatar, style: AppStyle.reglur16white),
                SizedBox(height: height * 0.02),
                CustomTextFormField(
                  controller: nameController,
                  prefixIcon: Image.asset(AppAssets.nameIcon),
                  hint: appLocalizations.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter your name";
                    }
                    if (value.trim().length < 3) {
                      return "the name must have at least 3 chars or more";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Image.asset(AppAssets.emailIcon),
                  hint: appLocalizations.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter a valid emailAddress";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "incorrect emailAddress";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: passwordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isPasswordObscured,
                  hint: appLocalizations.password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter password";
                    }
                    if (value.length < 8) {
                      return "password must have 6 chars or more";
                    }
                    final strongPasswordRegex = RegExp(
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');
                    if (!strongPasswordRegex.hasMatch(value)) {
                      return "The password must contain at least one lowercase letter, one uppercase letter, and one special character such as @ ";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                        () => isPasswordObscured = !isPasswordObscured),
                    child: isPasswordObscured
                        ? Image.asset(AppAssets.eyeoff)
                        : const Icon(Icons.remove_red_eye_outlined,
                            color: Colors.white),
                  ),
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: confirmPasswordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isRePasswordObscured,
                  hint: appLocalizations.confirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Re type password";
                    }
                    if (value != passwordController.text) {
                      return "repassword isn't match with password";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                        () => isRePasswordObscured = !isRePasswordObscured),
                    child: isRePasswordObscured
                        ? Image.asset(AppAssets.eyeoff)
                        : const Icon(Icons.remove_red_eye_outlined,
                            color: Colors.white),
                  ),
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: phoneController,
                  prefixIcon: Image.asset(AppAssets.phoneIcon),
                  hint: appLocalizations.phoneNumber,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter a phone number";
                    }
                    final phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
                    if (!phoneRegex.hasMatch(value.trim())) {
                      return "incorrect phone number (ex: 01111111111";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .024),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: () {
                      if (!isLoading) {
                        _register();
                      }
                    },
                    text: isLoading
                        ? "Loading..."
                        : appLocalizations.createAccount,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appLocalizations.alreadyHaveAccount,
                        style: AppStyle.reglur14white),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(appLocalizations.login,
                          style: AppStyle.reglur14yellow),
                    ),
                  ],
                ),
                const LanguageToggle(),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
