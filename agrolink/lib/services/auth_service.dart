import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registro con email y contraseña
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error en el registro: $e');
      return null;
    }
  }

  // Inicio de sesión
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Usuario actual
  User? get currentUser => _auth.currentUser;
}