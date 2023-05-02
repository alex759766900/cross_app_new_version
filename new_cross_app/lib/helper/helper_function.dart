import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static final CollectionReference tradieRef =
      FirebaseFirestore.instance.collection('tradeperson');
  static final CollectionReference consumerRef =
      FirebaseFirestore.instance.collection('customers');
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userIDKey = "USERIDKEY";
  static String userIdKey = "USEREIDKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserIdSF(String userId) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userIDKey, userId);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userIDKey);
  }

  static Future<String?> getUserNameFromId(String userId) async {
    String userName='';
    tradieRef.get().then((querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          if(docSnapshot.id==userId){
            if(docSnapshot.data()!=null){
              var data = docSnapshot.data() as Map<String, dynamic>;
              userName=data['fullName'];

              return userName;
            }
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    consumerRef.get().then((querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        if(docSnapshot.id==userId){
          if(docSnapshot.data()!=null){
            userName=docSnapshot['fullName'];

            return userName;
          }
        }
      }

    },
      onError: (e) => print("Error completing: $e"),
    );



  }
}
