import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sami_project/common/back_end_configs.dart';
import 'package:sami_project/infrastructure/models/teacherModel.dart';
import 'package:sami_project/infrastructure/models/userModel.dart';
import 'package:sami_project/infrastructure/services/updateLocalStorageServices.dart';

class UserServices {
  ///Instantiate LocalDB
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  // UserModel _bikerModel = UserModel();
  //
  // UserModel get bikerModel => _bikerModel;
  UpdateLocalStorageData _data = UpdateLocalStorageData();

  ///Collection Reference of Students
  final CollectionReference _stdRef =
      FirebaseFirestore.instance.collection('students');

  ///Collection Reference of Teachers
  final CollectionReference _teRef =
      FirebaseFirestore.instance.collection('teachers');

  ///Add Teachers Data
  Future<void> addTeacherData(
      User user, TeacherModel teacherModel, BuildContext context) {
    return _teRef.doc(user.uid).set(teacherModel.toJson(user.uid));
  }

  ///Add Students Data
  Future<void> addStudentData(
      User user, StudentModel stdModel, BuildContext context) {
    return _stdRef.doc(user.uid).set(stdModel.toJson(user.uid));
  }

  ///Stream a Teacher
  Stream<TeacherModel> streamTeacherData(String docID) {
    print("I am $docID");
    return _teRef
        .doc(docID)
        .snapshots()
        .map((snap) => TeacherModel.fromJson(snap.data()));
  }

  ///Stream a Students
  Stream<StudentModel> streamStudentsData(String docID) {
    print("I am $docID");
    return _stdRef
        .doc(docID)
        .snapshots()
        .map((snap) => StudentModel.fromJson(snap.data()));
  }
}
