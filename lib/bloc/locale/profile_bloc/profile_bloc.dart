import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/auth_api.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_event.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_state.dart';
import 'package:movie_app/utils/app_assets.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
    on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final token = await AuthMangerApi.getToken();
      if (token == null || token.isEmpty) {
        final localUser = await AuthMangerApi.getUserData();
        if (localUser != null) {
          final avatarPath = localUser.avaterId != null ? 'assets/images/avatar${localUser.avaterId}.png' : AppAssets.avatar1;
          emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
        } else {
          emit(ProfileError(message: "Please login to view your profile"));
        }
        return;
      }

      final response = await AuthMangerApi.getProfile();
      if (response.success && response.data != null) {
        final user = response.data!;
        await AuthMangerApi.saveUserData(user);
        final avatarPath = user.avaterId != null ? 'assets/images/avatar${user.avaterId}.png' : AppAssets.avatar1;
        emit(ProfileLoaded(user: user, avatarPath: avatarPath));
      } else {
        final localUser = await AuthMangerApi.getUserData();
        if (localUser != null) {
          final avatarPath = localUser.avaterId != null ? 'assets/images/avatar${localUser.avaterId}.png' : AppAssets.avatar1;
          emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
        } else {
          String errorMessage = response.message ?? "Failed to load profile";
          if (errorMessage.contains("session ended") || errorMessage.contains("401")) {
            errorMessage = "Session expired. Please login again.";
          }

          emit(ProfileError(message: errorMessage));
        }
      }
    } catch (e) {
      final localUser = await AuthMangerApi.getUserData();
      if (localUser != null) {
        final avatarPath = localUser.avaterId != null ? 'assets/images/avatar${localUser.avaterId}.png' : AppAssets.avatar1;
        emit(ProfileLoaded(user: localUser, avatarPath: avatarPath));
      } else {
        emit(ProfileError(message: "Error loading profile. Please try again."));
      }
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(
        currentUser: currentState.user,
        currentAvatarPath: currentState.avatarPath,
      ));

      try {
        final response = await AuthMangerApi.updateProfile(
          name: event.name,
          phone: event.phone,
          avatar: event.avatar,
        );

        if (response.success) {
          final avaterId = event.avatar != null ? int.parse(event.avatar!) : null;

          final updatedUser = currentState.user.copyWith(
            name: event.name,
            phone: event.phone,
            avaterId: avaterId,
          );
          await AuthMangerApi.saveUserData(updatedUser);

          final avatarPath = avaterId != null ? 'assets/images/avatar$avaterId.png' : currentState.avatarPath;
          emit(ProfileUpdateSuccess(
            user: updatedUser,
            avatarPath: avatarPath,
            message: response.message ?? "Profile updated successfully",
          ));
          emit(ProfileLoaded(user: updatedUser, avatarPath: avatarPath));
        } else {
          emit(ProfileError(
            message: response.message ?? "Failed to update profile",
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
          emit(ProfileLoaded(
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
        }
      } catch (e) {
        emit(ProfileError(
          message: "Error occurred: ${e.toString()}",
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
        emit(ProfileLoaded(
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
      }
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(avatarPath: event.avatarPath));
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(
        currentUser: currentState.user,
        currentAvatarPath: currentState.avatarPath,
      ));
      try {
        final response = await AuthMangerApi.deleteProfile();
        if (response.success) {
          emit(ProfileDeleted());
        } else {
          emit(ProfileError(
            message: response.message ?? "Failed to delete account",
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
          emit(ProfileLoaded(
            user: currentState.user,
            avatarPath: currentState.avatarPath,
          ));
        }
      } catch (e) {
        emit(ProfileError(
          message: "Error occurred: ${e.toString()}",
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
        emit(ProfileLoaded(
          user: currentState.user,
          avatarPath: currentState.avatarPath,
        ));
      }
    }
  }
}
