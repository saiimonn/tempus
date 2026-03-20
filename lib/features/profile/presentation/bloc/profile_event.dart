part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileSignOutRequested extends ProfileEvent {
  const ProfileSignOutRequested();
}