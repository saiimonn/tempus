part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error, signingOut, signedOut }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  const ProfileState({required this.status, this.profile, this.errorMessage});

  const ProfileState.initial()
    : status = ProfileStatus.initial,
      profile = null,
      errorMessage = null;

  @override
  List<Object?> get props => [status, profile, errorMessage];

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
