import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum representing the different states of the application
enum AppState {
  /// User is viewing the onboarding slides
  onboarding,

  /// User is on the sign-in screen
  signIn,

  /// User is on the sign-up screen
  signUp,

  /// User is on the main dashboard
  dashboard,
}

/// Model for managing global application state using ChangeNotifier
/// This class handles state transitions, loading states, and validation
class AppStateModel extends ChangeNotifier {
  AppState _currentState = AppState.onboarding;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  static const String _prefsKey = 'app_state';

  /// Current state of the application
  AppState get currentState => _currentState;

  /// Whether the app is currently loading
  bool get isLoading => _isLoading;

  /// Current error message, if any
  String? get errorMessage => _errorMessage;

  /// Whether the model has loaded any persisted state
  bool get isInitialized => _isInitialized;

  /// Load persisted state from SharedPreferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_prefsKey);
      if (stored != null) {
        _currentState = _fromString(stored) ?? AppState.onboarding;
      }
    } catch (_) {
      // Ignore persistence errors; continue with default state
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Navigate to a new state with validation
  ///
  /// [newState] The state to transition to
  /// [validate] Whether to validate the transition (default: true)
  void navigateToState(AppState newState, {bool validate = true}) {
    if (validate && !_isValidTransition(_currentState, newState)) {
      _setError('Invalid state transition from $_currentState to $newState');
      return;
    }

    _clearError();
    _currentState = newState;
    _persistState();
    notifyListeners();
  }

  /// Set the loading state
  ///
  /// [loading] Whether the app should be in loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set an error message
  ///
  /// [message] The error message to display
  void setError(String message) {
    _setError(message);
  }

  /// Clear the current error message
  void clearError() {
    _clearError();
  }

  /// Reset the app state to initial state (onboarding)
  void reset() {
    _currentState = AppState.onboarding;
    _isLoading = false;
    _clearError();
    _persistState();
    notifyListeners();
  }

  /// Complete onboarding and navigate to sign-in
  void completeOnboarding() {
    navigateToState(AppState.signIn);
  }

  /// Navigate to sign-up from sign-in
  void navigateToSignUp() {
    navigateToState(AppState.signUp);
  }

  /// Navigate back to sign-in from sign-up
  void navigateToSignIn() {
    navigateToState(AppState.signIn);
  }

  /// Complete authentication and navigate to dashboard
  void completeAuthentication() {
    // Allow transition to dashboard regardless of current state during auth completion
    navigateToState(AppState.dashboard, validate: false);
  }

  /// Sign out and return to sign-in
  void signOut() {
    navigateToState(AppState.signIn);
  }

  /// Perform an async operation with loading state management
  ///
  /// [operation] The async operation to perform
  /// [onSuccess] Optional callback for successful completion
  /// [onError] Optional callback for error handling
  Future<T?> performAsyncOperation<T>(
    Future<T> Function() operation, {
    void Function(T result)? onSuccess,
    void Function(String error)? onError,
  }) async {
    setLoading(true);
    _clearError();

    try {
      final result = await operation();
      setLoading(false);
      onSuccess?.call(result);
      return result;
    } catch (e) {
      setLoading(false);
      final errorMessage = e.toString();
      _setError(errorMessage);
      onError?.call(errorMessage);
      return null;
    }
  }

  /// Validate if a state transition is allowed
  ///
  /// [from] Current state
  /// [to] Target state
  /// Returns true if the transition is valid
  bool _isValidTransition(AppState from, AppState to) {
    // Define valid state transitions
    const validTransitions = {
      AppState.onboarding: [AppState.signIn],
      AppState.signIn: [
        AppState.signUp,
        AppState.dashboard,
        AppState.onboarding,
      ],
      AppState.signUp: [AppState.signIn, AppState.dashboard],
      AppState.dashboard: [AppState.signIn, AppState.onboarding],
    };

    return validTransitions[from]?.contains(to) ?? false;
  }

  /// Set error message and notify listeners
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message and notify listeners
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> _persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, _currentState.name);
    } catch (_) {
      // Ignore persistence failures
    }
  }

  AppState? _fromString(String value) {
    for (final s in AppState.values) {
      if (s.name == value) return s;
    }
    return null;
  }
}
