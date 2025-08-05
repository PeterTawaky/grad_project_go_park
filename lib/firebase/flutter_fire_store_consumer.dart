import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/elevator_model.dart';

class FirebaseFireStoreConsumer {
  static final fireStore = FirebaseFirestore.instance;
  static Future<Either<String, DocumentReference<Object?>>> addGeneralDocument({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      DocumentReference response = await fireStore
          .collection(collectionName)
          .add(data);
      return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, DocumentReference<Object?>>>
  addSpecificDocument({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['userId'] = FirebaseAuth.instance.currentUser!.uid; //user id
      DocumentReference response = await fireStore
          .collection(collectionName)
          .add(data);
      return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, List<QueryDocumentSnapshot<Object?>>>>
  getGeneralDocuments({required String collectionName}) async {
    try {
      QuerySnapshot response = await fireStore.collection(collectionName).get();
      // return response.docs;
      return Right(response.docs);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, List<QueryDocumentSnapshot<Object?>>>>
  getSpecificDocuments({required String collectionName}) async {
    try {
      log(FirebaseAuth.instance.currentUser!.uid);
      QuerySnapshot response =
          await fireStore
              .collection(collectionName)
              .where(
                'userId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();
      // return response.docs;
      return Right(response.docs);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static
  // Future<Map<String, dynamic>?>
  getDocumentData({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(documentId)
              .get();

      if (docSnapshot.exists) {
        // This will return the data as a Map<String, dynamic>
        // return docSnapshot.data() as Map<String, dynamic>;
        return docSnapshot;
        // return docSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Document not found");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  //!=====================================================================
  static deleteDocument({
    required String collectionName,
    required String doxumentId,
  }) async {
    try {
      await fireStore.collection(collectionName).doc(doxumentId).delete();
    } catch (e) {
      log('error is ${e.toString()}');
    }
  }

  //!=====================================================================
  static Future<Either<String, bool>> updateUserData({
    required String collectionName,
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName) // collection
          .doc(documentId) // document ID
          .update(data);
      return Right(true);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, bool>> setUserData({
    required String collectionName,
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      data['userId'] = FirebaseAuth.instance.currentUser!.uid; //user id
      await FirebaseFirestore.instance
          .collection(collectionName) // collection
          .doc(documentId) // document ID
          .set(data);
      return Right(true);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, bool>> setSpecificField({
    required String collectionName,
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      data['userId'] = FirebaseAuth.instance.currentUser!.uid; //user id
      await FirebaseFirestore.instance
          .collection(collectionName) // collection
          .doc(documentId) // document ID
          .set(data, SetOptions(merge: true));
      return Right(true);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static
  // Future<Either<String, QuerySnapshot<Object?>>>
  getSubDocuments({
    required String collectionName,
    required String documentId,
    required String subCollectionName,
  }) async {
    try {
      QuerySnapshot response =
          await fireStore
              .collection(collectionName)
              .doc(documentId)
              .collection(subCollectionName)
              .get();
      return response;
      // return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      // return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<Either<String, DocumentReference<Object?>>> addSubDocument({
    required String collectionName,
    required String documentId,
    required String subCollectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['userId'] = FirebaseAuth.instance.currentUser!.uid; //user id
      DocumentReference response = await fireStore
          .collection(collectionName)
          .doc(documentId)
          .collection(subCollectionName)
          .add(data);
      return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      return Left(e.toString());
    }
  }

  //!=====================================================================
  static Future<void> setListofData({
    required List<Map<String, dynamic>> dataList,
    required String collectionName,
  }) {
    CollectionReference users = FirebaseFirestore.instance.collection(
      collectionName,
    );

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(
      FirebaseFirestore.instance.collection('Elevator').doc('elv'),
      ElevatorModel(userId: '', available: true, parkSection: '').toJson(),
    );
    for (int i = 1; i <= dataList.length; i++) {
      batch.set(
        FirebaseFirestore.instance
            .collection(collectionName)
            .doc(dataList[i - 1]['id']),
        dataList[i - 1],
      );
    }
    return batch.commit(); //responsible for executing the batch
  }

  // static chooseAvailableParkArea({required String collectionName}) async {
  //   QuerySnapshot placeToPark =
  //       await fireStore
  //           .collection(collectionName)
  //           .where('occupied', isEqualTo: false)
  //           .orderBy('parkNumber')
  //           .limit(1)
  //           .get();
  //   if (placeToPark.docs.isNotEmpty) {
  //     return placeToPark.docs.first; //return the first document
  //   } else if (placeToPark.docs.isEmpty) {
  //     //TODO return message to the cubit
  //     log('there is no place to park');
  //     return null;
  //   }
  // }
  static Future<Either<String, DocumentSnapshot<Object?>>>
  chooseAvailableParkArea({required String collectionName}) async {
    try {
      QuerySnapshot placeToPark =
          await fireStore
              .collection(collectionName)
              .where('available', isEqualTo: true)
              // .orderBy('parkNumber') // removed to avoid index requirement
              .limit(1)
              .get();

      if (placeToPark.docs.isNotEmpty) {
        return Right(placeToPark.docs.first);
      } else {
        log('There is no place to park');
        return Left('There is no place to park');
      }
    } catch (e) {
      log('Error in chooseAvailableParkArea: $e');
      return Left('Error in chooseAvailableParkArea: $e');
    }
  }

  // static Future<void> deleteListofData({
  //   // required List<Map<String, dynamic>> dataList,
  //   required String collectionName,
  // }) async {
  //   CollectionReference users = FirebaseFirestore.instance.collection(
  //     collectionName,
  //   );
  //   final dataList = await FirebaseFireStoreConsumer.getGeneralDocuments(
  //     collectionName: collectionName,
  //   );
  //   // log(dataList.toString());
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   for (int i = 1; i <= dataList.length; i++) {
  //     batch.delete(
  //       FirebaseFirestore.instance
  //           .collection(collectionName)
  //           .doc(dataList[i - 1]['id']),
  //     );
  //     // batch.delete(
  //     //   FirebaseFirestore.instance
  //     //       .collection(collectionName)
  //     //       .doc(dataList[i - 1]['id']),
  //     //   dataList[i - 1],
  //     // );
  //   }
  //   return batch.commit(); //responsible for executing the batch
  // }

  // static createRealTimeCollection({required String collectionName}) {
  //   final Stream<QuerySnapshot> collectionStream =
  //       FirebaseFirestore.instance.collection(collectionName).snapshots();
  // }
}
