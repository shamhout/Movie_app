abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String phone;
  final String? avatar;

  UpdateProfileEvent({
    required this.name,
    required this.phone,
    this.avatar,
  });
}

class UpdateAvatarEvent extends ProfileEvent {
  final String avatarPath;
  final int avaterId;
  UpdateAvatarEvent({
    required this.avatarPath,
    required this.avaterId,
  });
}

class DeleteProfileEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}
