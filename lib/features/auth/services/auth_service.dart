import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:email_validator/email_validator.dart';
import '../models/user.dart';
import '../models/auth_exception.dart';

/// Service class for handling user authentication operations using Firebase
class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  /// Signs in a user with email and password
  ///
  /// Throws [AuthException] for validation errors or authentication failures
  Future<User> signIn(String email, String password) async {
    try {
      // Validate input fields
      _validateSignInInput(email, password);

      // Sign in with Firebase Auth
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Convert Firebase user to our User model
      return _firebaseUserToUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException.unknown(e);
    }
  }

  /// Signs up a new user with email, password, and optional name
  ///
  /// Throws [AuthException] for validation errors or if user already exists
  Future<User> signUp(String email, String password, {String? name}) async {
    try {
      // Validate input fields
      _validateSignUpInput(email, password, name);

      // Create user with Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (name != null && name.trim().isNotEmpty) {
        await credential.user!.updateDisplayName(name.trim());
      }

      // Convert Firebase user to our User model
      return _firebaseUserToUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException.unknown(e);
    }
  }

  /// Validates sign-in input parameters
  void _validateSignInInput(String email, String password) {
    // Check for empty fields
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw AuthException.emptyFields();
    }

    // Validate email format
    if (!EmailValidator.validate(email.trim())) {
      throw AuthException.invalidEmail();
    }
  }

  /// Validates sign-up input parameters
  void _validateSignUpInput(String email, String password, String? name) {
    // Check for empty required fields
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw AuthException.emptyFields();
    }

    // Validate email format
    if (!EmailValidator.validate(email.trim())) {
      throw AuthException.invalidEmail();
    }

    // Validate password strength
    if (password.length < 6) {
      throw AuthException.weakPassword();
    }

    // Validate name if provided
    if (name != null && name.trim().isEmpty) {
      throw const AuthException(
        'Name cannot be empty if provided',
        'INVALID_NAME',
      );
    }
  }

  /// Converts Firebase User to our User model
  User _firebaseUserToUser(firebase_auth.User firebaseUser) {
    return User.fromJson({
      'id': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'name': firebaseUser.displayName,
      'createdAt':
          firebaseUser.metadata.creationTime?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Handles Firebase Auth exceptions and converts them to AuthException
  AuthException _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
        return AuthException.wrongPassword();
      case 'email-already-in-use':
        return AuthException.emailAlreadyExists();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'invalid-email':
        return AuthException.invalidEmail();
      case 'user-disabled':
        return const AuthException(
          'This account has been disabled',
          'USER_DISABLED',
        );
      case 'too-many-requests':
        return const AuthException(
          'Too many requests. Please try again later',
          'TOO_MANY_REQUESTS',
        );
      default:
        return AuthException.unknown(e);
    }
  }

  /// Signs up with password confirmation validation
  ///
  /// Throws [AuthException] if passwords don't match
  Future<User> signUpWithConfirmation(
    String email,
    String password,
    String confirmPassword, {
    String? name,
  }) async {
    // Validate password confirmation
    if (password != confirmPassword) {
      throw AuthException.passwordMismatch();
    }

    return signUp(email, password, name: name);
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Gets the current authenticated user
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return _firebaseUserToUser(firebaseUser);
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _firebaseUserToUser(firebaseUser);
    });
  }

  /// Checks if a user is currently signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;
}
