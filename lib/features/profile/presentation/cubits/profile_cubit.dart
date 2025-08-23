
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/profile/presentation/cubits/profile_states.dart';

import '../../../storage/domain/storage_repo.dart';
import '../../domain/repos/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState>{
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  //fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      }else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //update bio and or profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try{
      //fetch current profile first
      final currentProfile = await profileRepo.fetchUserProfile(uid);

      if(currentProfile == null){
        emit(ProfileError("Failed to fetch user for profile update"));
        return;

      }

      //profile picture update
      String? imageDownloadUrl;

      //ensure there is an image
      if(imageWebBytes != null || imageMobilePath != null){
        //for mobile
        if(imageMobilePath != null){
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        }
        //for web
        else if(imageWebBytes != null){
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }
      }

      //update new profile
      final updatedProfile = currentProfile.copyWith(
        newBio: newBio ?? currentProfile.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentProfile.profileImageUrl,
      );



      //update profile in repo
      await profileRepo.updateProfile(updatedProfile);

      //re-fetch updated profile
      await fetchUserProfile(uid);
    } catch(e){
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
