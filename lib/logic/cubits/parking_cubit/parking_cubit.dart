import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:smart_garage_final_project/firebase/firebase_collections.dart';
import 'package:smart_garage_final_project/model/elevator_model.dart';
import 'package:smart_garage_final_project/model/park_area_model.dart';

part 'parking_state.dart';

// class ParkingCubit extends Cubit<ParkingState> {
//   final DatabaseReference _elevatorRef;
//   StreamSubscription? _subscription;

//   ParkingCubit()
//     : _elevatorRef = FirebaseDatabase.instanceFor(
//         app: Firebase.app(),
//         databaseURL: 'https://go-park-df349.firebaseio.com', // Add this
//       ).ref('Elevator/elv'),
//       super(ParkingInitial()) {
//     _setupConnection();
//   }
//   void _setupConnection() {
//     // Enable persistence
//     FirebaseDatabase.instance.setPersistenceEnabled(true);

//     // Configure retry logic
//     _elevatorRef.onValue.listen(
//       (event) {
//         // Handle data
//       },
//       onError: (error) {
//         if (error is FirebaseException && error.code == 'connection_failed') {
//           // Implement retry logic
//           Future.delayed(Duration(seconds: 3), _setupConnection);
//         }
//       },
//     );
//   }

//   void _startListening() {
//     _subscription = _elevatorRef.onValue.listen(
//       (event) {
//         final data = event.snapshot.value;
//         log(data.toString());
//         if (data != null) {
//           emit(
//             ElevatorDataLoaded(
//               elevatorData: ElevatorModel.fromJson(
//                 data as Map<String, dynamic>,
//               ),
//             ),
//           );
//         } else {
//           log('No data found');
//           emit(ElevatorDataError(errorMsg: 'No data found'));
//         }
//       },
//       onError: (error) {
//         log(error.toString());
//         emit(ElevatorDataError(errorMsg: error.toString()));
//       },
//     );
//   }

//   @override
//   Future<void> close() {
//     _subscription?.cancel();
//     return super.close();
//   }
// }
class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingInitial()) {
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
}
