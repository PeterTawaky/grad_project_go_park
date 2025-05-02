import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_garage_final_project/model/elevator_model.dart';

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
  static
  // Future<Either<String, QuerySnapshot<Object?>>>
  getGeneralDocuments({required String collectionName}) async {
    try {
      QuerySnapshot response = await fireStore.collection(collectionName).get();
      return response.docs;
      // return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      // return Left(e.toString());
    }
  }

  //!=====================================================================
  static
  // Future<Either<String, QuerySnapshot<Object?>>>
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
      return response.docs;
      // return Right(response);
    } catch (e) {
      log('error is ${e.toString()}');
      // return Left(e.toString());
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

  static Future<void> deleteListofData({
    // required List<Map<String, dynamic>> dataList,
    required String collectionName,
  }) async {
    CollectionReference users = FirebaseFirestore.instance.collection(
      collectionName,
    );
    final dataList = await FirebaseFireStoreConsumer.getGeneralDocuments(
      collectionName: collectionName,
    );
    // log(dataList.toString());
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (int i = 1; i <= dataList.length; i++) {
      batch.delete(
        FirebaseFirestore.instance
            .collection(collectionName)
            .doc(dataList[i - 1]['id']),
      );
      // batch.delete(
      //   FirebaseFirestore.instance
      //       .collection(collectionName)
      //       .doc(dataList[i - 1]['id']),
      //   dataList[i - 1],
      // );
    }
    return batch.commit(); //responsible for executing the batch
  }

  static createRealTimeCollection({required String collectionName}) {
    final Stream<QuerySnapshot> collectionStream =
        FirebaseFirestore.instance.collection(collectionName).snapshots();
  }
}
