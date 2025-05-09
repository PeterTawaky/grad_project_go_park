import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/app_assets.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';
import 'package:smart_garage_final_project/firebase/firebase_collections.dart';
import 'package:smart_garage_final_project/firebase/flutter_fire_store_consumer.dart';
import 'package:smart_garage_final_project/image_uploader.dart';
import 'package:smart_garage_final_project/model/park_area_model.dart';
import '../../../model/elevator_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  Timer? _timer;

  ProfileCubit() : super(ParkingInitial()) {
    _subscribeToDocument();
  }

  // listen to realtime updates
  void _subscribeToDocument() {
    FirebaseFirestore.instance.doc("Elevator/elv").snapshots().listen((
      docSnapshot,
    ) {
      if (docSnapshot.exists) {
        emit(
          ElevatorDataLoaded(
            elevatorData: ElevatorModel.fromJson(docSnapshot.data()!),
          ),
        );
      }
    });
  }

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

  void retrieveCar({required String parkAreaId}) async {
    DocumentSnapshot? response =
        await FirebaseFireStoreConsumer.getDocumentData(
          collectionPath: FirebaseCollections.elevator,
          documentId: 'elv',
        );

    if (response != null) {
      if (response['available'] == true) {
        emit(RetrieveProcessSuccess());
        FirebaseFireStoreConsumer.setSpecificField(
          collectionName: FirebaseCollections.parkingAreas,
          documentId: parkAreaId,
          data: {'available': true, 'startTime': null, 'userId': ''},
        );
        CachedData.setData(key: KeysManager.userIsUsingService, value: false);

        FirebaseFireStoreConsumer.setSpecificField(
          collectionName: FirebaseCollections.elevator,
          documentId: 'elv',
          data: {'available': false},
        );
        Future.delayed(Duration(seconds: 10), () {
          FirebaseFireStoreConsumer.setSpecificField(
            collectionName: FirebaseCollections.elevator,
            documentId: 'elv',
            data: {'available': true},
          );
        });
      } else {
        emit(RetrieveProcessFailed(message: 'Elevator is not available now'));
      }
    } else {
      emit(RetrieveProcessFailed(message: 'opps, something went wrong'));
    }
  }
}
