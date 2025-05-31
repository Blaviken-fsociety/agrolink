import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registerUser(
    String email,
    String password, {
    required String name,
    required String phone,
    required String zone,
    required List<String> availability,
    String role = 'user', // Por defecto los usuarios registrados son 'user'
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Guardar datos adicionales en Firestore
        await _db.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'zone': zone,
          'availability': availability,
          'role': role, // 'user' o 'admin'
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print('Error en registerUser: $e'); // Para depuración
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error en login: $e'); // Para depuración
      return null;
    }
  }

  /// Verifica si un usuario es administrador
  Future<bool> isUserAdmin(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String role = userData['role'] ?? 'user'; // Por defecto 'user' si no existe el campo
        return role == 'admin';
      }
      
      return false; // Si el documento no existe, no es admin
    } catch (e) {
      print('Error en isUserAdmin: $e');
      return false; // En caso de error, asumir que no es admin por seguridad
    }
  }

  /// Obtiene el rol del usuario actual
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['role'] ?? 'user'; // Por defecto 'user'
      }
      
      return 'user'; // Si el documento no existe, asumir 'user'
    } catch (e) {
      print('Error en getUserRole: $e');
      return 'user'; // En caso de error, asumir 'user'
    }
  }

  /// Actualiza el rol de un usuario (solo para administradores)
  Future<bool> updateUserRole(String uid, String newRole) async {
    try {
      await _db.collection('users').doc(uid).update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error en updateUserRole: $e');
      return false;
    }
  }

  /// Obtiene datos completos del usuario
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      print('Error en getUserData: $e');
      return null;
    }
  }

  /// Cierra sesión del usuario actual
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error en signOut: $e');
    }
  }

  /// Obtiene el usuario actualmente autenticado
  User? get currentUser => _auth.currentUser;

  /// Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
