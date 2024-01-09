import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required var context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'secondary', options: Firebase.app().options);

    try {
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
                .createUserWithEmailAndPassword(
                    email: email, password: password);

        
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        /*
        Alert(
          context: context,
          type: AlertType.error,
          title: "Register error",
          desc: "The password provided is too weak.",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
        */
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        /*
        Alert(
          context: context,
          type: AlertType.error,
          title: "Register error",
          desc: "The account already exists for that email.",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
        */
      }
    } catch (e) {
      print(e);
    }
    app.delete();
    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required var context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Alert(
          context: context,
          type: AlertType.error,
          title: "Login error",
          desc: "No user found for that email.",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        Alert(
          context: context,
          type: AlertType.error,
          title: "Login error",
          desc: "Wrong password provided.",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}