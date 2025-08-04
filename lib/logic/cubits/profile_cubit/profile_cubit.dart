import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/app_assets.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';
import 'package:smart_garage_final_project/firebase/firebase_collections.dart';
import 'package:smart_garage_final_project/firebase/flutter_fire_store_consumer.dart';
import '../../../model/elevator_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  Timer? _timer;

  ProfileCubit() : super(ParkingInitial()) {
    // _subscribeToDocument();
  }

  // // listen to realtime updates
  // void _subscribeToDocument() {
  //   FirebaseFirestore.instance.doc("Elevator/elv").snapshots().listen((
  //     docSnapshot,
  //   ) {
  //     if (docSnapshot.exists) {
  //       emit(
  //         ElevatorDataLoaded(
  //           elevatorData: ElevatorModel.fromJson(docSnapshot.data()!),
  //         ),
  //       );
  //     }
  //   });
  // }

  setInitialImage() {
    if (CachedData.getData(key: KeysManager.profilePhoto) == null) {
      emit(SetTempImage(image: Assets.imagesNnnRemovebgPreview));
    } else {
      emit(
        SetRealImage(
          image: File(CachedData.getData(key: KeysManager.profilePhoto)),
        ),
      );
    }
  }

  uploadNewImage({required ImageSource imageSource}) async {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      File imgFile = File(pickedImage.path);

      CachedData.setData(
        key: KeysManager.profilePhoto,
        value: pickedImage.path,
      );
      emit(SetRealImage(image: imgFile));
    }
  }

  // }

  void retrieveCar({required String parkAreaId}) async {
    DatabaseReference ref = await FirebaseDatabase.instance.ref();
    DataSnapshot isElevatorAvailable =
        await ref.child('isElevatorAvailable').get();

    if (isElevatorAvailable.value == 1) {
      // Make elevator unavailable immediately
      await ref.update({"isElevatorAvailable": 0, 'status': 2});

      // Update parking area
      FirebaseFireStoreConsumer.setSpecificField(
        collectionName: FirebaseCollections.parkingAreas,
        documentId: parkAreaId,
        data: {'available': true, 'startTime': null, 'userId': ''},
      );

      CachedData.setData(key: KeysManager.userIsUsingService, value: false);

      emit(RetrieveProcessSuccess()); // Let BlocListener handle navigation
    } else {
      emit(RetrieveProcessFailed(message: 'Elevator is not available now'));
    }
  }
}
