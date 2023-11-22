import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  bool _isValidEmail(String email) {
    return email.contains('@');
  }
  bool _isValidPassword(String password) {
    return password.length >= 8;
  }
  bool _isValidName(String name) {
    return name.isNotEmpty;
  }
  Future<String?> registration({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else if (email.isEmpty || password.isEmpty  || name.isEmpty) {
        return'Please fill in all fields.';
      }
      else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      }
      else if (email.isEmpty || password.isEmpty) {
        return'Please fill in all fields.';
      }
      else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}

