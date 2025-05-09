import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:smart_garage_final_project/cached/cache_helper.dart';
import 'package:smart_garage_final_project/core/utils/keys_manager.dart';
import '../../../firebase/firebase_collections.dart';
import '../../../firebase/flutter_fire_store_consumer.dart';
import '../../../model/park_area_model.dart';

part 'parking_state.dart';

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingInitial());

  startParkingProcess() async {
    DocumentSnapshot? response =
        await FirebaseFireStoreConsumer.getDocumentData(
          collectionPath: FirebaseCollections.elevator,
          documentId: 'elv',
        );

    if (response != null) {
      if (response['available'] == true) {
        final parkArea =
            await FirebaseFireStoreConsumer.chooseAvailableParkArea(
              collectionName: FirebaseCollections.parkingAreas,
            );
        parkArea.fold((l) => emit(ParkingProcessFaild(message: l)), (parkArea) {
          emit(
            ParkingProcessSuccess(
              parkArea: ParkAreaModel.fromJson(
                parkArea.data() as Map<String, dynamic>,
              ),
            ),
          );
          log('park area is ${parkArea['id']}');
          CachedData.setData(
            key: KeysManager.available,
            value: parkArea['available'],
          );
          CachedData.setData(key: KeysManager.floor, value: parkArea['floor']);
          CachedData.setData(key: KeysManager.id, value: parkArea['id']);
          CachedData.setData(
            key: KeysManager.parkNumber,
            value: parkArea['parkNumber'],
          );
          CachedData.setData(key: KeysManager.spot, value: parkArea['spot']);
          CachedData.setData(
            key: KeysManager.userId,
            value: parkArea['userId'],
          );
          CachedData.setData(key: KeysManager.zone, value: parkArea['zone']);
          CachedData.setData(
            key: KeysManager.startTime,
            value: parkArea['startTime'],
          );
          FirebaseFireStoreConsumer.setSpecificField(
            collectionName: FirebaseCollections.parkingAreas,
            documentId: parkArea['id'],
            data: {
              'available': false,
              'startTime': FieldValue.serverTimestamp(),
            },
          );
        });
        CachedData.setData(key: KeysManager.userIsUsingService, value: true);
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
        emit(ParkingProcessFaild(message: 'Elevator is not available now'));
      }
    } else {
      emit(ParkingProcessFaild(message: 'opps, something went wrong'));
    }
  }
}
