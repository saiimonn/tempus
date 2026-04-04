import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:tempus/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/domain/use_cases/get_profile.dart';
import 'package:tempus/features/profile/domain/use_cases/update_profile.dart';
import 'package:tempus/features/profile/domain/use_cases/sign_out.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final SignOut _signOut;

  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required SignOut signOut,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       _signOut = signOut,
       super(const ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileUpdateRequested>(_onUpdate);
    on<ProfileSignOutRequested>(_onSignOut);
  }

  factory ProfileBloc.create() {
    final dataSource = ProfileRemoteDataSource(Supabase.instance.client);
    final repository = ProfileRepositoryImpl(dataSource);
    return ProfileBloc(
      getProfile: GetProfile(repository),
      updateProfile: UpdateProfile(repository),
      signOut: SignOut(repository),
    );
  }

  Future<void> _onLoad(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = await _getProfile();
      emit(state.copyWith(status: ProfileStatus.loaded, profile: profile));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to load profile',
        ),
      );
    }
  }

  Future<void> _onUpdate(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      final updated = await _updateProfile(
        fullName: event.fullName,
        course: event.course,
        yearLevel: event.yearLevel,
      );

      emit(state.copyWith(status: ProfileStatus.updated, profile: updated));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to update profile',
        ),
      );
    }
  }

  Future<void> _onSignOut(
    ProfileSignOutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.signingOut));

    try {
      await _signOut();
      emit(state.copyWith(status: ProfileStatus.signedOut));
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to sign out',
        ),
      );
    }
  }
}
