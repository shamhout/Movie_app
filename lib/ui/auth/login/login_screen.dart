import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_color.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // ---------------- LOGO ----------------
            Center(
              child: Image.asset(
                AppAssets.logo,
                width: 120,
              ),
            ),

            const SizedBox(height: 50),

            // ---------------- EMAIL FIELD ----------------
            _buildInputField(
              hint: "Email",
              icon: Icons.email,
              obscure: false,
            ),

            const SizedBox(height: 20),

            // ---------------- PASSWORD FIELD ----------------
            _buildInputField(
              hint: "Password",
              icon: Icons.lock,
              obscure: true,
              suffix: Icons.visibility,
            ),

            const SizedBox(height: 8),

            // ---------------- FORGOT PASSWORD ----------------
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forget Password ?",
                  style: TextStyle(color: AppColor.yellow),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- LOGIN BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- CREATE ACCOUNT ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't Have Account ?",
                  style: TextStyle(color: AppColor.whiteColor),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Create One",
                    style: TextStyle(color: AppColor.yellow),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ---------------- OR ----------------
            Row(
              children: const [
                Expanded(child: Divider(color: AppColor.yellow)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("OR",
                      style: TextStyle(color: AppColor.yellow)),
                ),
                Expanded(child: Divider(color: AppColor.yellow)),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- GOOGLE LOGIN BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.google,
                    color: AppColor.blackColor),
                onPressed: () {},
                label: const Text(
                  "Login With Google",
                  style:
                  TextStyle(color: AppColor.blackColor, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- LANGUAGE TOGGLE ----------------
            const LanguageToggle(),
          ],
        ),
      ),
    );
  }

  // ---------------- REUSABLE INPUT FIELD ----------------
  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required bool obscure,
    IconData? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.grayColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: AppColor.whiteColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColor.whiteColor),
          prefixIcon: Icon(icon, color: AppColor.whiteColor),
          suffixIcon:
          suffix != null ? Icon(suffix, color: Colors.white70) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// ---------------------- LANGUAGE TOGGLE ---------------------
// ------------------------------------------------------------
class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColor.yellow,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.blackColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          children: [
            // ------------------ Highlight Circle ------------------
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment:
              isEnglish ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: AppColor.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ------------------ Flags ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ENGLISH
                GestureDetector(
                  onTap: () => setState(() => isEnglish = true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Image.asset(
                      AppAssets.enFlag,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),

                // ARABIC
                GestureDetector(
                  onTap: () => setState(() => isEnglish = false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Image.asset(
                      AppAssets.egFlag,
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
