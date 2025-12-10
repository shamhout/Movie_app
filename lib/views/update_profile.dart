// lib/screens/update_profile.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/api_model/api_response.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_bloc.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_event.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_state.dart';
import 'package:movie_app/utils/app_assets.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';
import 'package:movie_app/utils/custom_elevated_button.dart';
import 'package:movie_app/utils/custom_text_field.dart';
// UserModel

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String selectedAvatar = AppAssets.avatar1;
  int? selectedAvaterId;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserModel? user, String avatarPath) {
    if (userNameController.text.isEmpty) {
      userNameController.text = user?.name ?? "";
      phoneNumberController.text = user?.phone ?? "";
      selectedAvatar = avatarPath;
      selectedAvaterId = user?.avaterId;
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileBloc>().add(
          UpdateProfileEvent(
            name: userNameController.text.trim(),
            phone: phoneNumberController.text.trim(),
            avatar: selectedAvaterId?.toString(),
          ),
        );
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.grayColor,
        title: Text("Delete_Account", style: AppStyle.reglur16yellow),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          style: AppStyle.reglur14white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("back", style: AppStyle.reglur14white),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete_Account", style: AppStyle.reglur14yellow),
          ),
        ],
      ),
    );
    if (confirm == true) {
      context.read<ProfileBloc>().add(DeleteProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Pick Avatar",
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          } else if (state is ProfileDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Delete_Account"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.loginScreen,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.yellow),
            );
          }
          final UserModel user = (state is ProfileLoaded)
              ? state.user
              : (state is ProfileUpdating)
                  ? state.currentUser
                  : (state is ProfileUpdateSuccess)
                      ? state.user
                      : (state is ProfileError && state.user != null)
                          ? state.user!
                          : UserModel();

          final String avatarPath = (state is ProfileLoaded)
              ? state.avatarPath
              : (state is ProfileUpdating)
                  ? state.currentAvatarPath
                  : (state is ProfileUpdateSuccess)
                      ? state.avatarPath
                      : (state is ProfileError && state.avatarPath != null)
                          ? state.avatarPath!
                          : AppAssets.avatar1;

          final isUpdating = state is ProfileUpdating;

          _initializeControllers(user, avatarPath);
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: height * 0.03,
              left: width * 0.04,
              right: width * 0.04,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: isUpdating ? null : () => _showAvatarPicker(avatarPath),
                      child: Image.asset(
                        selectedAvatar,
                        width: width * 0.38,
                        height: height * 0.18,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  CustomTextFormField(
                    controller: userNameController,
                    prefixIcon: const Icon(Icons.person),
                    iconColor: AppColor.whiteColor,
                    enabled: !isUpdating,
                    validator: (value) => (value == null || value.trim().isEmpty) ? "name" : null,
                  ),
                  SizedBox(height: height * 0.025),
                  CustomTextFormField(
                    controller: phoneNumberController,
                    prefixIcon: const Icon(Icons.phone),
                    iconColor: AppColor.whiteColor,
                    enabled: !isUpdating,
                    validator: (value) => (value == null || value.trim().isEmpty) ? "phoneNumber" : null,
                  ),
                  SizedBox(height: height * 0.01),
                  TextButton(
                    onPressed: isUpdating
                        ? null
                        : () {
                            Navigator.of(context).pushNamed(AppRoute.resetPassword);
                          },
                    child: const Text(
                      "Reset Password",
                      style: AppStyle.reglur17white,
                    ),
                  ),
                  SizedBox(height: height * 0.26),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      backgroundColor: AppColor.red,
                      onPressed: _deleteAccount,
                      text: "Delete Account",
                      textStyle: AppStyle.reglur20white,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: _updateProfile,
                      text: isUpdating ? "Updating..." : "Update Data",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAvatarPicker(String currentAvatarPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.grayColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final avatars = [
          AppAssets.avatar1,
          AppAssets.avatar2,
          AppAssets.avatar3,
          AppAssets.avatar4,
          AppAssets.avatar5,
          AppAssets.avatar6,
          AppAssets.avatar7,
          AppAssets.avatar8,
          AppAssets.avatar9,
        ];
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: height * 0.020,
            horizontal: width * 0.05,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: height * 0.025,
                    crossAxisSpacing: width * 0.04,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = avatars[index];
                    final isSelected = avatar == selectedAvatar;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                          final avatarMatch = RegExp(r'avatar(\d+)').firstMatch(avatar);
                          selectedAvaterId = avatarMatch != null ? int.parse(avatarMatch.group(1)!) : null;
                        });

                        if (selectedAvaterId != null) {
                          context.read<ProfileBloc>().add(
                                UpdateAvatarEvent(
                                  avatarPath: avatar,
                                  avaterId: selectedAvaterId!,
                                ),
                              );
                        }

                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.yellow.withOpacity(0.5) : Colors.transparent,
                          border: Border.all(
                            color: AppColor.yellow,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(avatar, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
