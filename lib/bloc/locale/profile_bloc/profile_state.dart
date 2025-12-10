import 'package:movie_app/api/api_model/api_response.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final String avatarPath;

  ProfileLoaded({
    required this.user,
    required this.avatarPath,
  });

  ProfileLoaded copyWith({
    UserModel? user,
    String? avatarPath,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

class ProfileUpdating extends ProfileState {
  final UserModel currentUser;
  final String currentAvatarPath;

  ProfileUpdating({
    required this.currentUser,
    required this.currentAvatarPath,
  });
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;
  final String avatarPath;
  final String message;

  ProfileUpdateSuccess({
    required this.user,
    required this.avatarPath,
    required this.message,
  });
}

class ProfileError extends ProfileState {
  final String message;
  final UserModel? user;
  final String? avatarPath;

  ProfileError({
    required this.message,
    this.user,
    this.avatarPath,
  });
}

class ProfileDeleted extends ProfileState {}
