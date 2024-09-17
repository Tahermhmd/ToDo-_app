import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/tasks_model.dart';

import '../../../models/user_model.dart';

class FirebaseManager {
  static CollectionReference<TasksModel> getTaskCollection() {
    return FirebaseFirestore.instance.collection("Tasks").withConverter(
        fromFirestore: (snapshot, _) {
      return TasksModel.fromJson(snapshot.data()!);
    }, toFirestore: (task, _) {
      //task is object from datamodel class TaskModel
      return task.toJson();
    });
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance.collection("User").withConverter(
        fromFirestore: (snapshot, _) {
      return UserModel.fromJson(snapshot.data()!);
    }, toFirestore: (user, _) {
      //user is object from datamodel class usermodel
      return user.toJson();
    });
  }

  static Future<void> addTask(TasksModel task) {
    var collection = getTaskCollection();
    var docReference = collection.doc();
    task.id = docReference.id;
    return docReference.set(task);
  }

  //I will call this function during the creation of a new account
  static Future<void> addUserToFirestore(UserModel user) {
    var userCollection = getUserCollection();
    var docReference = userCollection.doc(user
        .id); // the id here won't be auto generated i will take the id that comes from authentication
    return docReference.set(user);
  }

  static Future<UserModel?> readUser(String id) async {
    DocumentSnapshot<UserModel> user = await getUserCollection().doc(id).get();
    return user.data();
  }

  static Stream<QuerySnapshot<TasksModel>> getTask(DateTime date) {
    return getTaskCollection()
        .where("date",
            isEqualTo: DateUtils.dateOnly(date).millisecondsSinceEpoch)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Future<void> deleteTask(String taskId) {
    return getTaskCollection().doc(taskId).delete();
  }

  static Future<void> editTask(TasksModel model) {
    return getTaskCollection().doc(model.id).update(model.toJson());
  }

  static void updateFinishedTasks(String taskId, bool isDone) {
    getTaskCollection().doc(taskId).update({"isDone": isDone});
  }

  static Future<void> createAccount(
      String name,
      String phoneNumber,
      String email,
      String password,
      Function onSuccess,
      Function onError) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user!.sendEmailVerification();
      UserModel user = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber);
      addUserToFirestore(user);
      onSuccess();
      //credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError(e.message);
      } else if (e.code == 'email-already-in-use') {
        onError(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> login(String email, String password, Function onSuccess,
      Function onError) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.emailVerified) {
        onSuccess();
      } else {
        onError("Email isn't verified");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        onError("Wrong email or password");
      }
    }
  }
}
