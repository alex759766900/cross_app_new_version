import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_cross_app/helper/helper_function.dart';
import 'package:new_cross_app/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign up for customer uesr
  Future registerCustomerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      //
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //user.sendEmailVerification();

      if (user != null) {
        //call out database to update the user data
        await DatabaseService(uid: user.uid)
            .savingCustomerData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign up for trade person uesr
  Future registerTradepersonWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        //call out database to update the user data
        await DatabaseService(uid: user.uid).savingTradieData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserIdSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
