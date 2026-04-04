part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String fullName;
  final String course;
  final String yearLevel;

  const ProfileUpdateRequested({
    required this.fullName,
    required this.course,
    required this.yearLevel,
  });
}

class ProfileSignOutRequested extends ProfileEvent {
  const ProfileSignOutRequested();
}
