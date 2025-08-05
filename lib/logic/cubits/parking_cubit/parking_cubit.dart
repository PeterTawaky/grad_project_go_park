import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import '../../../cached/cache_helper.dart';
import '../../../core/utils/keys_manager.dart';
import '../../../firebase/firebase_collections.dart';
import '../../../firebase/flutter_fire_store_consumer.dart';
import '../../../model/park_area_model.dart';

part 'parking_state.dart';

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingInitial());

  startParkingProcess() async {
    DatabaseReference ref = await FirebaseDatabase.instance.ref();
    DataSnapshot isElevatorAvailable = await ref
        .child('isElevatorAvailable')
        .get();

    if (isElevatorAvailable.value == 1) {
      final parkArea = await FirebaseFireStoreConsumer.chooseAvailableParkArea(
        collectionName: FirebaseCollections.parkingAreas,
      );
      parkArea.fold((l) => emit(ParkingProcessFaild(message: l)), (
        parkArea,
      ) async {
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
        CachedData.setData(key: KeysManager.userId, value: parkArea['userId']);
        CachedData.setData(key: KeysManager.zone, value: parkArea['zone']);
        CachedData.setData(
          key: KeysManager.startTime,
          value: parkArea['startTime'],
        );
        FirebaseFireStoreConsumer.setSpecificField(
          collectionName: FirebaseCollections.parkingAreas,
          documentId: parkArea['id'],
          data: {'available': false, 'startTime': FieldValue.serverTimestamp()},
        );
        await ref.update({
          "isElevatorAvailable": 0,
          'status': 1,
          'parkingPlace': parkArea['parkNumber'],
        });
      });
      CachedData.setData(key: KeysManager.userIsUsingService, value: true);
    } else {
      emit(ParkingProcessFaild(message: 'Elevator is not available now'));
    }
  }
}
