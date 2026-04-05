import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ================= REGISTER =================
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String region,
  }) async {
    try {
      emit(AuthLoading());
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'region': region,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Auth error"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  /// ================= LOGIN =================
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        emit(AuthError("User not found"));
        return;
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  /// ================= SEND RESET PASSWORD LINK =================
  /// ترجع رابط Dynamic Link جاهز للاستخدام
  Future<void> sendResetPasswordLink(String email) async {
    try {
      emit(AuthLoading());

      await _auth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: "https://nabtah-54595.firebaseapp.com",
          handleCodeInApp: false,
          androidPackageName: "com.example.nabtah",
          androidInstallApp: true,
        ),
      );

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Reset failed"));
    } catch (e) {
      emit(AuthError("Something went wrong"));
    }
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
  }
}
